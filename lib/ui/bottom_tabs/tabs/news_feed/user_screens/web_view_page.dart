// import 'dart:async';
// import 'dart:convert';
// import 'dart:io' show Platform;
// import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:get/get.dart';
//
// import '../../../../../controllers/bottom_tabs/tabs/news_feed/setting_controller/user_setting_controller.dart';
// import '../../../../../helper_manager/network_manager/api_const.dart';
// import '../../../../../helper_manager/network_manager/remote_service.dart';
// import '../../../../../model/bottom_navigation_models/news_feed_models/cms_list_model.dart';
// import '../../../../../model/response_model/responese_datamodel.dart';
// import '../../../../../utils/app_common_stuffs/app_images.dart';
// import '../../../../../utils/app_common_stuffs/app_logger.dart';
// import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
// import '../../../../../utils/app_common_stuffs/strings_constants.dart';
// import '../../../../style/image_components.dart';
// import '../../../../style/text_style.dart';
//
// class WebViewPage extends StatefulWidget {
//
//   String titleText, htmlText, url;
//   WebViewPage({required this.titleText,required this.htmlText, required this.url});
//
//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }
//
// class _WebViewPageState extends State<WebViewPage> {
//
//   bool _isLoadingPage = true;
//   final _key = UniqueKey();
//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   UserSettingController userSettingController = Get.find<UserSettingController>();
//   String tmpUrl = '';
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     userSettingController.fetchCMSData(cmsKey: userSettingController.cmsKey.value);
//     if (widget.htmlText != null) {
//       String htmlcontent = widget.htmlText;
//       if (Platform.isIOS && !htmlcontent.contains("<html>")) {
//         htmlcontent = """<!DOCTYPE html>
//                         <html>
//                           <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
//                           <body style='"margin: 0; padding: 0;'>
//                             <div>
//                               $htmlcontent
//                             </div>
//                           </body>
//                         </html>
//                      """;
//       }
//       tmpUrl = Uri.dataFromString(htmlcontent, mimeType: 'text/html',encoding: Encoding.getByName('utf-8')).toString();
//     }
//     else {
//       tmpUrl = widget.url;
//       if (!tmpUrl.startsWith("http")) {
//         tmpUrl = "http://" + widget.url;
//       }
//     }
//     Logger().v("Opening Url :: $tmpUrl");
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return WebviewScaffold(
//       key: scaffoldKey,
//       appBar: appBarBody(),
//       url: tmpUrl,
//       hidden: true,
//       withZoom: true,
//       ignoreSSLErrors: true,
//     );
//
//     /*
//     var webViewStack =  Container(
//       color: Colors.white,
//       child: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           WebView(
//             key: _key,
//             initialUrl: tmpUrl,
//             javascriptMode: JavascriptMode.unrestricted,
//             onPageFinished: (_) {
//               if (_isLoadingPage == false) { return; }
//               setState(() {
//                 _isLoadingPage = false;
//               });
//             },
//           ),
//           Visibility(
//             visible: _isLoadingPage,
//             child: CircularProgressIndicator(),
//           ),
//         ],
//       ),
//     );
//     */
// /*
//     var webViewStack = WebView(
//       initialUrl: tmpUrl,
//       javascriptMode: JavascriptMode.unrestricted,
//     );
// */
//
//
//
// /*
//     return this.widget.createScaffoldWidget(
//       scaffoldKey: scaffoldKey,
//       appBar: getAppBarWidget(),
//       child: webViewStack
//     );
//  */
//   }
//
//   ///Appbar
//   PreferredSizeWidget appBarBody() {
//     return AppBar(
//       leading: IconButton(
//         onPressed: () => Get.back(result: true),
//         //onPressed: () => Get.back(),
//         icon: ImageComponent.loadLocalImage(
//           imageName: AppImages.arrow,
//         ),
//       ),
//       title: Container(
//         width: double.infinity,
//         alignment: Alignment.bottomCenter,
//         margin: const EdgeInsets.only(
//             top: 8,
//             right: 42),
//         child: Text(
//           widget.titleText.toUpperCase(),
//           style: ISOTextStyles.openSenseSemiBold(
//             size: 17,
//           ),
//         ),
//       ),
//       centerTitle: true,
//     );
//   }
//   // Widget getAppBarWidget() {
//   //
//   //   return AppBar(
//   //     appBarSize: Size.fromHeight(UIUtills().getProportionalWidth(70)),
//   //     elevation: 0,
//   //     leading: Container(
//   //       child: IconButton(
//   //         onPressed: () {
//   //           Navigator.pop(context);
//   //         },
//   //         icon: ImageIcon(
//   //           AssetImage(AppImage.back),
//   //           color: AppColor.whiteColor,
//   //         ),
//   //       ),
//   //     ),
//   //     centerTitle: false,
//   //     backgroundColor: AppColor.priceTextColor,
//   //     title: Container(
//   //       width: double.infinity,
//   //       alignment: Alignment.bottomCenter,
//   //       margin: EdgeInsets.only(
//   //           top: UIUtills().getProportionalHeight(8),
//   //           right: UIUtills().getProportionalWidth(42)),
//   //       child: Text(
//   //         this.widget.titleText.toUpperCase(),
//   //         style: UIUtills().getTextStyleRegular(
//   //           fontSize: 17,
//   //           color: AppColor.colorAppBarTitle,
//   //           fontName: AppFont.montserratBold,
//   //           characterSpacing: 1,
//   //         ),
//   //       ),
//   //     ),
//   //     flexibleSpace: Container(
//   //       decoration: BoxDecoration(
//   //         gradient: CommonWidget.appBarLinearGradient(
//   //           Alignment(-1, 1),
//   //           Alignment(2, -4),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//
// }
