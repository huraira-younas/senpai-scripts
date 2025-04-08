import 'package:glmpse/common_widget/gradient_button.dart';
import 'package:glmpse/extensions/app_localization.dart';
import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/constants/app_contants.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:glmpse/constants/app_fonts.dart';
import 'package:flutter/material.dart';

Future<void> errorDialogue({
  Map<String, String>? action,
  required BuildContext context,
  required String message,
  required String title,
}) {
  action ??= {"ok": context.ok};
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        surfaceTintColor: AppColors.secondaryColor,
        title: Center(
          child: MyText(
            size: AppConstants.title,
            family: AppFonts.bold,
            text: title,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.padding,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        titlePadding: const EdgeInsets.only(
          top: AppConstants.padding + 5,
          right: AppConstants.padding,
          left: AppConstants.padding,
          bottom: 10,
        ),
        backgroundColor: AppColors.secondaryColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.padding + 20,
          vertical: AppConstants.padding,
        ),
        content: MyText(
          size: AppConstants.subtitle,
          isCenter: true,
          text: message,
        ),
        actions: <Widget>[
          CustomButton(
            text: action!['ok']!,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      );
    },
  );
}

Future<bool> confirmDialogue({
  required BuildContext context,
  required String title,
  required String message,
  Color confirmColor = AppColors.primaryColor,
  Map<String, String>? actions,
}) {
  actions ??= {
    "cancel": context.cancelText,
    "confirm": context.confirm,
  };

  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: AppColors.secondaryColor,
          title: Center(
            child: MyText(
              size: AppConstants.title,
              family: AppFonts.bold,
              text: title,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.padding,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          titlePadding: const EdgeInsets.only(
            top: AppConstants.padding + 5,
            right: AppConstants.padding,
            left: AppConstants.padding,
            bottom: 10,
          ),
          backgroundColor: AppColors.secondaryColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.padding,
            vertical: AppConstants.padding,
          ),
          content: MyText(
            size: AppConstants.subtitle,
            isCenter: true,
            text: message,
          ),
          actions: <Widget>[
            Column(
              children: <Widget>[
                CustomButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  text: actions!['confirm']!,
                  bgColor: confirmColor,
                  radius: 20,
                ),
                const SizedBox(height: 8),
                CustomButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  bgColor: Colors.white,
                  textColor: confirmColor,
                  text: actions['cancel']!,
                  radius: 20,
                ),
              ],
            ),
          ],
        );
      }).then(
    (value) => value ?? false,
  );
}

Future<bool> logoutSheet({
  required BuildContext context,
  required String message,
  required String title,
  String? confirmText,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppConstants.padding + 10,
            left: AppConstants.padding + 10,
            right: AppConstants.padding + 10,
            bottom: 5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: MyText(
                  text: title,
                  family: AppFonts.bold,
                  size: AppConstants.title,
                ),
              ),
              const SizedBox(height: 10),
              MyText(
                color: AppColors.greyColor,
                size: AppConstants.subtitle,
                isCenter: true,
                text: message,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: confirmText ?? "${context.yes}, ${context.logoutTitle}",
                onPressed: () => Navigator.of(context).pop(true),
                textColor: AppColors.primaryColor,
                bgColor: Colors.transparent,
              ),
              Divider(
                color: AppColors.greyColor.withOpacity(0.1),
                height: 10,
              ),
              CustomButton(
                onPressed: () => Navigator.of(context).pop(false),
                textColor: Colors.black,
                text: context.cancelText,
                bgColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<int> getPlatform({
  List<Map<String, dynamic>>? buttons,
  required BuildContext context,
  bool isAsset = false,
  String? title,
  String? desc,
}) async {
  title ??= context.selectPlatform;
  buttons ??= [
    {
      "color": AppColors.primaryColor,
      "icon": Icons.photo_camera,
      "title": context.camera,
    },
    {
      "color": AppColors.primaryColor,
      "icon": Icons.photo_library,
      "title": context.gallery,
    },
  ];
  int idx = -1;
  await showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return SafeArea(
        top: false,
        child: ShowModelTitle(
          title: title!,
          desc: desc ?? context.selectMediaToUpload,
          children: List.generate(buttons!.length, (index) {
            if (isAsset) {
              return _buttonAsset(
                buttons![index]["title"],
                buttons[index]["icon"],
                buttons[index]["color"],
                () {
                  idx = index + 1;
                  Navigator.of(ctx).pop();
                },
                buttons.length > 2,
              );
            }
            return _button(
              buttons![index]["title"],
              buttons[index]["icon"],
              buttons[index]["color"],
              () {
                idx = index + 1;
                Navigator.of(ctx).pop();
              },
              buttons.length > 2,
            );
          }),
        ),
      );
    },
  );
  return idx;
}

Widget _buttonAsset(
  String title,
  String icon,
  Color color,
  VoidCallback onTap,
  bool isG,
) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    onTap: onTap,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          color: AppColors.blackColor,
          height: 20,
          icon,
        ),
        const SizedBox(width: 10),
        MyText(
          color: AppColors.blackColor,
          family: AppFonts.semibold,
          text: title,
          size: 15,
        ),
      ],
    ),
  );
}

Widget _button(
  String title,
  IconData icon,
  Color color,
  VoidCallback onTap,
  bool isG,
) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    onTap: onTap,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: AppColors.blackColor,
        ),
        const SizedBox(width: 10),
        MyText(
          color: AppColors.blackColor,
          family: AppFonts.semibold,
          text: title,
          size: 15,
        ),
      ],
    ),
  );
}

class ShowModelTitle extends StatelessWidget {
  final List<Widget> children;
  final bool shouldPadHorizontal;
  final String title;
  final String desc;
  const ShowModelTitle({
    this.shouldPadHorizontal = true,
    required this.children,
    required this.title,
    required this.desc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: shouldPadHorizontal ? AppConstants.padding + 10 : 0,
        left: shouldPadHorizontal ? AppConstants.padding + 10 : 0,
        top: AppConstants.padding + 10,
        bottom: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: !shouldPadHorizontal ? AppConstants.padding + 10 : 0,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MyText(
                    size: AppConstants.title,
                    family: AppFonts.bold,
                    text: title,
                  ),
                  const SizedBox(height: 8),
                  MyText(
                    isCenter: true,
                    text: desc,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Divider(
            color: AppColors.greyColor.withOpacity(0.1),
            height: 0,
          ),
          for (int i = 0; i < children.length; i++)
            Column(
              children: <Widget>[
                children[i],
                if (i != children.length - 1)
                  Divider(
                    color: AppColors.greyColor.withOpacity(0.1),
                    height: 0,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
