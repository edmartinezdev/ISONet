import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/enums_all/enums.dart';

import '../../utils/alert_with_textfield_widget.dart';
import 'alert_component.dart';
import 'text_style.dart';

class DialogComponent {
  static showAlert(
    BuildContext context, {
    String? title,
    String? message,
    List<String>? arrButton,
    bool barrierDismissible = false,
    AlertWidgetButtonActionCallback? callback,
  }) {
    Widget alertDialog = AlertWidget(

      title: title ?? AppStrings.appName,
      message: message,
      buttonOption: arrButton,
      onCompletion: callback,
    );

    if (!barrierDismissible) {
      alertDialog = WillPopScope(
        child: alertDialog,
        onWillPop: () async {
          return false;
        },
      );
    }

    // flutter defined function
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context1) {
        return alertDialog;
      },
    );
  }

  static showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> arrButton,
    bool? barrierDismissible,
  }) {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? false,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text(title),
            content: Text(
              content,
            ),
            actions: arrButton,
          );
        },
      );
    } else if (Platform.isIOS) {
      return showCupertinoModalPopup(
        barrierDismissible: barrierDismissible ?? false,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: arrButton,
          );
        },
      );
    }
  }

  static showAttachmentDialog({required BuildContext context, required List<Widget> arrButton}) {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            alignment: Alignment.bottomLeft,
            insetPadding: EdgeInsets.all(8.0.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0.w),
            ),
            backgroundColor: AppColors.searchBackgroundColor,
            child: SizedBox(
              height: 100.w,
              width: 150.w,
              child: Row(
                children: arrButton,
              ),
            ),
          );
        },
      );
    } else if (Platform.isIOS) {
      return showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: arrButton,
        ),
      );
    }
  }

  static showDialogBody({
    required BuildContext context,
    bool barrierDismissible = true,
    required String dialogTitle,
    required ValueChanged<String> onSearch,
    required RxList searchList,
    required VoidCallback onTap,
    required String listTileText,
    required String buttonText,
    VoidCallback? onButtonTap,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible, // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0.h),
                  child: Text(
                    dialogTitle,
                    style: ISOTextStyles.openSenseBold(size: 16),
                  ),
                ),
                CupertinoSearchTextField(
                  onChanged: onSearch,
                ),
                Obx(
                  () => Expanded(
                    child: searchList.isEmpty
                        ? Center(
                            child: Text(
                              AppStrings.noDataFound,
                              style: ISOTextStyles.openSenseBold(size: 14),
                            ),
                          )
                        : ListView.builder(
                            itemCount: searchList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                onTap: onTap,
                                title: Text(
                                  listTileText,
                                  style: ISOTextStyles.openSenseSemiBold(size: 13),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                ),
                ButtonComponents.textButton(
                  alignment: Alignment.center,
                  context: context,
                  onTap: () => onButtonTap,
                  title: buttonText,
                  textColor: AppColors.blackColor,
                  textStyle: ISOTextStyles.openSenseBold(size: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //region Alert Control
  static showAlertWithTextField(BuildContext context,
      {required String title,
      required String label,
      required String message,
      required List<String> arrButton,
      required ValueChanged<String> onChanged,
      required FocusNode focusNode,
      required TextEditingController controller,
      EdgeInsetsGeometry? contentPadding,
      bool barrierDismissible = false,
      required AlertWidgetButtonActionCallback callback,
      Color? buttonColor}) {
    Widget alertDialog = AlertWithTextFieldWidget(
      title: title,
      message: message,
      controller: controller,
      onChanged: onChanged,
      label: label,
      focusNode: focusNode,
      buttonOption: arrButton,
      onCompletion: callback,
      buttonColor: buttonColor,
    );

    if (!barrierDismissible) {
      alertDialog = WillPopScope(
        child: alertDialog,
        onWillPop: () async {
          return false;
        },
      );
    }

    // flutter defined function
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  static showCupertinoModelPopupDatePicker({required BuildContext context,required ValueChanged<DateTime> onDateTimeChangedFunction,VoidCallback? onDoneButtonPress,DateTime? initialDatTime}){
    return showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 400.h,
          color: const Color.fromARGB(255, 255, 255, 255),
          /*decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradient1,
                AppColors.gradient2,
                AppColors.gradient3,
                AppColors.gradient4,
                AppColors.gradient5,
                AppColors.gradient6,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),*/
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(

                  onPressed: onDoneButtonPress ?? ()=> Get.back(),

                  child: Text(AppStrings.bDone,style: ISOTextStyles.openSenseSemiBold(size: 16),),
                ),
              ),
              SizedBox(
                height: 300.h,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDatTime ?? DateTime.now(),
                  minimumDate: DateTime(1950),
                  maximumDate: DateTime.now() ,
                  onDateTimeChanged: (val) {
                    onDateTimeChangedFunction(val);
                  },
                ),
              ),

              // Close the modal

            ],
          ),
        ));
  }
}
