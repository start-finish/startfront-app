import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../infrastructure/theme/app_theme.dart';
import '../data/data.dart';
import '../data/factory.dart';

class AnimatedAlertDialog extends StatefulWidget {
  final DynamicWidgetData data;

  // Pass DynamicWidgetData to the widget to customize it
  AnimatedAlertDialog({required this.data});

  @override
  _AnimatedAlertDialogState createState() => _AnimatedAlertDialogState();
}

class _AnimatedAlertDialogState extends State<AnimatedAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Create an AnimationController for the scale animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Define the scale animation (from 0.8 to 1.0)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut),
    );

    // Start the animation when the widget is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.data.properties;

    // Determine body: message or content
    Widget? contentWidget;
    if (props['content'] != null && props['content'] is DynamicWidgetData) {
      contentWidget = DynamicWidgetFactory.createWidget(props['content']);
    }

    final messageWidget = props['message'] != null
        ? Text(props['message'])
        : null;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value, // Apply the scale value for zoom effect
          child: AlertDialog(
            title: props['title'] != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        props['title'],
                        style: TextStyle(
                          color: props['titleColor'] ?? AppTheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final func = props['onCancel'];
                          if (func is Function) func();
                          // Start the closing animation when the close button is clicked
                          _controller.reverse().then((value) {
                            Get.back();
                          });
                        },
                        child: Icon(IconsaxPlusBroken.close_square),
                      ),
                    ],
                  )
                : null,
            content: contentWidget ?? messageWidget,
            backgroundColor: AppTheme.onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Smaller radius
            ),

            actions: [
              InkWell(
                onTap: () {
                  final func = props['onCancel'];
                  if (func is Function) func();
                  // Start the closing animation when the close button is clicked
                  _controller.reverse().then((value) {
                    Get.back();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primary, width: 0.5),
                  ),
                  child: Text(
                    props['cancelText'] ?? 'Cancel',
                    style: TextStyle(color: AppTheme.primary),
                  ),
                ),
              ),
              if (props['confirmText'] != null)
                InkWell(
                  onTap: () {
                    final func = props['onConfirm'];
                    if (func is Function) func();
                    // Start the closing animation when the confirm button is clicked
                    _controller.reverse().then((value) {
                      Get.back();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.primary,
                    ),
                    child: Text(
                      props['confirmText'],
                      style: TextStyle(color: AppTheme.onPrimary),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

showAlertComponent({required DynamicWidgetData data}) {
  Get.dialog(
    AnimatedAlertDialog(data: data),
    barrierColor: AppTheme.onBackground.withOpacity(0.5),
    barrierDismissible: data.properties['dismiss'] ?? false,
  );
}
