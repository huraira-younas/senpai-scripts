import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/constants/app_contants.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:glmpse/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class TitleBuilder extends StatelessWidget {
  final String desc;
  final Color color;
  final String title;
  final String? subText;
  final double topMargin;
  final String? coloredText;
  final double bottomMargin;
  const TitleBuilder({
    this.color = AppColors.primaryColor,
    this.bottomMargin = 60,
    this.topMargin = 0.1,
    required this.title,
    required this.desc,
    this.coloredText,
    this.subText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(
        top: size.height * topMargin,
        bottom: bottomMargin,
        right: 20,
        left: 20,
      ),
      child: Column(
        children: [
          MyText(
            size: MediaQuery.sizeOf(context).width * 0.06,
            family: AppFonts.semibold,
            isCenter: true,
            text: title,
          ),
          const SizedBox(height: 10),
          MyText(
            text: desc,
            size: AppConstants.subtitle,
            color: AppColors.greyColor,
            isCenter: true,
          ),
          if (coloredText != null)
            MyText(
              text: coloredText!,
              isCenter: true,
              color: color,
            ),
          if (subText != null)
            MyText(
              family: AppFonts.semibold,
              text: subText!,
              isCenter: true,
            ),
        ],
      ),
    );
  }
}
