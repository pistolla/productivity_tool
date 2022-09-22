import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:remotesurveyadmin/data/blocs/form/dynamic_form_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/form/dynamic_form_event.dart';
import 'package:remotesurveyadmin/data/blocs/form/dynamic_form_state.dart';


class DynamicFormDataContainer extends StatefulWidget {
  final String documentId;
  final int formNumber;

  const DynamicFormDataContainer({super.key, required this.documentId, required this.formNumber});

  @override
  _DynamicFormDataContainerState createState() =>
      _DynamicFormDataContainerState();
}

class _DynamicFormDataContainerState extends State<DynamicFormDataContainer> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DynamicFormBloc>(context)
        .add(LoadFormEvent(documentId: widget.documentId, formNumber: 0));
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
        return Center(
          child: SingleChildScrollView(
              child: Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: Text("TODO: Rendering Data",
                style: Theme.of(context).textTheme.bodyLarge),
          )),
        );
      },
    );
  }
}
