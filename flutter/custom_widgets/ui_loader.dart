import 'package:glmpse/common_widget/gradient_button.dart';
import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/constants/app_assets.dart';
import 'package:glmpse/constants/app_contants.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:glmpse/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class UILoader extends StatelessWidget {
  final double? size;
  const UILoader({
    this.size = 50,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Image.asset(
        AppAssets.loadingGif,
        height: size,
      ),
    );
  }
}

class UIError extends StatelessWidget {
  final double topPad;
  final String message;
  final VoidCallback onRetry;
  const UIError({
    super.key,
    this.topPad = 0.45,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return CenterWidget(
      topPad: topPad,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: width * 0.7),
            child: Column(
              children: <Widget>[
                const Icon(
                  size: 40,
                  Icons.warning_amber_rounded,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 10),
                MyText(
                  text: message,
                  family: AppFonts.medium,
                  color: AppColors.blackColor,
                  isCenter: true,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(
            width: width * 0.3,
            onPressed: onRetry,
            text: "Retry",
          ),
        ],
      ),
    );
  }
}

class CenterWidget extends StatelessWidget {
  final Widget child;
  final double topPad;
  const CenterWidget({
    super.key,
    required this.child,
    this.topPad = 0.45,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox(
        height: size.height * topPad,
        width: size.width * 0.7,
        child: Center(child: child),
      ),
    );
  }
}

void showErrorSnack({
  required BuildContext context,
  required String message,
  Function()? onRetry,
}) {
  final retry = onRetry != null;
  final scfx = ScaffoldMessenger.of(context);
  scfx.hideCurrentSnackBar();
  scfx.showSnackBar(
    SnackBar(
      backgroundColor: AppColors.primaryColorDark,
      duration: Duration(seconds: retry ? 5 * 60 : 3),
      content: MyText(
        text: message,
        overflow: TextOverflow.ellipsis,
        size: AppConstants.subtitle,
        family: AppFonts.medium,
        color: Colors.white,
        maxLines: 2,
      ),
      action: SnackBarAction(
        textColor: Colors.white,
        onPressed: () => onRetry?.call(),
        label: !retry ? "OK" : "Retry",
      ),
    ),
  );
}
