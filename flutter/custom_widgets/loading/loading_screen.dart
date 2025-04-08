import 'dart:ui';

import 'package:glmpse/common_widget/loading/loading_screen_controller.dart';
import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/constants/app_contants.dart';
import 'package:glmpse/constants/app_fonts.dart';
import 'dart:async' show StreamController;
import 'package:flutter/material.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    required String title,
    double bottomPad = 0,
    required String text,
  }) {
    if ((_controller?.update(text, title) ?? false)) {
      return;
    }
    _controller = _showOverlay(
      bottomPad: bottomPad,
      context: context,
      title: title,
      text: text,
    );
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required double bottomPad,
    required String text,
    required String title,
  }) {
    final textStream = StreamController<String>();
    textStream.add(text);
    final titleStream = StreamController<String>();
    titleStream.add(title);

    final state = Overlay.of(context);
    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withOpacity(0.5),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: AppConstants.padding + bottomPad,
                horizontal: AppConstants.padding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _textbuilder(stream: titleStream, isBold: true),
                  const SizedBox(height: 6),
                  _textbuilder(
                    size: AppConstants.subtitle,
                    stream: textStream,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);
    return LoadingScreenController(
      close: () {
        textStream.close();
        titleStream.close();
        overlay.remove();
        return true;
      },
      update: (text, title) {
        textStream.add(text);
        titleStream.add(title);
        return true;
      },
    );
  }

  StreamBuilder<String> _textbuilder({
    required StreamController<String> stream,
    bool isBold = false,
    double size = AppConstants.titleLarge,
  }) {
    return StreamBuilder(
      stream: stream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Flexible(
            child: MyText(
              color: Colors.white,
              text: snapshot.data!,
              size: size,
              family: isBold ? AppFonts.bold : AppFonts.medium,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
