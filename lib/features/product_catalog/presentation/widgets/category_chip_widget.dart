import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CategoryChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;

  const CategoryChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    // Jika activeColor tidak diisi, otomatis pakai warna hijau bawaan
    final themeColor = activeColor ?? AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? themeColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? themeColor : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: themeColor.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
