// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/main.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/model/subscribtion_plan_model.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/enums_all/enums.dart';

import '../../utils/app_common_stuffs/app_colors.dart';

class SubscribeController extends GetxController {
  var isUpgrade = Get.arguments;
  var isCardSelected = false.obs;
  var subscriptionBoxList = <SubscriptionBoxes>[].obs;
  var subscriptionList = <SubscribtionPlanModel>[].obs;

  var priceSelectIndex = Rxn();
  var isEnable = false.obs;
  var arPlan = <String>[].obs;
  var planType = ''.obs;
  String lastTransactionId = "";

  List<String> get arrayOfPlans {
    return
        // subscriptionBoxList[0].productList ?? '',
        // subscriptionBoxList[1].productList ?? '',
        arPlan;
  }

  StreamSubscription? connectionSubscription;
  StreamSubscription? purchaseUpdatedSubscription;
  StreamSubscription? purchaseErrorSubscription;

  var originalTransactionIdentifierIOS = ''.obs;
  var purchaseTokens = ''.obs;

  final _items = <IAPItem>[].obs;
  List<PurchasedItem> _purchases = [];
  var currentPage = 0.obs;
  var introScreenQna = <String>[].obs;

  ///******* it will change the indicator color while pageView changed *******
  Color changeIndicatorColor(int index) {
    return index == currentPage.value ? AppColors.indicatorColor : AppColors.greyColor;
  }

  ///******* onTap indicator to navigate the page *******
  onTapIndicator({required PageController pageController, required int index}) {
    pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  Future<void> initPlatformState() async {
    var result = await FlutterInappPurchase.instance.initialize();
    if (kDebugMode) {
      print('result: $result');
    }

    //if (!mounted) return; ///temporary comment

    connectionSubscription = FlutterInappPurchase.connectionUpdated.listen((connected) {
      if (kDebugMode) {
        print('connected: $connected');
      }
    });

    purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) {

      Logger().v("PURCHASE LISTERNER CALLED");
      if (productItem != null) {
        if (lastTransactionId != (productItem.transactionId ?? "")) {
          ShowLoaderDialog.dismissLoaderDialog();
          //Added this to avoid multiple callbacks for the same transaction
          if (kDebugMode) {
            print('PURCHASE-UPDATED: $productItem');
          }

          /// Check Platform
          if (Platform.isIOS) {
            if ((productItem.transactionStateIOS == TransactionState.purchased) || (productItem.transactionStateIOS == TransactionState.restored)) {
              _validateReceipt(objOfPurchasedItem: productItem);
            }
          } else {
            if (productItem.purchaseStateAndroid == PurchaseState.purchased) {
              purchaseTokens.value = productItem.purchaseToken ?? "";
              alreadySubscribed(objOfPurchasedItem: productItem);
            } else {
              if (kDebugMode) {
                print("Else purchase error.: ${productItem.purchaseStateAndroid}");
              }
            }
          }
        }
        lastTransactionId = productItem.transactionId ?? "";
      }
    });

    purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) {
      if (kDebugMode) {
        print('purchase-error: $purchaseError');
      }
      ShowLoaderDialog.dismissLoaderDialog();
    });

    _getProduct();
  }

  void _validateReceipt({required PurchasedItem objOfPurchasedItem}) async {
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    var receiptBody = {'receipt-data': objOfPurchasedItem.transactionReceipt ?? "", 'password': ApiConstant.appleAppSecret};
    var response = await FlutterInappPurchase.instance.validateReceiptIos(receiptBody: receiptBody, isTest: env == Environment.dev ? true : false);

    ShowLoaderDialog.dismissLoaderDialog();
    if (response.statusCode == 200) {
      Map<String, dynamic> dictMain = jsonDecode(response.body);
      var latestInfoAry = dictMain['latest_receipt_info'] as List<dynamic>;
      if (latestInfoAry.isNotEmpty) {
        var lastObj = latestInfoAry.last as Map<String, dynamic>;
        String originalTransactionId = lastObj['original_transaction_id'];
        originalTransactionIdentifierIOS.value = originalTransactionId;
        if (Platform.isIOS) {
          await FlutterInappPurchase.instance.finishTransactionIOS(objOfPurchasedItem.transactionId ?? "");
        } else {
          await FlutterInappPurchase.instance.finishTransaction(objOfPurchasedItem);
        }
        alreadySubscribed(objOfPurchasedItem: objOfPurchasedItem);

        /// API CAll
      }
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.warning, message: 'Something went wrong');
    }
  }

  Future _getProduct() async {
    List<IAPItem> items;
    if (Platform.isIOS) {
      items = await FlutterInappPurchase.instance.getProducts(arrayOfPlans);
    } else {
      items = await FlutterInappPurchase.instance.getSubscriptions(arrayOfPlans);
    }

    for (var item in items) {
      // ignore: unnecessary_string_interpolations
      if (kDebugMode) {
        print(item.toString());
      }
      _items.add(item);
    }

    _items.value = items;
  }

  Future<void> requestPurchase({required String planId}) async {
    if (Platform.isIOS) {
       await FlutterInappPurchase.instance.clearTransactionIOS();
    }
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    FlutterInappPurchase.instance.requestPurchase(planId).onError((error, stackTrace) {
      ShowLoaderDialog.dismissLoaderDialog();
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: error.toString());
    });
  }

  ///*** already Subscribed
  alreadySubscribed({required PurchasedItem objOfPurchasedItem}) async {
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    Map<String, dynamic> requestParams = {};
    if (Platform.isIOS) {
      requestParams['original_transaction_id'] = originalTransactionIdentifierIOS.value;
    } else {
      requestParams['purchase_token'] = purchaseTokens.value;
    }

    ResponseModel response = await sharedServiceManager.createPostRequest(
      typeOfEndPoint: ApiType.alreadySubscribed,
      params: requestParams,
    );
    ShowLoaderDialog.dismissLoaderDialog();
    if (response.status == ApiConstant.statusCodeSuccess) {
      ShowLoaderDialog.showLoaderDialog(Get.context!);
      addSubscription(
        objOfPurchased: objOfPurchasedItem,
      );
    } else {
      DialogComponent.showAlertDialog(
        context: Get.context!,
        title: 'Iso Net',
        content: response.message,
        arrButton: [
          ButtonComponents.cupertinoTextButton(
              context: Get.context!,
              onTap: () {
                Get.back();
              },
              title: 'OK'),
        ],
      );
    }
  }

  ///*** sign in API
  addSubscription({required PurchasedItem objOfPurchased}) async {
    Map<String, dynamic> requestParams = {};

    //requestParams['planId'] = planIdBehaviorSubject.hasValue ? planIdBehaviorSubject.value : "";
    Platform.isAndroid ? requestParams['purchase_token'] = purchaseTokens.value : requestParams['original_transaction_id'] = originalTransactionIdentifierIOS.value;
    requestParams['product_id'] = objOfPurchased.productId ?? "";
    requestParams['transaction_id'] = objOfPurchased.transactionId ?? "";
    requestParams['transaction_date'] = objOfPurchased.transactionDate.toString();
    requestParams['transaction_receipt'] = objOfPurchased.transactionReceipt ?? "";
    //requestParams['purchase_token'] = objOfPurchased.purchaseToken ?? "";
    //requestParams['dataAndroid'] = objOfPurchased.dataAndroid ?? "";
    //requestParams['signatureAndroid'] = objOfPurchased.signatureAndroid ?? "";
    //requestParams['isAcknowledgedAndroid'] = objOfPurchased.isAcknowledgedAndroid.toString();
    //requestParams['autoRenewingAndroid'] = objOfPurchased.autoRenewingAndroid.toString();
    //requestParams['developerPayloadAndroid'] = '';
    //requestParams['originalTransactionDateIOS'] = objOfPurchased.originalTransactionDateIOS.toString();
    //requestParams['originalTransactionIdentifierIOS'] = objOfPurchased.originalTransactionIdentifierIOS ?? "";
    //requestParams['transactionStateIOS'] = objOfPurchased.transactionStateIOS.toString();
    requestParams['device_type'] = Platform.isAndroid ? 'AND' : 'IOS';
    //requestParams['plan_type'] = objOfPurchased.productId?.contains("com.app.isonetyearlysubscription") == true ? 'YR' : 'MO';
    requestParams['plan_type'] = planType.value;
    isUpgrade == true ? requestParams['is_upgrade'] = isUpgrade : null;

    ResponseModel response = await sharedServiceManager.createPostRequest(
      typeOfEndPoint: ApiType.addSubscriptions,
      params: requestParams,
    );
    ShowLoaderDialog.dismissLoaderDialog();
    if (response.status == ApiConstant.statusCodeSuccess) {
      if (connectionSubscription != null) {
        connectionSubscription?.cancel();
        connectionSubscription = null;
      }
      purchaseUpdatedSubscription?.cancel();
      purchaseErrorSubscription?.cancel();
      await userSingleton.updateValue(response.data ?? <String, dynamic>{});
      if (isUpgrade == null) {
        return Get.offAllNamed(ScreenRoutesConstants.bottomTabsScreen);
      } else {
        if (isUpgrade) {
          Get.back();
        } else {
          return Get.offAllNamed(ScreenRoutesConstants.bottomTabsScreen);
        }
      }
    } else {
      DialogComponent.showAlertDialog(
        context: Get.context!,
        title: 'Iso Net',
        content: response.message,
        arrButton: [
          ButtonComponents.cupertinoTextButton(
              context: Get.context!,
              onTap: () {
                Get.back();
              },
              title: 'OK'),
        ],
      );
    }
  }

  /*onSubscribeButtonPressed({required int index}) {
    subscriptionBoxList.value = subscriptionBoxList.map((e) {
      e.isCardSelected.value = false;
      return e;
    }).toList();
    subscriptionBoxList[index].isCardSelected.value = true;
    print(subscriptionBoxList[index].isCardSelected.value);
  }*/

  onSubscribeButtonPressed2({required int index}) {
    subscriptionList.value = subscriptionList.map((e) {
      e.isCardSelected.value = false;
      return e;
    }).toList();
    subscriptionList[index].isCardSelected.value = true;
    planType.value = subscriptionList[index].type ?? '';
    Logger().i(planType.value);
    print(subscriptionList[index].isCardSelected.value);
  }

  subscriptionApiCall() async {
    ResponseModel<List<SubscribtionPlanModel>> responseModel = await sharedServiceManager.createGetRequest<List<SubscribtionPlanModel>>(typeOfEndPoint: ApiType.subscription);
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      subscriptionList.value = responseModel.data ?? [];
      for (int i = 0; i < subscriptionList.length; i++) {
        arPlan.add(subscriptionList[i].plan ?? '');
        Logger().i('Plans Array ==> $arPlan');
      }
      await initPlatformState();
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  Future getPurchases() async {
    List<PurchasedItem>? items = await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items ?? []) {
      print(item.toString());
      _purchases.add(item);
    }

    _items.value = [];
    _purchases = items ?? [];
  }

  Future getPurchases2() async {
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    List<PurchasedItem>? items = await FlutterInappPurchase.instance.getAvailablePurchases();
    ShowLoaderDialog.dismissLoaderDialog();
    for (var item in items ?? []) {
      print(item.toString());

      _purchases.add(item);
    }
    Logger().v('Purchases :- ${_purchases.last}');

    _purchases = items ?? [];

    if (_purchases.isEmpty) {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.success, message: AppStrings.noPlanFound);
    } /*else {
      if (Platform.isIOS) {
        _validateReceipt(objOfPurchasedItem: _purchases.last);
      } else {
        alreadySubscribed(objOfPurchasedItem: _purchases.last);
      }
    }*/
  }
}

class SubscriptionBoxes {
  String? priceText;
  String? monthYearText;
  String? freeTrialText;
  String? productList;
  RxBool isCardSelected = false.obs;

  SubscriptionBoxes({
    required this.priceText,
    required this.monthYearText,
    required this.freeTrialText,
    required this.productList,
  });
}
