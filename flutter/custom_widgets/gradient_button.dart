import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/constants/app_contants.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:glmpse/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final (double, double) padding;
  final Function()? onPressed;
  final double? borderWidth;
  final Color? borderColor;
  final Color? textColor;
  final Color? bgColor;
  final IconData? icon;
  final bool isLoading;
  final double radius;
  final double? width;
  final String text;
  const CustomButton({
    this.padding = (20, 14),
    this.isLoading = false,
    required this.text,
    this.radius = 30,
    this.borderColor,
    this.borderWidth,
    this.onPressed,
    this.textColor,
    this.bgColor,
    this.width,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final kWidth = MediaQuery.sizeOf(context).width;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: bgColor ?? AppColors.primaryColor,
        disabledBackgroundColor: const Color(0xFFF4F5F9),
        minimumSize: Size(width ?? kWidth, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: borderColor != null
              ? BorderSide(
                  color: borderColor ?? AppColors.primaryColor,
                  width: borderWidth ?? 2,
                )
              : BorderSide.none,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: padding.$1,
          vertical: padding.$2 + 2,
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: AppConstants.animDur),
        child: isLoading
            ? const SizedBox(
                height: 23,
                width: 23,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: MyText(
                      text: text,
                      color: onPressed == null
                          ? AppColors.greyColor.withOpacity(0.3)
                          : textColor ?? AppColors.whiteColor,
                      size: AppConstants.subtitle,
                      family: AppFonts.bold,
                      isCenter: true,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 4),
                    Icon(icon!, size: 20, color: Colors.white),
                  ]
                ],
              ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;
  final IconData? icon;
  final (double, double) padding;
  final bool isLoading;
  final double? width;

  const GradientButton({
    super.key,
    this.onPressed,
    this.icon,
    this.bgColor,
    this.textColor,
    this.borderColor,
    this.isLoading = false,
    this.padding = (20, 12),
    this.width,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final kWidth = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        constraints: BoxConstraints(minWidth: width ?? kWidth),
        decoration: BoxDecoration(
          color: bgColor,
          // gradient: bgColor != null ? null : AppColors.gradient,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: borderColor ?? AppColors.primaryColor,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: padding.$1,
          vertical: padding.$2,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: AppConstants.animDur),
          child: isLoading
              ? const SizedBox(
                  height: 23,
                  width: 23,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText(
                      text: text,
                      color: textColor ?? AppColors.whiteColor,
                      size: AppConstants.subtitle,
                      family: AppFonts.bold,
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 4),
                      Icon(icon!, size: 20, color: Colors.white),
                    ]
                  ],
                ),
        ),
      ),
    );
  }
}

class BottomShadowButton extends StatelessWidget {
  final Color? bottomBgColor;
  final Color? shadowColor;
  final String text;
  final bool btmFirst;
  final Color? bgColor;
  final bool isLoading;
  final Widget? button;
  final Color? textColor;
  final Widget? btmWidget;
  final Color? borderColor;
  final Function()? onPressed;
  const BottomShadowButton({
    super.key,
    this.button,
    this.bgColor,
    this.btmWidget,
    this.textColor,
    this.borderColor,
    this.shadowColor,
    required this.text,
    this.bottomBgColor,
    this.btmFirst = false,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isBtm = btmWidget != null;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.padding + 10,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: bottomBgColor ?? Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(
              color: (shadowColor ?? AppColors.greyColor).withOpacity(0.1),
              width: 2,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isBtm && btmFirst) ...[
              btmWidget!,
              const SizedBox(height: 10),
            ],
            Align(
              alignment: Alignment.bottomCenter,
              child: button ??
                  CustomButton(
                    text: text,
                    bgColor: bgColor,
                    textColor: textColor,
                    onPressed: onPressed,
                    isLoading: isLoading,
                    borderColor: borderColor,
                  ),
            ),
            if (isBtm && !btmFirst) ...[
              const SizedBox(height: 10),
              btmWidget!,
            ],
          ],
        ),
      ),
    );
  }
}
