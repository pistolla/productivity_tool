import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndeterminateDialog extends StatefulWidget {
  int status = 1;
  String content;

  IndeterminateDialog(BuildContext context,
      {required this.status, required this.content});

  @override
  State<StatefulWidget> createState() => _IndeterminateDialog();
}

class _IndeterminateDialog extends State<IndeterminateDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          widget.status == 0
              ? CircularProgressIndicator()
              : Icon(
                  widget.status == 1
                      ? Icons.done_outline_outlined
                      : Icons.error_outline,
                  size: 65,
                  color: widget.status == 1 ? Colors.green : Colors.red),
          Text(
            widget.content,
            overflow: TextOverflow.clip,
            maxLines: 2,
          ),
        ],
      ),
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsets.all(20.0),
      backgroundColor: Colors.white,
    );
  }
}
