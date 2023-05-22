import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitachi/helper/text/label.dart';

class BoxInputField extends StatelessWidget {
  const BoxInputField(
      {Key? key,
      this.labelText,
      this.controller,
      this.height = 40,
      this.type,
      this.maxLength,
      this.textInputFormatter,
      this.onChanged,
      this.validator,
      this.maxLines,
      this.textStyle,
      this.enabled,
      this.onEditingComplete,
      this.focusNode})
      : super(key: key);

  final String? labelText;
  final TextEditingController? controller;
  final double height;
  final TextInputType? type;
  final int? maxLength;
  final List<TextInputFormatter>? textInputFormatter;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextStyle? textStyle;
  final bool? enabled;
  final Function()? onEditingComplete;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(labelText ?? ""),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: height,
          child: TextFormField(
            focusNode: focusNode,
            validator: validator,
            onChanged: onChanged,
            controller: controller,
            maxLength: maxLength,
            keyboardType: type,
            enabled: enabled,
            onEditingComplete: () => onEditingComplete?.call(),
            // maxLines: maxLines,
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // set overflow behavior of the input decoration
              contentPadding: EdgeInsets.symmetric(horizontal: 12),

              // set hint text overflow behavior
            ),

            inputFormatters: textInputFormatter,
          ),
        ),
      ],
    );
  }
}
