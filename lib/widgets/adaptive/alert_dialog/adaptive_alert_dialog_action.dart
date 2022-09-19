import 'package:remotesurveyadmin/config/styles/colors/app_colors.dart';
import 'package:remotesurveyadmin/helper/adaptive_widget_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveAlertDialogAction extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  const AdaptiveAlertDialogAction.adaptive({
    required this.title,
    this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final AdaptiveWidgetType _adaptiveWidgetType = AdaptiveWidgetUtil.getWidgetTypeOf(
      context,
      platform: Platform.adaptive,
    );
    switch (_adaptiveWidgetType) {
      case AdaptiveWidgetType.cupertino:
        return _buildCupertinoDialogAction();
      case AdaptiveWidgetType.material:
      default:
        return _buildMaterialDialogAction();
    }
  }

  Widget _buildMaterialDialogAction() {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: textStyle ?? _defaultActionTextStyle(),
      ),
    );
  }

  Widget _buildCupertinoDialogAction() {
    return CupertinoDialogAction(
      onPressed: onPressed,
      child: Text(
        title,
        style: textStyle ?? _defaultActionTextStyle(),
      ),
    );
  }

  TextStyle _defaultActionTextStyle() {
    return const TextStyle(
      color: Colors.blueAccent,
    );
  }
}
