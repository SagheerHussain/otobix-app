import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final RxBool isLoading;
  final VoidCallback onTap;
  final double height;
  final double width;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle? textStyle;
  final double loaderSize;
  final double loaderStrokeWidth;
  final Color loaderColor;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onTap,
    this.height = 40,
    this.width = 150,
    this.borderRadius = 50,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.textStyle,
    this.loaderSize = 15,
    this.loaderStrokeWidth = 1,
    this.loaderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading.value ? null : onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Obx(
        () => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child:
                isLoading.value
                    ? SizedBox(
                      height: loaderSize,
                      width: loaderSize,
                      child: CircularProgressIndicator(
                        color: loaderColor,
                        strokeWidth: loaderStrokeWidth,
                      ),
                    )
                    : Text(
                      text,
                      style:
                          textStyle ??
                          TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
          ),
        ),
      ),
    );
  }
}
