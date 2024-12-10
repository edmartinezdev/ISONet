import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/preferences_key.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:iso_net/utils/file_download_util.dart';
import 'package:marquee/marquee.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../singelton_class/auth_singelton.dart';
import '../../ui/style/button_components.dart';
import '../../ui/style/dialog_components.dart';
import 'app_fonts.dart';
import 'common_api_function.dart';
import 'send_functionality.dart';

typedef AlertWidgetButtonActionCallback = void Function(int index);

const defaultFetchLimit = 20;


/// tap to unfocus / closed key board
class CommonUtils {

  static PublishSubject<bool> notificationStatus = PublishSubject();

  static setNotificationStatus(status) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(PreferenceKeys.notificationStatus, status);
  }
  static clearNotificationStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(PreferenceKeys.notificationStatus);
  }

  static void scopeUnFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  /// calculate file size in MB/KB
  static calculateFileSize(File image) {
    final bytes = image.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;
    Logger().i(mb);
    return mb;
  }



  /// visible / invisible the value
  static bool visibleOption(String value) {
    if (value.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }



  ///Get month year type function
  static String getMonthYear({required String type, required int value}) {
    if (type == 'MO' && value > 1) {
      return '$value Months';
    } else if (type == 'MO') {
      return '$value Month';
    } else if (type == 'YR' && value > 1 && value != 10) {
      return '$value Years';
    } else if (type == 'YR' && value == 10) {
      return '$value Years+';
    } else {
      return '$value Year';
    }
  }

  /*static String highlightSearchQuery(String text, String query) {
    final lowerCaseText = text.toLowerCase();
    final lowerCaseQuery = query.toLowerCase();

    final parts = lowerCaseText.split(lowerCaseQuery);

    final highlightedText = StringBuffer();
    int currentIndex = 0;
    for (var i = 0; i < parts.length; i++) {
      if (i != 0) {
        final match = text.substring(currentIndex, currentIndex + lowerCaseQuery.length);
        highlightedText.write(
          '<span style="background-color:${AppColors.primaryColor}; color:${AppColors.whiteColor}; font-weight:bold; font-size:14px;">$match</span>',
        );
        currentIndex += lowerCaseQuery.length;
      }
      highlightedText.write(
        '<span style="color:${AppColors.blackColor}; font-size:14px;">${parts[i]}</span>',
      );
      currentIndex += parts[i].length;
    }

    final pattern = RegExp(
      r"(\s|^)(:)(\w+)(:)(\s|$)",
      multiLine: true,
      caseSensitive: false,
    );
    final splitText = highlightedText.toString().splitMapJoin(
      pattern,
      onMatch: (match) {
        final emoji = match.group(3);
        final emojiCode = '0x1F${emoji?.toUpperCase()}';
        final emojiChar = String.fromCharCode(int.parse(emojiCode, radix: 16));
        return '${match.group(1)}$emojiChar';
      },
      onNonMatch: (text) => text,
    );
    highlightedText.clear();
    highlightedText.write(splitText);

    return highlightedText.toString();
  }*/


  /*static TextSpan highlightSearchQuery(String text, String query) {
    final lowerCaseText = text.toLowerCase();
    final lowerCaseQuery = query.toLowerCase();

    final parts = lowerCaseText.characters.split(lowerCaseQuery.characters).toList();

    final spans = <TextSpan>[];

    int currentIndex = 0;
    for (var i = 0; i < parts.length; i++) {
      if (i != 0) {
        final match = text.substring(currentIndex, currentIndex + lowerCaseQuery.length);
        spans.add(
          TextSpan(
            text: match,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: AppColors.primaryColor,
              color: AppColors.whiteColor,
              fontSize: 14,
              fontFamily: AppFont.sfProDisplayBold,
            ),
          ),
        );
        currentIndex += lowerCaseQuery.length;
      }
      spans.add(TextSpan(
        text: isUpperCase(text, currentIndex, parts[i].length),
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: 14,
          fontWeight: isUpperCase(text, currentIndex, parts[i].length) ? FontWeight.bold : FontWeight.normal,
        ),
      ));
      currentIndex += parts[i].length;
    }

    return TextSpan(children: spans);
  }

  static String isUpperCase(String text, int startIndex, int length) {
    for (var i = startIndex; i < startIndex + length; i++) {
      if (text[i] != text[i].toUpperCase()) {
        return text[i];
      }else{
        text[i].toUpperCase();
        return true;
      }
    }
    return true;
  }*/



  static TextSpan highlightSearchQuery(String text, String query) {
    final pattern = query.isNotEmpty ? RegExp(query, caseSensitive: false) : null;
    final spans = <TextSpan>[];

    int currentIndex = 0;
    var matches = <Match>[];
    if (pattern != null) {
      matches = pattern.allMatches(text).toList();
    } else {
      for (var i = 0; i < text.characters.length; i++) {
        spans.add(
          TextSpan(
            text: text.characters.elementAt(i).toString(),
            style: const TextStyle(
              color: AppColors.blackColor,
              fontSize: 14,
            ),
          ),
        );
      }
      return TextSpan(children: spans);
    }

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: const TextStyle(
              color: AppColors.blackColor,
              fontSize: 14,
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            backgroundColor: AppColors.primaryColor,
            color: AppColors.whiteColor,
            fontSize: 14,
            fontFamily: AppFont.sfProDisplayBold,
          ),
        ),
      );
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: const TextStyle(
            color: AppColors.blackColor,
            fontSize: 14,
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }

  /*static TextSpan highlightSearchQuery(String text, String query) {
    final pattern = RegExp(query, caseSensitive: false);
    final matches = pattern.allMatches(text);
    final spans = <TextSpan>[];

    int currentIndex = 0;
    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: const TextStyle(
              color: AppColors.blackColor,
              fontSize: 14,
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style:  TextStyle(
            fontWeight: FontWeight.bold,
            backgroundColor: AppColors.primaryColor,
            color: AppColors.whiteColor,
            fontSize: 14,
            fontFamily: AppFont.sfProDisplayBold,
          ),
        ),
      );
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: const TextStyle(
            color: AppColors.blackColor,
            fontSize: 14,
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }*/


  /*static TextSpan highlightSearchQuery(String text, String query) {
    // final lowerCaseText = text.toLowerCase();
    // final lowerCaseQuery = query.toLowerCase();

    final parts = text.characters.split(query.characters).toList();

    final spans = <TextSpan>[];

    int currentIndex = 0;
    for (var i = 0; i < parts.length; i++) {
      if (i != 0) {
        final match = text.substring(currentIndex, currentIndex + query.length);
        spans.add(
          TextSpan(
            text: match,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: AppColors.primaryColor,
              color: AppColors.whiteColor,
              fontSize: 14,
              fontFamily: AppFont.sfProDisplayBold,
            ),
          ),
        );
        currentIndex += query.length;
      }
      spans.add(TextSpan(
        text: parts[i].toString(),
        style: const TextStyle(
          color: AppColors.blackColor,
          fontSize: 14,
        ),
      ));
      currentIndex += parts[i].length;
    }

    return TextSpan(children: spans);
  }*/


  static Future<File> compressImage({
    required File image,
    int quality = 100,
    int percentage = 30,
  }) async {
    var path = await FlutterNativeImage.compressImage(image.absolute.path, quality: quality, percentage: percentage);
    return path;
  }

  /// constrained scaffold for mainAxisAlignment.spaceBetween for singleChildScrollView
  static constrainedBody({required List<Widget> children}) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }

  /// fixed heading label across an app
  static headingLabelBody({required String? headingText}) {
    return Column(
      children: [
        Text(
          headingText ?? '',
          style: ISOTextStyles.openSenseBold(size: 20, color: AppColors.headingTitleColor),
        ),
        24.sizedBoxH,
      ],
    );
  }

  /// fixed chips UI across an app
  static customChip({required String chipText, String? trailingIcon}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyColor,
        ),
        borderRadius: BorderRadius.circular(8.0.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(chipText),
          8.sizedBoxW,
          ImageComponent.loadLocalImage(imageName: trailingIcon ?? ''),
        ],
      ),
    );
  }

  ///report feed model popup
  static reportWidget(
      {int? feedId, int? forumId, int? articleId, required BuildContext context, bool? isReportForum, bool? isReportArticle, required List<String> buttonText, required String reportTyp}) {
    showMyBottomSheet(
      context,
      arrButton: buttonText,
      callback: (btnIndex) async {
        if (btnIndex == 0) {
          ///BtnIndex 0 for send post , send forum
          if(forumId != null){
            SendFunsctionality.sendBottomSheet(forumId: forumId , context: context,headingText: AppStrings.sendForum);
          }else {
            SendFunsctionality.sendBottomSheet(feedId: feedId , context: context,headingText: AppStrings.sendPost);
          }


        } else if (btnIndex == 1) {
          if (isReportArticle == true) {
            await CommonApiFunction.reportArticleApi(
                onError: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                },
                onSuccess: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                },
                articleID: articleId ?? 0);
          } else {
            TextEditingController textEditingController = TextEditingController();
            RxBool isReportButtonEnable = false.obs;
            return DialogComponent.showAlertWithTextField(
              context,
              title: buttonText[1],
              barrierDismissible: true,
              label: buttonText[1],
              contentPadding: const EdgeInsets.fromLTRB(24.0, 7.0, 20.0, 12.0),
              message: AppStrings.enterReason,
              arrButton: [
                AppStrings.cancel,
                buttonText[1],

              ],
              onChanged: (value) {
                if (value.length > 2) {
                  isReportButtonEnable.value = true;
                } else {
                  isReportButtonEnable.value = false;
                }
              },
              focusNode: FocusNode(),
              controller: textEditingController,
              callback: (btnIndex) {
                if (btnIndex == 0) {
                  Get.back();
                } else if (btnIndex == 1) {
                  if (isReportButtonEnable.value) {
                    CommonApiFunction.commonReportApi(
                        onErr: (msg) {
                          Get.back();
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                        },
                        onSuccess: (msg) {
                          Get.back();
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                        },
                        reportType: reportTyp,
                        reportId: isReportForum == true ? forumId : feedId,
                        description: textEditingController.text);
                  }
                } else {
                  return;
                }
              },
            );
          }

        } else if(btnIndex == 2){
          if (isReportForum == true) {
            await CommonApiFunction.flagForumApi(
                onError: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                },
                onSuccess: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                },
                forumId: forumId ?? 0);
          } else {
            await CommonApiFunction.flagFeedApi(
                onError: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                },
                onSucess: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                },
                feedId: feedId ?? 0);
          }
        }
      },
    );
  }

  ///report user model popup
  static reportUserWidget({
    required int userId,
    required BuildContext context,
    required List<String> buttonText,
    required String reportType,
    required onSuccessBlockAction,
    String? userName,
  }) {
    showMyBottomSheet(
      context,
      arrButton: buttonText,
      callback: (btnIndex) async {
        TextEditingController textEditingController = TextEditingController();
        RxBool isReportButtonEnable = false.obs;
        if (btnIndex == 0) {
          return DialogComponent.showAlertWithTextField(context,
              title: buttonText[0],
              label: buttonText[0],
              message: AppStrings.enterReason,
              arrButton: [
                AppStrings.cancel,
                buttonText[0],
              ],
              onChanged: (value) {
                if (value.length > 2) {
                  isReportButtonEnable.value = true;
                } else {
                  isReportButtonEnable.value = false;
                }
              },
              focusNode: FocusNode(),
              controller: textEditingController,
              callback: (btnIndex) {
                if (btnIndex == 0) {
                  Get.back();
                } else if (btnIndex == 1) {
                  if (isReportButtonEnable.value) {
                    CommonApiFunction.commonReportApi(
                        onErr: (msg) {
                          Get.back();
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                        },
                        onSuccess: (msg) {
                          Get.back();
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                          isReportButtonEnable.value = false;
                        },
                        reportType: reportType,
                        reportId: userId,
                        description: textEditingController.text);
                  } else {
                    null;
                  }
                }
              },
              barrierDismissible: true);
        } else if (btnIndex == 1) {
          await CommonApiFunction.flagUserApi(
              onError: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
              },
              onSuccess: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
              },
              userId: userId);
        } else if (btnIndex == 2) {
          DialogComponent.showAlert(
            context,
            title: AppStrings.appName,
            message: '${AppStrings.blockMessage} ${userName ?? ''}?',
            barrierDismissible: true,
            arrButton: [AppStrings.cancel, AppStrings.block],
            callback: (btnIndex) {
              if (btnIndex == 1) {
                CommonApiFunction.blockUser(
                    onErr: (msg) {
                      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                    },
                    onSuccess: (msg) {
                      onSuccessBlockAction(msg);
                    },
                    userId: userId);
              }
            },
          );
        }
      },
    );
  }

  ///Unblock user pop up
  static unBlockUserDialog({required userId, required userName, required BuildContext context, required apiMessage, required onSuccess, bool isChatOpen = false}) {
    DialogComponent.showAlert(context, title: AppStrings.appName, message: apiMessage, arrButton: [AppStrings.cancel, AppStrings.unblock], callback: (btnIndex) {
      if (btnIndex == 0 && isChatOpen == false) {
        Get.back();
      }
      if (btnIndex == 1) {
        DialogComponent.showAlert(
          context,
          title: AppStrings.appName,
          message: '${AppStrings.unBlockMessage} $userName?',
          arrButton: [
            AppStrings.cancel,
            AppStrings.confirm,
          ],
          callback: (btnIndex) {
            if (btnIndex == 0) {
              Get.back();
            }
            if (btnIndex == 1) {
              CommonApiFunction.unBlockUser(
                  onErr: (msg) {
                    SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                  },
                  onSuccess: (msg) {
                    onSuccess(msg);
                  },
                  userId: userId);
            }
          },
        );
      }
    });
  }

  ///report comment model popup
  static reportFeedCommentWidget({required int commentId, required BuildContext context, bool? isReportForumComment, bool? isReportArticle}) {
    showMyBottomSheet(context, arrButton: [AppStrings.reportComment], callback: (btnIndex) async {
      if (btnIndex == 0) {
        if (isReportArticle == true) {
          var reportApiResult = await CommonApiFunction.reportCommentArticleApi(
              onErr: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
              },
              onSuccess: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
              },
              commentId: commentId);
          if (reportApiResult) {}
        } else if (isReportForumComment == true) {
          var reportApiResult = await CommonApiFunction.reportForumCommentApi(
              onErr: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
              },
              onSuccess: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
              },
              commentId: commentId);
          if (reportApiResult) {}
        } else {
          var reportApiResult = await CommonApiFunction.reportFeedCommentApi(
              onError: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
              },
              onSuccess: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
              },
              commentId: commentId);
          if (reportApiResult) {}
        }
      }
    });
  }

  ///comment delete model popup
  static deleteWidget({required voidCallBack, required BuildContext context, required commentText}) {
    Platform.isIOS
        ? showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Colors.transparent,
                height: 105,
                margin: EdgeInsets.only(left: 8.w, right: 8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: voidCallBack,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: Text(
                        commentText,
                        style: ISOTextStyles.sfProDisplay(size: 16, color: AppColors.redColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: Text(
                        AppStrings.cancel,
                        style: ISOTextStyles.sfProDisplay(size: 16, color: AppColors.cancelButtonColor),
                      ),
                    ),
                  ],
                ),
              );
            })
        : showMyBottomSheet(Get.context!, arrButton: [commentText], callback: (btnIndex) {});

    10.sizedBoxH;
  }

  /// set aspect ratios to crop while selecting an image across an app
  static List<CropAspectRatioPreset> setAspectRatios() {
    return [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9,
      CropAspectRatioPreset.original,
    ];
  }

  static showMyBottomSheet(BuildContext context, {String title = '', String message = '', List<String>? arrButton, AlertWidgetButtonActionCallback? callback,Color? textColor}) {
    final titleWidget = (title.isNotEmpty)
        ? Text(
            title,
            style: ISOTextStyles.openSenseRegular(size: 13),
          )
        : null;
    final messageWidget = (message.isNotEmpty)
        ? Text(
            message,
            style: ISOTextStyles.openSenseRegular(size: 13),
          )
        : null;

    void onButtonPressed(String btnTitle) {
      int index = (arrButton ?? []).indexOf(btnTitle);
      //dismiss Dialog
      Get.back();

      // Provide callback
      if (callback != null) {
        callback(index);
      }
    }

    List<Widget> actions = [];

    for (String str in (arrButton ?? [])) {
      // bool isDestructive =
      //     (str.toLowerCase() == (commentText ?? "").toLowerCase()) || (str.toLowerCase() == (Translations.current?.btnNo ?? "").toLowerCase());
      actions.add(CupertinoDialogAction(
        child: Container(

          alignment: Alignment.center,
          height: 44.h,
          child: Text(str,
              style: ISOTextStyles.openSenseSemiBold(
                size: 20,
                color: str.contains(AppStrings.send) ? AppColors.blueColor : AppColors.redColor,
              )),
        ),
        onPressed: () => onButtonPressed(str),
        // isDestructiveAction: isDestructive,
      ));
    }

    final cancelAction = CupertinoDialogAction(
      onPressed: () => Get.back(),
      child: const Text(
        AppStrings.cancel,
      ),
    );
    final actionSheet = CupertinoActionSheet(
      title: titleWidget,
      message: messageWidget,
      actions: actions,
      cancelButton: cancelAction,
    );

    showCupertinoModalPopup(context: context, builder: (BuildContext context) => actionSheet).then((result) {
      Logger().v("Result :: $result");
    });
  }

  ///Function for textfield cursor set on end of string length while edi
  static textFieldEndLength({required TextEditingController textEditingController}) {
    return textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
  }

  ///Check is user is me or not
  static RxBool isUserMe({required id, bool isAdmin = false}) {
    if (userSingleton.id == id || isAdmin) {
      return false.obs;
    } else {
      return true.obs;
    }
  }

  ///Check Video Format
  static bool videoFormat({required String path}) {
    Logger().i(path);
    if (path.toLowerCase().contains('.mp4') || path.toLowerCase().contains('.mov') || path.toLowerCase().contains('.mkv')) {
      return true;
    } else {
      return false;
    }
  }

  /// Android / iOS UI for cropping page screen
  static List<PlatformUiSettings>? buildUiSettings() {
    return [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: false,
        toolbarColor: AppColors.whiteColor,
      ),
      IOSUiSettings(
        title: 'Crop Image',
      ),
    ];
  }

  /// alert dialog pop-up when tapped on '<' / 'back' button in appbar while sign up
  static buildExitAlert({required BuildContext context}) async {
    return DialogComponent.showAlertDialog(
      barrierDismissible: false,
      context: context,
      title: AppStrings.appName,
      content: AppStrings.exitSetupContent,
      arrButton: Platform.isAndroid
          ? [
              ButtonComponents.textButton(
                  onTap: () {
                    Get.back();
                  },
                  context: context,
                  title: 'Cancel'),
              ButtonComponents.textButton(
                  onTap: () async {
                    await userSingleton.clearPreference();
                    Get.offAllNamed(ScreenRoutesConstants.startupScreen);
                  },
                  context: context,
                  title: 'Exit'),
            ]
          : [
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Get.back();
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Exit'),
                onPressed: () async {
                  await userSingleton.clearPreference();
                  Get.offAllNamed(ScreenRoutesConstants.startupScreen);
                },
              ),
            ],
    );
  }

  ///Logout Dialog
  static buildSignOutAlert({required BuildContext context}) async {
    return DialogComponent.showAlertDialog(
      barrierDismissible: false,
      context: context,
      title: AppStrings.appName,
      content: AppStrings.signOut,
      arrButton: Platform.isAndroid
          ? <Widget>[
              ButtonComponents.textButton(
                  onTap: () {
                    Get.back();
                  },
                  context: context,
                  title: 'No'),
              ButtonComponents.textButton(
                  onTap: () async {
                    var logOutApi = await CommonApiFunction.logoutApi(onErr: (msg) {
                      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                    });
                    if (logOutApi) {
                      Get.offAllNamed(ScreenRoutesConstants.startupScreen);

                    }
                  },
                  context: context,
                  title: 'Yes'),
            ]
          : [
              CupertinoDialogAction(
                child: const Text('No'),
                onPressed: () {
                  Get.back();
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Yes'),
                onPressed: () async {
                  var logOutApi = await CommonApiFunction.logoutApi(onErr: (msg) {
                    SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                  });
                  if (logOutApi) {
                    Get.offAllNamed(ScreenRoutesConstants.startupScreen);
                  }
                },
              ),
            ],
    );
  }

  static buildSubscriptionAlert({required BuildContext context}) async {
    return DialogComponent.showAlertDialog(
      barrierDismissible: false,
      context: context,
      title: AppStrings.appName,
      content: 'Your plan is complete please subscribe again',
      arrButton: Platform.isAndroid
          ? <Widget>[
              ButtonComponents.textButton(
                  onTap: () async {
                    Get.offAllNamed(ScreenRoutesConstants.subscribeScreen, arguments: false);
                  },
                  context: context,
                  title: 'Subscribe'),
            ]
          : [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Subscribe'),
                onPressed: () async {
                  Get.offAllNamed(ScreenRoutesConstants.subscribeScreen, arguments: false);
                },
              ),
            ],
    );
  }

  ///remove 0 decimal from double
  static String removeDecimal(double number) {
    if (number > 1.0) {
      return '${number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 2)} Years';
    } else {
      return '${number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 2)} Year';
    }
  }

  static String convertToPhoneNumber({required String updatedStr}) {
    String newText = updatedStr.replaceAll("-", "").replaceAll("(", "").replaceAll(")", "").replaceAll(" ", "").replaceAll("/", "");
    return newText;
  }

  /// 'see more' or 'see less' texts in post contents
  static seeMoreText({required String content, required RxBool isExpand, VoidCallback? seeMoreTap}) {
    return content.length <= 80
        ? Text(
            content,
            style: ISOTextStyles.openSenseRegular(size: 14, linespacing: 1.8),
          )
        : Obx(
            () {
              return RichText(
                text: TextSpan(
                  text: isExpand.value ? content : '${content.substring(0, 80)} ... ',
                  style: ISOTextStyles.openSenseRegular(size: 14, linespacing: 1.8),
                  children: [
                    TextSpan(
                      text: 'see more',
                      recognizer: TapGestureRecognizer()..onTap = seeMoreTap,
                      style: ISOTextStyles.openSenseRegular(
                        size: 14,
                        color: AppColors.disableTextColor,
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }

  static telePhoneUrl(String phone) {
    final Uri phoneUrl = Uri(
      scheme: 'tel',
      path: phone,
    );

    launchUrl(phoneUrl);
  }

  static websiteLaunch(String url) async {
    if (url.contains('https://') || url.contains('http://')) {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $uri';
      }
    } else {
      Uri uri = Uri.parse('https://$url');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  static amountFormat({required String number}) {
    // Convert number into a string if it was not a string previously
    String stringNumber = number.toString();

    // Convert number into double to be formatted.
    // Default to zero if unable to do so
    double doubleNumber = double.tryParse(stringNumber) ?? 0;

    // Set number format to use
    NumberFormat numberFormat = NumberFormat.compactCurrency(locale: "en_US", symbol: '\$', name: 'NGN');

    return Text(
      numberFormat.format(doubleNumber),
      style: ISOTextStyles.openSenseSemiBold(size: 21),
    );
  }

  static Widget buildMarquee({required String text}) {
    return SizedBox(
      height: 20,
      child: Marquee(
        pauseAfterRound: const Duration(seconds: 1),
        numberOfRounds: 1,
        text: text,
        style: ISOTextStyles.openSenseRegular(
          size: 12,
        ),
      ),
    );
  }

  static countFormatString({required String number}) {
    // Convert number into a string if it was not a string previously
    String stringNumber = number.toString();

    // Convert number into double to be formatted.
    // Default to zero if unable to do so
    double doubleNumber = double.tryParse(stringNumber) ?? 0;

    // Set number format to use
    NumberFormat numberFormat = NumberFormat.compactCurrency(locale: "en_US", symbol: '', name: 'NGN');
    return numberFormat.format(doubleNumber);
  }

  static mapCompanyDirection({required String latitude, required String longitude}) async {
    final String googleMapslocationUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);
    Uri uri = Uri.parse(encodedURl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  static Future<bool> imageDownload({required String imageUrl, required BuildContext context}) async {
    String fileName = imageUrl.split('/').last;
    fileName = fileName.split('?').first;

    await FileUtils().downloadFile(fileName, imageUrl, context);

      return true;




  }

  ///date formatter
  static checkTimingsAgo({required String createdAt}) {
    var dateLocal = DateTime.parse(createdAt).toLocal();
    Logger().i(dateLocal);
    if (DateTime.now().difference(dateLocal).inSeconds < 60) {
      return ('${DateTime.now().difference(dateLocal).inSeconds} seconds ago');
    } else if (DateTime.now().difference(dateLocal).inSeconds < 3600) {
      return ('${DateTime.now().difference(dateLocal).inMinutes} minutes ago');
    } else if (DateTime.now().difference(dateLocal).inSeconds < 86400) {
      return ('${DateTime.now().difference(dateLocal).inHours} hours ago');
    } else {
      return ('${DateTime.now().difference(dateLocal).inDays} days ago');
    }
  }

  static Future<Map<String, dynamic>> getDataFromJsonEnvironment() async {
    String data = await rootBundle.loadString("assets/env.json");
    final jsonResult = jsonDecode(data);
    if (jsonResult != null) {
      return Future.value(jsonResult as Map<String, dynamic>);
    } else {
      return Future.value({});
    }
  }

  static Future<List<File>> convertXFileSingle({required XFile imageFile}) async {
    var file = <File>[].obs;
    var size = CommonUtils.calculateFileSize(File(imageFile.path));
    if (size > 2) {
      final File files = await CommonUtils.compressImage(image: File(imageFile.path));
      file.add(await FlutterExifRotation.rotateImage(
        path: files.path,
      ));
    } else {
      file.add(await FlutterExifRotation.rotateImage(
        path: imageFile.path,
      ));
    }
    Logger().i('Selected image file ==== $file');
    return file;
  }
}

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String updatedStr = newValue.text.replaceAll("(", "");
    updatedStr = updatedStr.replaceAll(")", "");
    updatedStr = updatedStr.replaceAll("-", "");
    updatedStr = updatedStr.replaceAll(" ", "");

    int usedSubstringIndex = 0;

    final int newTextLength = updatedStr.length;

    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
    }
    if (newTextLength >= 4) {
      newText.write('${updatedStr.substring(0, usedSubstringIndex = 3)}) ');
    }
    if (newTextLength >= 7) {
      newText.write('${updatedStr.substring(3, usedSubstringIndex = 6)}-');
    }
    if (newTextLength >= 11) {
      newText.write('${updatedStr.substring(6, usedSubstringIndex = 10)} ');
    }
    if (newTextLength >= usedSubstringIndex) {
      // Dump the rest.
      newText.write(updatedStr.substring(usedSubstringIndex));
    }

    int selectionIndex = newValue.selection.start + (newValue.text.length - newText.length).abs();
    selectionIndex = min(selectionIndex, newText.length);

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  CurrencyPtBrInputFormatter({required this.maxDigits});

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }

    double value = double.parse(newValue.text.replaceAll("\$", "").replaceAll(" ", ""));
    final formatter = NumberFormat("#,##0.00", "en_US");

    String newText = "\$ ${formatter.format(value / 100)}";
    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}

class DecimalInputFormatter extends TextInputFormatter {




  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }



    double value = double.parse(newValue.text.replaceAll("\$", "").replaceAll(" ", ""));
    final formatter = NumberFormat("0.00");

    String newText = "\$ ${formatter.format(value / 100)}";
    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}

class NumberFormatter {
  static getShortForm(int number) {
    var shortForm = "";
    if (number < 1000) {
      shortForm = number.toString();
    } else if (number >= 1000 && number < 1000000) {
      shortForm = "${(number / 1000).toStringAsFixed(1)}k";
    } else if (number >= 1000000 && number < 1000000000) {
      shortForm = "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000000000 && number < 1000000000000) {
      shortForm = "${(number / 1000000000).toStringAsFixed(1)}B";
    }
    return shortForm;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);
  final int decimalRange;
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;
    if (decimalRange != null) {
      String value = newValue.text;
      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";
        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
}
