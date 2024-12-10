// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_fonts.dart';
import 'package:iso_net/utils/enums_all/enums.dart';
import 'package:iso_net/utils/extensions/text_style_extension.dart';

class AlertWidget extends StatefulWidget {
  final String? title;
  final String? message;
  final List<String>? buttonOption;
  final AlertWidgetButtonActionCallback? onCompletion;

  // ignore: use_key_in_widget_constructors
  const AlertWidget(
      {this.title, this.message, this.buttonOption, this.onCompletion});

  @override
  _AlertWidgetState createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  Widget? get titleWidget {
    String mainTitle = widget.title ?? '';
    if (mainTitle.isEmpty) {
      mainTitle = "App Name";
    }

    if (Platform.isIOS) {
      if (mainTitle.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              mainTitle,
              style: ISOTextStyle.setTS(
                fontFamily: AppFont.openSansBold,
                fontSize: 17,
                color: AppColors.darkBlackColor,
              ),
            ),
          ),
        );
      }
    } else if (Platform.isAndroid) {
      if (mainTitle.isNotEmpty) {
        return Text(
          mainTitle,
          style: ISOTextStyle.setTS(
            fontFamily: AppFont.openSansBold,
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: AppColors.darkBlackColor,
          ),
          textAlign: TextAlign.left,
        );
      }
    }
    return null;
  }

  Widget? get messageWidget {
    if ((widget.message ?? '').isNotEmpty) {
      var messageW = Text(
        widget.message ?? '',
        style: ISOTextStyle.setTS(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: AppColors.darkBlackColor,
        ),
      );
      return (Platform.isIOS)
          ? messageW
          : Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: messageW,
            );
    }
    return null;
  }

  List<Widget> get actionWidget {
    List<Widget> arrButtons = [];

    for (String str in (widget.buttonOption ?? [])) {
      Widget button;
      if (Platform.isIOS) {
        button = CupertinoDialogAction(
          isDestructiveAction: str.toLowerCase() == ("Cancel").toLowerCase(),
          child: Text(
            str,
            style:ISOTextStyle.setTS(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: AppColors.darkBlackColor,
            ),
          ),
          onPressed: () => onButtonPressed(str),
        );
      } else {
        button = TextButton(
          child: Text(
            str,
            style: ISOTextStyle.setTS(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: AppColors.darkBlackColor,
            ),
          ),
          onPressed: () => onButtonPressed(str),
        );
      }
      arrButtons.add(button);
    }
    return arrButtons;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: titleWidget,
        content: messageWidget,
        actions: actionWidget,
      );
    } else {
      return AlertDialog(

        title: titleWidget,
        content: messageWidget,
        actions: actionWidget,
        backgroundColor: AppColors.whiteColor,
        contentPadding: const EdgeInsets.fromLTRB(24.0, 7.0, 20.0, 12.0),
      );
    }
  }

  void onButtonPressed(String btnTitle) {
    int index = (widget.buttonOption ?? []).indexOf(btnTitle);

    //dismiss Diloag
    Navigator.of(context).pop();

    // Provide callback
    if (widget.onCompletion != null) {
      widget.onCompletion!(index);
    }
  }
}
