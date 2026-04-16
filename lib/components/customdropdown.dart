import 'package:commitlock/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDropdownWithInput extends StatefulWidget {
  final List<String> items;
  final String? value;
  final String label;
  final String customLabel;
  final String customKey; // e.g. "custom"
  final TextEditingController controller;
  final String Function(String) itemLabel;
  final bool isNum;
  final void Function(String? value, String? customValue) onChanged;
    final String? Function(String?)? validator;

  const CustomDropdownWithInput({
    super.key,
    required this.items,
    required this.value,
    required this.label,
    required this.customLabel,
    required this.controller,
    required this.itemLabel,
    this.isNum = false,
    required this.onChanged,
    this.customKey = "custom",
     this.validator,
  });

  @override
  State<CustomDropdownWithInput> createState() =>
      _CustomDropdownWithInputState();
}

class _CustomDropdownWithInputState
    extends State<CustomDropdownWithInput> {
  bool isCustom = false;
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
    isCustom = selectedValue == widget.customKey;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            hintStyle: Textfont.subText,
            hintText: widget.label,
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.accentColor),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondaryColor),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.dangerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.dangerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondaryColor),
              borderRadius: BorderRadius.circular(12),
            ),
          
          ),
          items: widget.items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(widget.itemLabel(item)),
            );
          }).toList(),
          validator: (value) {
            // 🔥 First: validate dropdown
            if (value == null || value.isEmpty) {
              return 'Please select ${widget.label.toLowerCase()}';
            }

            // // 🔥 Second: if custom selected, validate text field
            // if (value == widget.customKey) {
            //   return Validators.emptyValidator(widget.controller.text);
            // }

            return null;
          },
          onChanged: (value) {
            setState(() {
              selectedValue = value;
              isCustom = value == widget.customKey;
            });

            widget.onChanged(value, widget.controller.text);
          },
        ),

        const SizedBox(height: 12),

        if (isCustom)
          TextFormField(
            controller: widget.controller,
            keyboardType: widget.isNum ? TextInputType.number : TextInputType.text,
            validator: 
            widget.validator,
              
             
            decoration: InputDecoration(
        hintText: widget.customLabel,
        hintStyle: Textfont.subText,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.dangerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.dangerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
            onChanged: (val) {
              widget.onChanged(selectedValue, val);
            },
          ),
      ],
    );
  }
}