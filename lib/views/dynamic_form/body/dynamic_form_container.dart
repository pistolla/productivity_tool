import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:remotesurveyadmin/data/blocs/form/dynamic_form_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/form/dynamic_form_event.dart';
import 'package:remotesurveyadmin/data/blocs/form/dynamic_form_state.dart';
import 'package:remotesurveyadmin/helper/form/custom_renderers.dart';

import 'custom_form_manager.dart';

class DynamicFormContainer extends StatefulWidget {
  final String documentId;
  final int formNumber;

  const DynamicFormContainer(
      {super.key, required this.documentId, required this.formNumber});

  @override
  _DynamicFormContainerState createState() => _DynamicFormContainerState();
}

class _DynamicFormContainerState extends State<DynamicFormContainer> {
  late FormRenderService _formRenderService;

  @override
  void initState() {
    super.initState();
    _formRenderService = FormRenderService(
      renderers: getFormRenderers(),
      dispatcher: BlocProvider.of<DynamicFormBloc>(context).add,
    );
    BlocProvider.of<DynamicFormBloc>(context).add(LoadFormEvent(
        documentId: widget.documentId, formNumber: widget.formNumber));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DynamicFormBloc, DynamicFormState>(
      builder: (context, state) {
        if (state.form == null) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return SingleChildScrollView(
              child: _formRenderService.render(state.form!, context)
        );
      },
    );
  }
}
