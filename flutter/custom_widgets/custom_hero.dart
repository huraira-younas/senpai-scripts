import 'package:glmpse/services/hero_tag_service.dart';
import 'package:flutter/material.dart';

class CustomHero extends StatelessWidget {
  final String tag;
  final Widget child;

  const CustomHero({
    super.key,
    required this.tag,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueTag = TagManager().getUniqueTag(tag);

    return Hero(
      tag: uniqueTag,
      child: child,
    );
  }
}
