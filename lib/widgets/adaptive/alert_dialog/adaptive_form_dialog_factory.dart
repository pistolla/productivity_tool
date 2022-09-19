import 'package:remotesurveyadmin/data/error/app_error.dart';
import 'package:remotesurveyadmin/helper/adaptive_widget_util.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_alert_dialog.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_alert_dialog_action.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_form_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AdaptiveFormDialogFactory {
  const AdaptiveFormDialogFactory._();

  static void _showDialog(
    BuildContext context, {
    required String title,
    required List<AdaptiveAlertDialogAction> actions,
    Widget? content,
    bool rootNavigator = false,
  }) {
    final AdaptiveWidgetType _adaptiveWidgetType = AdaptiveWidgetUtil.getWidgetTypeOf(
      context,
      platform: Platform.adaptive,
    );
    switch (_adaptiveWidgetType) {
      case AdaptiveWidgetType.cupertino:
        return _showCupertinoDialog(
          context,
          title: title,
          child: content,
          rootNavigator: rootNavigator,
          actions: actions,
        );
      case AdaptiveWidgetType.material:
      default:
        return _showMaterialDialog(
          context,
          title: title,
          child: content,
          rootNavigator: rootNavigator,
          actions: actions,
        );
    }
  }

  static void _showCupertinoDialog(
    BuildContext context, {
    required String title,
    required List<AdaptiveAlertDialogAction> actions,
    Widget? child,
    bool rootNavigator = false,
  }) {
    showCupertinoDialog(
      context: context,
      useRootNavigator: rootNavigator,
      builder: (BuildContext context) => AdaptiveFormDialog(
        title: title,
        content: child,
        actions: actions,
      ),
    );
  }

  static void _showMaterialDialog(
    BuildContext context, {
    required String title,
    required List<AdaptiveAlertDialogAction> actions,
    Widget? child,
    bool rootNavigator = false,
  }) {
    showDialog(
      context: context,
      useRootNavigator: rootNavigator,
      builder: (BuildContext context) => AdaptiveFormDialog(
        title: title,
        content: child!,
        actions: actions,
      ),
    );
  }

// Generic dialogs
  static void showOKAlert(
    BuildContext context, {
    required String title,
    Widget? child,
    bool rootNavigator = false,
    VoidCallback? onPressed,
  }) {
    _showDialog(
      context,
      title: title,
      content: child!,
      rootNavigator: rootNavigator,
      actions: <AdaptiveAlertDialogAction>[
        AdaptiveAlertDialogAction.adaptive(
          title: "CANCEL",
          onPressed: () => Navigator.of(
                context,
                rootNavigator: rootNavigator,
              ).pop(),
        ),
        AdaptiveAlertDialogAction.adaptive(
          title: "OK",
          onPressed: onPressed ??
              () => Navigator.of(
                    context,
                    rootNavigator: rootNavigator,
                  ).pop(),
        ),
      ],
    );
  }

  static void showContentUnavailable(
    BuildContext context, {
    bool rootNavigator = false,
    VoidCallback? onPressed,
  }) {
    showOKAlert(
      context,
      title: "Title",
      child: Text("Content"),
      rootNavigator: rootNavigator,
      onPressed: onPressed,
    );
  }

  static void showError(
    BuildContext context, {
    required AppError appError,
    bool rootNavigator = false,
    VoidCallback? onPressed,
  }) {
    showOKAlert(
      context,
      title: appError.localizedTitle(context),
      child: appError.localizedMessage(context),
      rootNavigator: rootNavigator,
      onPressed: onPressed,
    );
  }
}
