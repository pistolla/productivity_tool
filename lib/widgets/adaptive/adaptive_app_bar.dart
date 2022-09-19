import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/widgets/adaptive/adaptive_button.dart';

class AdaptiveAppBar extends AppBar {
  AdaptiveAppBar(
    BuildContext context, {
    List<Widget>? actions,
    Color? backgroundColor,
    bool? centerTitle,
    IconThemeData? iconTheme,
    Widget? title,
  }) : super(
          actions: actions,
          backgroundColor: backgroundColor,
          centerTitle: centerTitle,
          elevation: 0.0,
          iconTheme: iconTheme,
          leading: _buildLeadingNavigationButton(
            context,
            iconTheme: iconTheme,
          ),
          title: title,
        );

  static Widget? _buildLeadingNavigationButton(
    BuildContext context, {
    IconThemeData? iconTheme,
  }) {
    final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    if (parentRoute?.canPop ?? true) {
      return _NavigationButton(
        icon: useCloseButton
            ? Icons.close
            : Platform.isIOS
                ? Icons.arrow_back_ios
                : Icons.arrow_back,
        iconTheme: iconTheme,
      );
    } else {
      return null;
    }
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final IconThemeData? iconTheme;

  const _NavigationButton({
    required this.icon,
    required this.iconTheme,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveButton(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      onPressed: () => Navigator.maybePop(context),
      child: Icon(
        icon,
        color: iconTheme?.color ?? Theme.of(context).appBarTheme.iconTheme?.color,
      ),
    );
  }
}
