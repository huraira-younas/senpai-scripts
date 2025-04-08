import 'package:glmpse/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileStatusIcon extends StatelessWidget {
  final double size;
  final String? activeIcon;
  final Color? activeBgColor;
  final Color? activeColor;
  const ProfileStatusIcon({
    this.activeBgColor,
    this.activeColor,
    this.activeIcon,
    this.size = 12,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: activeColor ?? Colors.white, width: 1.7),
        color: activeBgColor ?? AppColors.greenColor,
        shape: BoxShape.circle,
      ),
      child: activeIcon == null
          ? null
          : Image.asset(color: Colors.white, activeIcon!),
    );
  }
}
