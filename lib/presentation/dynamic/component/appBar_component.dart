import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:startfront_app/infrastructure/theme/app_theme.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../data/data.dart';
import '../data/factory.dart';
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

  return LayoutBuilder(builder: (context, constraints) {
    final isSmallScreen = constraints.maxWidth < 600;

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
            padding: (property['padding'] as num?)?.toDouble() != null
                ? EdgeInsets.all((property['padding'] as num?)?.toDouble() ?? 0)
                : (property['verticalPadding'] as num?)?.toDouble() != null ||
                        (property['horizontalPadding'] as num?)?.toDouble() !=
                            null
                    ? EdgeInsets.symmetric(
                        vertical:
                            (property['verticalPadding'] as num?)?.toDouble() ??
                                0.0,
                        horizontal: (property['horizontalPadding'] as num?)
                                ?.toDouble() ??
                            0.0,
                      )
                    : EdgeInsets.only(
                        top:
                            (property['topPadding'] as num?)?.toDouble() ?? 0.0,
                        bottom:
                            (property['bottomPadding'] as num?)?.toDouble() ??
                                0.0,
                        left: (property['leftPadding'] as num?)?.toDouble() ??
                            0.0,
                        right: (property['rightPadding'] as num?)?.toDouble() ??
                            0.0,
                      ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (isBack)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: backButton(
                                size: property['backIconSize'] ?? 24),
                          ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height:
                              property['icon'] != null ? 42 : double.infinity,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (property['title'] != null)
                              const SizedBox(width: 12),
                            if (property['title'] != null)
                              textTitle(
                                title: property['title'],
                                size: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    property['titleColor'] ?? AppTheme.primary,
                              ),
                            if (property['subTitle'] != null)
                              const SizedBox(width: 12),
                            if (property['subTitle'] != null)
                              textTitle(
                                title: property['subTitle'],
                                size: 14,
                                color: (property['subTitleColor'] ??
                                        AppTheme.primary)
                                    .withAlpha(200),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (property['action'] != null)
                        Row(
                          children: (property['action'] as List)
                              .map<Widget>(
                                  (e) => DynamicWidgetFactory.createWidget(e))
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
      ),
    );
  });
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
    rippleColor: Colors.black26,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          Icons.arrow_back_rounded,
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
  FontWeight? fontWeight,
  int? line,
}) {
  return Text(
    title,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.w500,
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
