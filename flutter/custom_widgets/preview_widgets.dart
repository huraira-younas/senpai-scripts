import 'package:glmpse/extensions/app_localization.dart';
import 'package:glmpse/common_widget/cache_image.dart';
import 'package:glmpse/common_widget/text_widget.dart';
import 'package:glmpse/models/attachment_model.dart';
import 'package:glmpse/constants/app_contants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:glmpse/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class DottedPreview extends StatelessWidget {
  final double progress;
  final Attachment? file;
  final VoidCallback? onPressed;
  final VoidCallback? onDelete;
  const DottedPreview({
    super.key,
    this.file,
    this.onPressed,
    this.onDelete,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final change = file?.thumbnail.contains("http") ?? false;

    return DottedBorder(
      color: AppColors.primaryColor,
      radius: const Radius.circular(10),
      borderType: BorderType.RRect,
      strokeWidth: 1.5,
      dashPattern: const [8, 8],
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          GestureDetector(
            onTap: !change ? onPressed : null,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: AppConstants.animDur),
                child: file == null
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Center(
                        child: _buildImage(
                        file: file?.thumbnail ?? "",
                        progress: progress,
                      )),
              ),
            ),
          ),
          if (file != null && onDelete != null)
            Positioned(
              right: -5,
              top: -10,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: const Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomPreview extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onDelete;
  final Attachment? file;
  final double progress;
  final bool isChange;
  const CustomPreview({
    super.key,
    this.file,
    this.onPressed,
    this.onDelete,
    this.progress = 1.0,
    this.isChange = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: file != null
                ? Center(
                    child: _buildImage(
                      file: file?.thumbnail ?? "",
                      progress: progress,
                    ),
                  )
                : null,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              margin: const EdgeInsets.only(
                bottom: 4,
                right: 4,
                left: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: MyText(
                      text: isChange ? context.change : context.upload,
                      overflow: TextOverflow.ellipsis,
                      family: AppFonts.semibold,
                      color: Colors.black,
                      size: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (file != null && onDelete != null)
            Positioned(
              right: -5,
              top: -10,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: const Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _buildImage({required String file, double progress = 1.0}) {
  return progress == 100.0 || file.isNotEmpty
      ? CacheImage(fit: BoxFit.cover, url: file, loaderheight: 60)
      : CircularProgressIndicator(
          value: progress / 100,
          backgroundColor: AppColors.greyColor.withOpacity(0.1),
        );
}
