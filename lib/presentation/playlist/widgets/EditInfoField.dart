import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';

class EditInfoField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String value;
  final FormFieldValidator<String>? validator;

  final bool isExpanded;
  const EditInfoField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    required this.value,
    this.isExpanded = false,
  });

  @override
  State<EditInfoField> createState() => _EditInfoFieldState();
}

class _EditInfoFieldState extends State<EditInfoField> {
  @override
  void dispose() {
    super.dispose();
    widget.controller.clear();
  }

  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isExpanded
        ? TextFormField(
            expands: true,
            minLines: null,
            validator: widget.validator,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: widget.controller,
            decoration: InputDecoration(
              fillColor: AppColors.darkBackground,
              labelText: widget.label,
              labelStyle: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            ),
          )
        : TextFormField(
            minLines: 1,
            maxLines: 1,
            validator: widget.validator,
            keyboardType: TextInputType.text,
            controller: widget.controller,
            decoration: InputDecoration(
              fillColor: AppColors.darkBackground,
              labelText: widget.label,
              labelStyle: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            ),
          );
  }
}
