import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/constants/app_contants.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:glmpse/constants/app_fonts.dart';
import 'package:flutter/material.dart';

AppBar customAppBar({
  bool back = true,
  String title = "",
  Widget? titleIcon,
  Function()? onBackPress,
  bool centerTitle = true,
  bool blackStatusIcons = true,
  required BuildContext context,
  List<Widget> actions = const [],
  Color bgColor = Colors.transparent,
  Color iconColor = AppColors.blackColor,
}) {
  return AppBar(
    systemOverlayStyle: blackStatusIcons
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light,
    backgroundColor: bgColor,
    surfaceTintColor: bgColor,
    automaticallyImplyLeading: false,
    centerTitle: centerTitle,
    leading: Visibility(
      visible: back,
      child: BackIcon(onBackPress: onBackPress, color: iconColor),
    ),
    actions: actions,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MyText(
          text: title,
          family: AppFonts.semibold,
          size: AppConstants.titleLarge,
        ),
        if (titleIcon != null) titleIcon,
      ],
    ),
  );
}

class BackIcon extends StatelessWidget {
  final Function()? onBackPress;
  final IconData? icon;
  final Color color;
  final bool isMargin;
  final Color bgColor;
  const BackIcon({
    super.key,
    this.icon,
    this.onBackPress,
    this.isMargin = true,
    this.bgColor = Colors.transparent,
    this.color = AppColors.blackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 40, maxHeight: 40),
      margin: isMargin ? const EdgeInsets.all(8.0) : null,
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.1)),
        shape: BoxShape.circle,
        color: bgColor,
      ),
      child: MaterialButton(
        onPressed: onBackPress ?? () => Navigator.of(context).pop(),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.zero,
        child: Icon(
          icon ?? Icons.arrow_back_rounded,
          color: color,
        ),
      ),
    );
  }
}
