import 'package:glmpse/constants/app_colors.dart';
import 'package:info_popup/info_popup.dart';
import 'package:flutter/material.dart';

class InfoPopup extends StatelessWidget {
  final String content;
  final IconData icon;
  final Color color;
  const InfoPopup({
    super.key,
    required this.icon,
    required this.content,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return InfoPopupWidget(
      contentTitle: content,
      arrowTheme: const InfoPopupArrowTheme(
        color: AppColors.primaryColor,
        arrowDirection: ArrowDirection.up,
      ),
      contentTheme: const InfoPopupContentTheme(
        infoContainerBackgroundColor: AppColors.primaryColor,
        infoTextStyle: TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.all(8),
        contentBorderRadius: BorderRadius.all(Radius.circular(10)),
        infoTextAlign: TextAlign.center,
      ),
      dismissTriggerBehavior: PopupDismissTriggerBehavior.onTapArea,
      areaBackgroundColor: Colors.transparent,
      indicatorOffset: Offset.zero,
      contentOffset: Offset.zero,
      onAreaPressed: (InfoPopupController controller) {
        controller.dismissInfoPopup();
      },
      child: Icon(icon, color: color),
    );
  }
}
