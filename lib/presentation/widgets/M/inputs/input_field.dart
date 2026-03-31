import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.onChanged,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.isPassword = false,
  });

  final Function(String) onChanged;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final String? errorText;
  final bool isPassword;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final TextEditingController _controller = TextEditingController();
  bool _obscureText = true;

  void _onObscureTextChanged() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textCapitalization: TextCapitalization.words,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(widget.prefixIcon, color: Colors.grey.shade600),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorText: widget.errorText,
        errorStyle: TextStyle(color: Colors.red),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: _onObscureTextChanged,
                )
                : null,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
