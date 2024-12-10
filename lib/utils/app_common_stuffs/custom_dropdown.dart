// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/textfield_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';

class CustomDropdown<T> extends StatefulWidget {
  List<T?> modelList;
  T? model;

  CustomDropdown({
    Key? key,
    required this.modelList,
    required this.model,
  }) : super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      menuMaxHeight: MediaQuery.of(context).size.height / 3,
      elevation: 0,
      isDense: true,
      icon: ImageComponent.loadLocalImage(imageName: AppImages.downArrowFill, height: 10),
      decoration: InputDecoration(
        enabledBorder: TextFieldComponents(context: context).setEnabledBorder(),
        disabledBorder: TextFieldComponents(context: context).setDisableBorder(),
        focusedBorder: TextFieldComponents(context: context).setFocusedBorder(),
      ),
      items: widget.modelList.map((T? value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(
            value.toString(),
          ),
        );
      }).toList(),
      onChanged: (T? val) {
        widget.model = val;
        Logger().i(widget.model);
      },
    );
  }
}
