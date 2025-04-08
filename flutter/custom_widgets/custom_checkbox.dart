import 'package:flutter/material.dart';
import 'package:glmpse/constants/app_colors.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isChecked;
  final bool isCircle;
  final Color? borderColor;
  const CustomCheckBox({
    super.key,
    required this.isChecked,
    this.borderColor,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      padding: EdgeInsets.all(isCircle ? 3 : 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: isChecked
              ? AppColors.primaryColor
              : (borderColor ?? AppColors.primaryColor),
          width: 2,
        ),
        color: isChecked && !isCircle ? AppColors.primaryColor : null,
        borderRadius: BorderRadius.circular(isCircle ? 50 : 5),
      ),
      child: isChecked
          ? isCircle
              ? Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                )
              : const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                )
          : null,
    );
  }
}
