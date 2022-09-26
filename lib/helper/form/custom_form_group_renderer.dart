import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
as model;
import 'package:dynamic_forms/dynamic_forms.dart';

class CustomFormGroupRenderer extends FormElementRenderer<model.FormGroup> {
  @override
  Widget render(
      model.FormGroup element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return LazyStreamBuilder(
      streamFactory: () => MergeStream([
        element.childrenChanged,
        ...element.children
            .whereType<FormElement>()
            .map((child) => child.isVisibleChanged),
        element.nameChanged,
      ]),
      builder: (context, _) {
        List<Widget> childrenWidgets = [];
        childrenWidgets.addAll(
          element.children
              .whereType<FormElement>()
              .where((f) => f.isVisible)
              .map(
                (child) => SizedBox(width: 350, child: renderer(child, context)),
          ),
        );
        return Container(
            alignment: Alignment.topLeft,
            width: SizeConfig.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                color: kPrimaryColor,
                child: Text(
                  element.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Wrap(runSpacing: 5.0, spacing: 5.0,
                children: childrenWidgets
              )
            ]));
      },
    );
  }
}
