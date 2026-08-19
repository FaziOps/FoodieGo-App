import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int stars;
  final ValueChanged<int> onChanged;
  final double size;

  const StarRatingWidget({
    super.key,
    required this.stars,
    required this.onChanged,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final filled = i < stars;
        return IconButton(
          iconSize: size,
          icon: Icon(filled ? Icons.star : Icons.star_border, color: Colors.amber),
          onPressed: () => onChanged(i + 1),
        );
      }),
    );
  }
}
