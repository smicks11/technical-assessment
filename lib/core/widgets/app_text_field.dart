import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.showObscureToggle = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final bool showObscureToggle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return _AppTextFieldStateful(
      controller: controller,
      label: label,
      hint: hint,
      initialObscure: obscureText,
      showObscureToggle: showObscureToggle || obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      autofocus: autofocus,
    );
  }
}

class _AppTextFieldStateful extends StatefulWidget {
  const _AppTextFieldStateful({
    this.controller,
    this.label,
    this.hint,
    required this.initialObscure,
    required this.showObscureToggle,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool initialObscure;
  final bool showObscureToggle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final bool autofocus;

  @override
  State<_AppTextFieldStateful> createState() => _AppTextFieldStatefulState();
}

class _AppTextFieldStatefulState extends State<_AppTextFieldStateful> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initialObscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        counterText: widget.maxLength != null ? '' : null,
        suffixIcon: widget.showObscureToggle
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.subtitle,
                  size: 22,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
      ),
    );
  }
}
