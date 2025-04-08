import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback? onPress;
  final Color? bgColor;
  final String ficon;
  final Color color;
  const ActionButton({
    required this.color,
    required this.ficon,
    this.bgColor,
    this.onPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                ficon,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                height: 20,
                width: 20,
              ),
              Positioned(
                top: -0.4,
                left: 0.4,
                child: SvgPicture.asset(
                  ficon,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  height: 20,
                  width: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
