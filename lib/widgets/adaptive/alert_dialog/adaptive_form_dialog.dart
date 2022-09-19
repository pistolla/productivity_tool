import 'package:remotesurveyadmin/helper/adaptive_widget_util.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_alert_dialog_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFormDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final List<AdaptiveAlertDialogAction> actions;

  const AdaptiveFormDialog({
    required this.title,
    required this.actions,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final AdaptiveWidgetType _adaptiveWidgetType = AdaptiveWidgetUtil
        .getWidgetTypeOf(
      context,
      platform: Platform.adaptive,
    );
    switch (_adaptiveWidgetType) {
      case AdaptiveWidgetType.cupertino:
        return _buildCupertinoFormDialog(
          context,
        );
      case AdaptiveWidgetType.material:
      default:
        return _buildMaterialFormDialog(
          context,
        );
    }
  }

  Widget _buildCupertinoFormDialog(BuildContext context,) {
    return CupertinoAlertDialog(
      title: Text(
        title,
      ),
      content: Padding(
        padding: const EdgeInsets.only(
          top: 2,
        ),
        child: content!,
      ),
      actions: actions,
    );
  }

  Widget _buildMaterialFormDialog(BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
        ),
        content: content!,
        actions: actions,
      );
  }
}
