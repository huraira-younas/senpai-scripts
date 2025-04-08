import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/constants/app_contants.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:glmpse/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuildShimmerText extends StatelessWidget {
  final TextOverflow? overflow;
  final Color? shimerBColor;
  final Color? shimerHColor;
  final int? maxLines;
  final String family;
  final bool isCenter;
  final bool loading;
  final Color color;
  final double size;
  final String text;
  final int lines;
  const BuildShimmerText({
    this.family = AppFonts.regular,
    this.size = AppConstants.text,
    this.color = Colors.black,
    required this.loading,
    this.isCenter = false,
    required this.text,
    this.shimerBColor,
    this.shimerHColor,
    this.lines = 1,
    this.overflow,
    this.maxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: AppConstants.animDur),
      child: !loading
          ? MyText(
              maxLines: maxLines,
              isCenter: isCenter,
              overflow: overflow,
              family: family,
              color: color,
              size: size,
              text: text,
            )
          : Shimmer.fromColors(
              highlightColor: shimerHColor ?? AppColors.shimmerHighlightColor,
              baseColor: shimerBColor ?? AppColors.shimmerBaseColor,
              child: Column(
                crossAxisAlignment: isCenter
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: List.generate(
                  lines,
                  (idx) => Container(
                    width: lines - 1 == idx ? 200 : double.infinity,
                    height: size + 2,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
