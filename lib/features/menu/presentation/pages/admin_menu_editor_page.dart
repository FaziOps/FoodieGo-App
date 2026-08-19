import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/di/injection_container.dart';
import 'package:restaurant_app/features/menu/domain/entities/menu_item_entity.dart';
import 'package:restaurant_app/features/menu/domain/usecases/add_menu_item_usecase.dart';
import 'package:restaurant_app/features/menu/domain/usecases/delete_menu_item_usecase.dart';
import 'package:restaurant_app/features/menu/presentation/bloc/menu_bloc.dart';

/// Admin-only screen. Reuses MenuBloc for the read side; writes go directly
/// through the add/delete use cases since they're simple one-shot actions
/// that don't need their own bloc state machine.
class AdminMenuEditorPage extends StatefulWidget {
  const AdminMenuEditorPage({super.key});

  @override
  State<AdminMenuEditorPage> createState() => _AdminMenuEditorPageState();
}

class _AdminMenuEditorPageState extends State<AdminMenuEditorPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  Future<void> _addItem() async {
    final price = double.tryParse(_priceController.text) ?? 0;
    final result = await sl<AddMenuItemUseCase>().call(MenuItemEntity(
      id: '',
      name: _nameController.text.trim(),
      description: '',
      price: price,
      categoryId: _categoryController.text.trim(),
      imageUrl: '',
    ));
    result.fold(
      (failure) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message))),
      (_) {
        _nameController.clear();
        _priceController.clear();
        _categoryController.clear();
        if (mounted) context.read<MenuBloc>().add(const LoadMenu());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MenuBloc>()..add(const LoadMenu()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Manage Menu')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Item name'),
                  ),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Category ID'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _addItem, child: const Text('Add item')),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<MenuBloc, MenuState>(
                builder: (context, state) {
                  if (state is! MenuLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await sl<DeleteMenuItemUseCase>()
                                .call(DeleteMenuItemParams(item.id));
                            if (context.mounted) {
                              context.read<MenuBloc>().add(const LoadMenu());
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
