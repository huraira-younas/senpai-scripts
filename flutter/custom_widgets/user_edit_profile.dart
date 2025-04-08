import 'package:flutter/material.dart';
import 'package:glmpse/common_widget/profile_avt.dart';
import 'package:glmpse/constants/app_assets.dart';
import 'package:glmpse/constants/app_colors.dart';

class UserEditProfile extends StatelessWidget {
  final String url;
  final double size;
  final double iconSize;
  final VoidCallback onEdit;
  const UserEditProfile({
    super.key,
    required this.url,
    required this.onEdit,
    this.size = 120,
    this.iconSize = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ProfileAvt(
          verified: false,
          size: size,
          url: url,
        ),
        Positioned(
          right: -4,
          bottom: 0,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: onEdit,
            icon: Image.asset(AppAssets.edit, height: 16),
          ),
        )
      ],
    );
  }
}
