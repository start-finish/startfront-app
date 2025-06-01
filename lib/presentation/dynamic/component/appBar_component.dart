import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:startfront_app/infrastructure/theme/app_theme.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../data/data.dart';
import '../data/helper.dart';

appBarComponent({required DynamicWidgetData data}) {
  final property = data.properties;
  final isImageNetwork = property['isImageNetwork'] ?? true;
  final isImageAsset = property['isImageAsset'] ?? true;
  final isHome = property['isHome'] ?? true;
  final isBack = property['isBack'] ?? true;
  final gradientKey = property['gradient'] as String?;
  final gradient = gradientFromKey(gradientKey);

  //// property {
  // backIconSize : double
  // icon : String or IconData
  // isImageNetwork : boolean
  // title : String
  // children : list (for action)
  // isHome : boolean (click button home)
  //// }

  return Container(
    height: property['height'],
    decoration: BoxDecoration(
      color:
          gradient == null ? (property['color'] ?? Colors.transparent) : null,
      gradient: gradient,
    ),
    child: Center(
      child: Container(
        width: property['width'],
        constraints: BoxConstraints(
          maxWidth: property['maxWidth'],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (isBack)
                      backButton(size: property['backIconSize'] ?? 36.0),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: property['icon'] != null ? 42 : double.infinity,
                      child: property['icon'] == null
                          ? property['leading']
                          : isImageNetwork == true
                              ? CachedNetworkImage(
                                  imageUrl: property['icon'],
                                  imageRenderMethodForWeb:
                                      ImageRenderMethodForWeb.HttpGet,
                                  placeholder: (context, url) {
                                    return SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: loadingIndicator(),
                                    );
                                  },
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : isImageAsset == true
                                  ? Image.asset(
                                      property['icon'],
                                      height: 32,
                                      width: 32,
                                    )
                                  : Image.asset(
                                      property['icon'],
                                      fit: BoxFit.fitHeight,
                                    ),
                    ),
                    if (property['title'] != null) const SizedBox(width: 12),
                    if (property['title'] != null)
                      Expanded(
                        child: textTitle(
                          title: property['title'],
                          size: 22,
                          color: property['titleColor'] ?? AppTheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (property['action'] != null && property['action'] is List)
                    Row(
                      children: (property['action'] as List<dynamic>)
                          .map<Widget>(
                              (actionData) => createActionButton(actionData))
                          .toList(),
                    ),
                  isHome == true
                      ? iconButtonWidget(
                          icon: Icons.home,
                          iconColor: AppTheme.primary,
                          iconSize: 24,
                          action: () {
                            Get.offAllNamed('/main');
                          },
                        )
                      : Container(),
                  const SizedBox(width: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

loadingIndicator({
  double width = 120,
}) {
  return Center(
    child: SizedBox(
      width: width,
      child: LoadingIndicator(
        indicatorType: Indicator.ballClipRotateMultiple,
        strokeWidth: 3,
        colors: [AppTheme.primary],
      ),
    ),
  );
}

backButton({required double size}) {
  return TouchRippleEffect(
    onTap: () => Get.back(result: 'refresh'),
    rippleColor: Colors.white24,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          Icons.chevron_left_rounded,
          color: AppTheme.primary,
          size: size,
        ),
      ),
    ),
  );
}

textTitle({
  String title = 'Title',
  double? size = 16,
  Color? color,
  TextOverflow? overflow,
  int? line,
}) {
  return Text(
    title,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w500,
      overflow: overflow ?? TextOverflow.ellipsis,
    ),
    maxLines: line ?? 1,
  );
}

iconButtonWidget({
  required IconData icon,
  required Color iconColor,
  Color? color,
  Function()? action,
  double width = 40,
  double height = 40,
  double iconSize = 24,
  double topPad = 0,
  double bottomPad = 0,
  double leftPad = 0,
  double rightPad = 0,
  double radius = 30,
}) {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(
      leftPad,
      topPad,
      rightPad,
      bottomPad,
    ),
    child: TouchRippleEffect(
      onTap: () {
        action?.call();
      },
      backgroundColor: color,
      rippleColor: Colors.white24,
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    ),
  );
}

Widget createActionButton(dynamic actionData) {
  if (actionData['icon'] == Icons.refresh_sharp && Get.context!.width < 600) {
    return Container();
  }

  return iconButtonWidget(
    icon: actionData['icon'] ?? Icons.help,
    iconColor: actionData['color'] ?? AppTheme.primary,
    iconSize: actionData['iconSize'] ?? 24,
    action: actionData['action'],
  );
}
