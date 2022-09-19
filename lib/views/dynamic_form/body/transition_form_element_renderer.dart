import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:remotesurveyadmin/data/blocs/form/dynamic_form_bloc.dart';
import 'package:remotesurveyadmin/views/dynamic_form/body/transition_form_element.dart';

class TransitionFormElementRenderer
    extends FormElementRenderer<TransitionFormElement> {
  @override
  Widget render(
      TransitionFormElement element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    var child = renderer(element.child, context);
    switch (element.transitionType) {
      case FormElementTransitionType.show:
        return ExpandableSection(
          expand: true,
          child: child,
        );
      case FormElementTransitionType.hide:
        return ExpandableSection(
          expand: false,
          child: child,
        );
      default:
        throw Exception('Unknown transition type');
    }
  }
}

class ExpandableSection extends StatefulWidget {
  final Widget? child;
  final bool expand;

  ExpandableSection({this.expand = false, this.child});

  @override
  _ExpandableSectionState createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: DynamicFormBloc.transitionDuration);
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.linear,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve as Animation<double>)
      ..addListener(() {
        setState(() {});
      });
    if (widget.expand) {
      expandController.value = 0;
      expandController.forward();
    } else {
      expandController.value = 1.0;
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Container(
            color: widget.expand ? Colors.green[50] : Colors.red[50],
            child: widget.child),
      ),
    );
  }
}
