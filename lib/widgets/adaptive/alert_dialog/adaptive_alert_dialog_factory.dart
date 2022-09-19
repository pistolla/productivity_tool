import 'package:remotesurveyadmin/data/error/app_error.dart';
import 'package:remotesurveyadmin/helper/adaptive_widget_util.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_alert_dialog.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_alert_dialog_action.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_indeterminate_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AdaptiveAlertDialogFactory {
  const AdaptiveAlertDialogFactory._();

  static void _showDialog(
    BuildContext context, {
    required String title,
    required List<AdaptiveAlertDialogAction> actions,
    String? content,
    bool rootNavigator = false,
  }) {
    final AdaptiveWidgetType _adaptiveWidgetType =
        AdaptiveWidgetUtil.getWidgetTypeOf(
      context,
      platform: Platform.adaptive,
    );
    switch (_adaptiveWidgetType) {
      case AdaptiveWidgetType.cupertino:
        return _showCupertinoDialog(
          context,
          title: title,
          content: content,
          rootNavigator: rootNavigator,
          actions: actions,
        );
      case AdaptiveWidgetType.material:
      default:
        return _showMaterialDialog(
          context,
          title: title,
          content: content,
          rootNavigator: rootNavigator,
          actions: actions,
        );
    }
  }

  static void _showCupertinoDialog(
    BuildContext context, {
    required String title,
    required List<AdaptiveAlertDialogAction> actions,
    String? content,
    bool rootNavigator = false,
  }) {
    showCupertinoDialog(
      context: context,
      useRootNavigator: rootNavigator,
      builder: (BuildContext context) => AdaptiveAlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  static void _showMaterialDialog(
    BuildContext context, {
    required String title,
    required List<AdaptiveAlertDialogAction> actions,
    String? content,
    bool rootNavigator = false,
  }) {
    showDialog(
      context: context,
      useRootNavigator: rootNavigator,
      builder: (BuildContext context) => AdaptiveAlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

// Generic dialogs
  static void showOKAlert(
    BuildContext context, {
    required String title,
    String? content,
    bool rootNavigator = false,
    VoidCallback? onPressed,
  }) {
    _showDialog(
      context,
      title: title,
      content: content,
      rootNavigator: rootNavigator,
      actions: <AdaptiveAlertDialogAction>[
        AdaptiveAlertDialogAction.adaptive(
          title: "okay",
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
      content: "Content",
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
      content: appError.localizedMessage(context),
      rootNavigator: rootNavigator,
      onPressed: onPressed,
    );
  }

  static Widget showInditerminate(
      BuildContext context, {
        content = "Content",
        status = 1
      }) {
    return _showIndeterminateDialog(
      context: context, content: content, status: status
    );
  }

  static Widget _showIndeterminateDialog({required BuildContext context, content, status}) {
    final AdaptiveWidgetType _adaptiveWidgetType =
    AdaptiveWidgetUtil.getWidgetTypeOf(
      context,
      platform: Platform.adaptive,
    );
    switch (_adaptiveWidgetType) {
      case AdaptiveWidgetType.cupertino:
        return _showCupertinoActivityIndicator(
          context,
        );
      case AdaptiveWidgetType.material:
      default:
        return _showMaterialActivityIndicator(
          context,
          content: content,
          status: status
        );
    }
  }

  static CupertinoActivityIndicator _showCupertinoActivityIndicator(BuildContext context) {
    return CupertinoActivityIndicator(animating: true, radius: 40);
  }

  static IndeterminateDialog _showMaterialActivityIndicator(BuildContext context, {content, status}) {
    return IndeterminateDialog(context,status: status,content: content);
  }
}
