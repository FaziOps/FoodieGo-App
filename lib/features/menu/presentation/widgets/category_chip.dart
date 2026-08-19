import 'package:flutter/material.dart';
import 'package:restaurant_app/features/menu/domain/entities/category_entity.dart';

class CategoryChipRow extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelected;

  const CategoryChipRow({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    final allCategories = [
      null, // "All"
      ...categories.map((c) => c.id),
    ];

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final catId = allCategories[index];
          final isSelected = catId == selectedCategoryId;
          
          String labelName = 'All';
          if (catId != null) {
            final matches = categories.where((c) => c.id == catId);
            labelName = matches.isNotEmpty ? matches.first.name : 'Category';
          }

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => onSelected(catId),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: darkSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected ? secondaryOrange : Colors.white.withValues(alpha: 0.1),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryOrange.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(
                        Icons.check,
                        size: 16,
                        color: secondaryOrange,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      labelName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? creamText : creamText.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
