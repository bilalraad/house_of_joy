import 'package:flutter/material.dart';

///this just a normal custumized text form field 
class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key key,
    TextEditingController controller,
    this.onSaved,
    this.suffixIcon,
    this.suffixWidget,
    this.hint,
    this.obsecure = false,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.errorText,
  }) : _controller = controller;

  final TextEditingController _controller;
  final FormFieldSetter<String> onSaved;
  final Icon suffixIcon;
  final Widget suffixWidget;
  final String hint;
  final bool obsecure;
  final bool readOnly;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onChanged;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(0.3), width: 2.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: TextFormField(
          readOnly: readOnly,
          controller: _controller,
          onSaved: onSaved,
          validator: validator,
          obscureText: obsecure,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.all(10),
            hintStyle: const TextStyle(
              fontFamily: 'ae_Sindibad',
              color: Color(0xffA2A2A2),
            ),
            suffixIcon: suffixWidget ??
                Padding(
                  child: IconTheme(
                    data: const IconThemeData(color: Colors.black),
                    child: suffixIcon ?? Container(width: 0),
                  ),
                  padding: const EdgeInsets.only(left: 30, right: 10),
                ),
          ),
        ),
      ),
    );
  }
}
