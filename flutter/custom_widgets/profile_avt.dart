import 'package:glmpse/common_widget/profile_status_icon.dart';
import 'package:glmpse/common_widget/cache_image.dart';
import 'package:glmpse/common_widget/custom_hero.dart';
import 'package:glmpse/constants/app_assets.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class ProfileAvt extends StatelessWidget {
  final Color borderColor;
  final bool showBorder;
  final bool verified;
  final double size;
  final String url;
  const ProfileAvt({
    this.borderColor = Colors.white,
    this.showBorder = false,
    required this.verified,
    required this.size,
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double verifiedSize = size / 4;
    if (verifiedSize < 16) verifiedSize = 16;
    if (verifiedSize > 30) verifiedSize = 30;

    double bg = verifiedSize / 1.5;
    if (bg > 21) bg = 21;

    final icon = Center(
      child: Icon(
        color: AppColors.greyColor.withOpacity(0.3),
        Icons.person_rounded,
        size: size / 1.5,
      ),
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        if (showBorder)
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: borderColor,
            ),
          ),
        Container(
          clipBehavior: Clip.antiAlias,
          height: showBorder ? size - 4 : size,
          width: showBorder ? size - 4 : size,
          decoration: const BoxDecoration(
            color: Color(0xFFF4F5F9),
            shape: BoxShape.circle,
          ),
          child: CacheImage(
            placeHolder: icon,
            errorWidget: icon,
            fit: BoxFit.cover,
            url: url,
          ),
        ),
        if (verified)
          Positioned(
            bottom: verifiedSize == 30 ? 8 : 0,
            right: (verifiedSize == 30 ? size : verifiedSize) * 0.1,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  height: bg,
                  width: bg,
                ),
                SvgPicture.asset(
                  AppAssets.verifySVG,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                  height: verifiedSize,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ProfileWithActiveStatus extends StatelessWidget {
  final Color? activeIconColor;
  final bool isIncognito;
  final bool isActive;
  final double size;
  final String tag;
  final String url;

  const ProfileWithActiveStatus({
    this.isIncognito = false,
    required this.isActive,
    this.activeIconColor,
    required this.url,
    required this.tag,
    this.size = 50,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        CustomHero(
          tag: tag,
          child: ProfileAvt(
            verified: false,
            size: size,
            url: url,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 2,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isActive ? 1 : 0,
            child: ProfileStatusIcon(
              activeBgColor: isIncognito ? AppColors.lightGreyColor : null,
              activeColor: activeIconColor,
            ),
          ),
        ),
      ],
    );
  }
}
