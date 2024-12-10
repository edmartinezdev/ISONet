// ignore_for_file: library_private_types_in_public_api

import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iso_net/utils/app_common_stuffs/app_fonts.dart';

import '../ui/style/text_style.dart';
import 'app_common_stuffs/app_colors.dart';
import 'app_common_stuffs/commom_utils.dart';
import 'extensions/text_style_extension.dart';

// ignore: must_be_immutable
class AlertWithTextFieldWidget extends StatefulWidget {
//  VoidCallback onEditComplete;
  ValueChanged<String> onChanged;
  FocusNode focusNode;
  TextEditingController controller;
  EdgeInsetsGeometry? contentPadding;
  final String? title;
  final String label;
  final String message;
  final List<String> buttonOption;
  final AlertWidgetButtonActionCallback onCompletion;
  Color? buttonColor;

  AlertWithTextFieldWidget({super.key,
    required this.title,
    required this.message,
    required this.buttonOption,
    required this.label,
    required this.onCompletion,
    this.contentPadding,
    required this.onChanged,
    required this.focusNode,
    required this.controller,
    this.buttonColor,
  });

  @override
  _AlertWithTextFieldWidgetState createState() => _AlertWithTextFieldWidgetState();
}

class _AlertWithTextFieldWidgetState extends State<AlertWithTextFieldWidget> {
  Widget? get titleWidget {
    String mainTitle = widget.title ?? '';
    if (mainTitle.isEmpty) {
      mainTitle = "Iso Net";
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
    if ((widget.message).isNotEmpty) {
      var messageW = Container(
        //height: UIUtils().getProportionalWidth(35.0),
        //width: UIUtils().screenWidth * 0.7,

        decoration: BoxDecoration(
          //color: (Platform.isAndroid)? AppColors.dimWhiteColor : AppColors.whiteColor,
          color: (Platform.isAndroid) ? AppColors.disableButtonColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(top: 16, bottom: 16, left: 18, right: 18),
            hintText: widget.message,
            hintStyle: ISOTextStyles.hintTextStyle(),
          ),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          style: ISOTextStyles.textFieldTextStyle(),
          cursorColor: AppColors.blackColor,
          maxLines: 5,
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
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

    for (String str in (widget.buttonOption)) {
      Widget button;
      if (Platform.isIOS) {
        button = CupertinoDialogAction(
          isDestructiveAction: str.toLowerCase() == ("Cancel").toLowerCase(),
          child: Text(
            str,
            style: ISOTextStyle.setTS(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: widget.buttonColor ?? AppColors.darkBlackColor,
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
              color: widget.buttonColor ?? AppColors.darkBlackColor,
            ),
          ),
          onPressed: () => onButtonPressed(str),
        );
      }
      arrButtons.add(button);
    }
    return arrButtons;
  }

  /*List<Widget> get actionWidgert {
    List<Widget> arrButtons = [];

    for (String str in widget.buttonOption) {
      Widget button;
      if (Platform.isIOS) {
        button = CupertinoDialogAction(
            isDestructiveAction: str.toLowerCase() == Translations.of(NavigationService().context).btnCancel.toLowerCase(),
            child: Text(
              str,
              style: UIUtils().getTextStyle(
                fontName: AppFont.muliSemiBold,
                fontsize: 15,
                color: AppColor.greenColor,
//                characterSpacing: 0.68,
              ),
            ),
            onPressed: () => onButtonPressed(str));
      } else {
        button = ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: AppColor.blueButtonColor,
              textStyle: UIUtils().getTextStyle(
                fontName: AppFont.muliSemiBold,
                fontsize: 15,
                color: AppColor.whiteColor,
//              characterSpacing: 0.68,
              )),
          child: Text(
            str,
          ),
          onPressed: () => onButtonPressed(str),
        );
      }
      arrButtons.add(button);
    }
    return arrButtons;
  }*/

  @override
  Widget build(BuildContext context) {
    StatelessWidget alertDialog;
    if (Platform.isIOS) {
      alertDialog = CupertinoAlertDialog(
        title: titleWidget,
        content: Card(color: Colors.transparent, elevation: 0.0, child: Column(children: [messageWidget!])),
        actions: actionWidget,
      );
    } else {
      alertDialog = AlertDialog(
        title: titleWidget,
        content: SizedBox(width: double.maxFinite, child: messageWidget),
        actions: actionWidget,
        backgroundColor: AppColors.whiteColor,
        contentPadding: const EdgeInsets.fromLTRB(24.0, 7.0, 20.0, 12.0),
      );
    }
    return alertDialog;
  }

  void onButtonPressed(String btnTitle) {
    int index = widget.buttonOption.indexOf(btnTitle);

    //dismiss Dialog
    //Navigator.of(_alertContext).pop();

    // Provide callback
    widget.onCompletion(index);
  }
}
