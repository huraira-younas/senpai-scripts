import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:glmpse/constants/app_contants.dart';
import 'package:flutter/material.dart';
import 'package:glmpse/constants/app_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final String? label;
  final bool obsecure;
  final bool showTitle;
  final int maxLines;
  final bool enabled;
  final String? value;
  final Function(String?)? onChange;
  final Function()? onSubmit;
  final InputBorder? border;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType type;

  const CustomTextField({
    super.key,
    required this.hint,
    this.label,
    this.focusNode,
    this.obsecure = false,
    this.showTitle = false,
    this.value,
    this.enabled = true,
    this.onChange,
    this.onSubmit,
    this.controller,
    this.maxLines = 1,
    this.border,
    this.prefixIcon,
    this.validator,
    this.suffixIcon,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          MyText(
            color: AppColors.blackColor,
            size: AppConstants.subtitle,
            family: AppFonts.medium,
            text: label ?? hint,
          ),
        const SizedBox(height: 6),
        MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor(context)),
          ),
          child: TextFormField(
            focusNode: focusNode,
            onFieldSubmitted: (value) => onSubmit?.call(),
            style: myStyle(size: AppConstants.subtitle),
            onSaved: (newValue) => onSubmit?.call(),
            onTapOutside: (v) => onSubmit?.call(),
            controller: controller,
            obscureText: obsecure,
            validator: validator,
            initialValue: value,
            onChanged: onChange,
            maxLines: maxLines,
            keyboardType: type,
            enabled: enabled,
            decoration: customInputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: border,
              hint: hint,
              // label: label,
            ),
          ),
        ),
      ],
    );
  }
}

InputDecoration customInputDecoration({
  InputBorder? border,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? label,
  String? hint,
}) {
  // final borderStyle = OutlineInputBorder(
  //   borderSide: const BorderSide(color: Colors.transparent),
  //   borderRadius: BorderRadius.circular(10),
  // );

  const borderStyle = UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.lightGreyColor),
  );

  return InputDecoration(
    hintStyle: const TextStyle(color: AppColors.greyColor),
    disabledBorder: border ?? borderStyle,
    contentPadding: const EdgeInsets.only(
      right: 16.0,
      bottom: 12,
      // left: 16.0,
      top: 14.2,
    ),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    isCollapsed: true,
    errorMaxLines: 3,
    labelText: label,
    hintText: hint,
    isDense: true,
    // filled: true,
    // fillColor: const Color(0xFFF4F5F9),
    enabledBorder: border ?? borderStyle,
    errorBorder: border ?? borderStyle,
    border: border ?? borderStyle,
  );
}
