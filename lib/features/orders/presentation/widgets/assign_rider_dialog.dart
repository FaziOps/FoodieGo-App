import 'package:flutter/material.dart';
import 'package:restaurant_app/features/rider_management/domain/entities/rider_entity.dart';

class AssignRiderDialog extends StatelessWidget {
  final List<RiderEntity> riders;
  const AssignRiderDialog({super.key, required this.riders});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Assign a rider'),
      content: SizedBox(
        width: double.maxFinite,
        child: riders.isEmpty
            ? const Text('No riders are online right now.')
            : ListView.builder(
                shrinkWrap: true,
                itemCount: riders.length,
                itemBuilder: (context, index) {
                  final rider = riders[index];
                  return ListTile(
                    title: Text(rider.name),
                    subtitle: Text('★ ${rider.averageRating.toStringAsFixed(1)}'),
                    onTap: () => Navigator.pop(context, rider.uid),
                  );
                },
              ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ],
    );
  }
}
