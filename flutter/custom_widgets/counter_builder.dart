import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CounterBuilder extends StatelessWidget {
  final Widget widget;
  final double topPos;
  final int count;
  const CounterBuilder({
    super.key,
    required this.widget,
    required this.count,
    this.topPos = -2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        widget,
        if (count > 0)
          Positioned(
            top: topPos,
            right: topPos - 2,
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: MyText(
                  text: count.toString(),
                  color: Colors.white,
                  isCenter: true,
                  size: 8,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
