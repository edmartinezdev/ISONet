// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';

class TextFieldComponents extends StatelessWidget {
  BuildContext context;
  TextEditingController? textEditingController;
  TextCapitalization? textCapitalization;
  TextInputType keyboardType;
  TextInputAction? textInputAction;
  List<TextInputFormatter>? textInputFormatter;
  bool obscure;
  int? maxLength;
  int? maxLines;
  String? hint;
  Color? hintColor;
  Function(String s)? onChanged;
  Widget? iconSuffix;
  Widget? prefixIcon;
  bool enable;

  FocusNode? focusNode;

  TextFieldComponents({
    Key? key,
    required this.context,
    this.textEditingController,
    this.textCapitalization,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.obscure = false,
    this.enable = true,
    this.maxLength,
    this.maxLines = 1,
    this.hint,
    this.onChanged,
    this.prefixIcon,
    this.iconSuffix,
    this.textInputFormatter,
    this.hintColor,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      enableSuggestions: false,
      focusNode: focusNode,
      enabled: enable,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hint ?? '',
        suffixIcon: iconSuffix,
        prefixIcon: prefixIcon,
        border: setEnabledBorder(),
        enabledBorder: setEnabledBorder(),
        disabledBorder: setDisableBorder(),
        focusedBorder: setFocusedBorder(),
        contentPadding: const EdgeInsets.only(top: 16, bottom: 16, left: 18),
        hintStyle: ISOTextStyles.hintTextStyle(color: hintColor),
        // contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
      ),
      style: ISOTextStyles.textFieldTextStyle(),
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      onChanged: (value) => onChanged == null ? null : onChanged!(value),
      cursorColor: AppColors.blackColor,
      inputFormatters: textInputFormatter,
      obscureText: obscure,
    );
  }

  InputBorder setEnabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0.r),
      borderSide: const BorderSide(color: AppColors.greyColor),
    );
  }

  InputBorder setDisableBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0.r),
      borderSide: const BorderSide(color: AppColors.greyColor),
    );
  }

  InputBorder setFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0.r),
      borderSide: const BorderSide(color: AppColors.greyColor),
    );
  }

  static Widget buildLabelForTextField({required String text, required BuildContext context}) {
    return Text(
      text,
      style: ISOTextStyles.textFieldTitleTextStyle(),
    );
  }
}
