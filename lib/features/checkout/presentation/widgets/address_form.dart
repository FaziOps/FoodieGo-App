import 'package:flutter/material.dart';

class AddressForm extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController latController;
  final TextEditingController lngController;

  const AddressForm({
    super.key,
    required this.streetController,
    required this.latController,
    required this.lngController,
  });

  @override
  Widget build(BuildContext context) {
    const secondaryOrange = Color(0xFFE67E22);
    const darkSurface = Color(0xFF241E1C);
    const darkInputFill = Color(0xFF1A1614);
    const creamText = Color(0xFFFDF5E6);

    InputDecoration buildDecoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: creamText.withValues(alpha: 0.7), fontSize: 14),
        prefixIcon: Icon(icon, color: secondaryOrange, size: 20),
        filled: true,
        fillColor: darkInputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: secondaryOrange, width: 1.8),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on_rounded, color: secondaryOrange, size: 20),
              SizedBox(width: 8),
              Text(
                'Delivery Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: creamText),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: streetController,
            style: const TextStyle(color: creamText),
            decoration: buildDecoration('Delivery street address', Icons.home_rounded),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: latController,
                  style: const TextStyle(color: creamText),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: buildDecoration('Latitude', Icons.my_location_rounded),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: lngController,
                  style: const TextStyle(color: creamText),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: buildDecoration('Longitude', Icons.explore_rounded),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Lat/Lng lets the rider navigate directly to your coordinates.',
            style: TextStyle(fontSize: 12, color: creamText.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}
