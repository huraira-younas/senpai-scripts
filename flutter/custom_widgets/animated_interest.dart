import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:glmpse/blocs/lanuage_bloc/language_bloc.dart';
import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/common_widget/ui_loader.dart';
import 'package:glmpse/constants/app_contants.dart';
import 'package:glmpse/models/interest_model.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:glmpse/constants/app_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedInterest extends StatelessWidget {
  final Function(Interest interest)? onSelect;
  final List<Interest> interests;
  final double textSize;
  final double rowSpace;
  final double colSpace;
  final bool isShallow;
  final bool loading;
  const AnimatedInterest({
    this.textSize = AppConstants.text,
    required this.interests,
    required this.loading,
    this.isShallow = false,
    this.rowSpace = 10.0,
    this.colSpace = 10.0,
    this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return loading
        ? Shimmer.fromColors(
            baseColor: AppColors.shimmerBaseColor,
            highlightColor: AppColors.shimmerHighlightColor,
            child: InterestsBuilder(interests: Interest.dummy),
          )
        : InterestsBuilder(
            isShallow: isShallow,
            interests: interests,
            onSelect: onSelect,
            textSize: textSize,
            rowSpace: rowSpace,
            colSpace: colSpace,
          );
  }
}

class InterestsBuilder extends StatefulWidget {
  final Function(Interest interest)? onSelect;
  final List<Interest> interests;
  final double rowSpace;
  final double colSpace;
  final double textSize;
  final bool isShallow;
  const InterestsBuilder({
    super.key,
    this.onSelect,
    this.rowSpace = 6.0,
    this.colSpace = 5.0,
    this.isShallow = false,
    required this.interests,
    this.textSize = AppConstants.text,
  });

  @override
  State<InterestsBuilder> createState() => _InterestsBuilderState();
}

class _InterestsBuilderState extends State<InterestsBuilder> {
  late final _langBloc = context.read<LanguageBloc>();

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Wrap(
        spacing: widget.rowSpace,
        runSpacing: widget.colSpace,
        children: List.generate(widget.interests.length, (idx) {
          final chip = widget.interests[idx];
          final selected = chip.isSelected;
          return AnimationConfiguration.staggeredList(
            duration: const Duration(milliseconds: 500),
            key: Key(idx.toString()),
            position: idx,
            child: SlideAnimation(
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () => widget.onSelect?.call(widget.interests[idx]),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: widget.isShallow
                          ? AppColors.lightGreyColor.withOpacity(0.3)
                          : selected && widget.onSelect != null
                              ? AppColors.primaryColor
                              : const Color(0xFFF4F5F9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.network(
                          chip.iconUrl,
                          height: 16,
                          width: 16,
                          semanticsLabel: chip.title,
                          colorFilter: ColorFilter.mode(
                            widget.isShallow
                                ? Colors.white
                                : selected && widget.onSelect != null
                                    ? Colors.white
                                    : const Color(0xFF797979),
                            BlendMode.srcIn,
                          ),
                          placeholderBuilder: (_) => const UILoader(size: 14),
                        ),
                        const SizedBox(width: 6),
                        FutureBuilder(
                          future: _langBloc.translateLanguage(text: chip.title),
                          builder: (context, snapshot) {
                            final data = snapshot.data ?? chip.title;
                            return MyText(
                              family: AppFonts.semibold,
                              text: data,
                              color: widget.isShallow
                                  ? Colors.white
                                  : selected && widget.onSelect != null
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
