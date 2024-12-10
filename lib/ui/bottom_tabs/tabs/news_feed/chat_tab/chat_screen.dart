import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/chat_screen_controller.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../style/image_components.dart';
import '../../../../style/text_style.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  ChatScreenController messengerController = Get.find<ChatScreenController>();

  @override
  void initState() {
    super.initState();
    Logger().i(messengerController.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: Center(
        child: GestureDetector(onTap: () {
          // SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: roomId);
        }, child: const Text("ok")),
      ),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      title: Align(
        alignment: Alignment.center,
        child: Text(
          'Name',
          style: ISOTextStyles.openSenseRegular(size: 17, color: AppColors.chatHeadingName),
        ),
      ),
      actions: [
        CircleAvatar(
          radius: 14,
          child: InkWell(onTap: () {}, child: ImageComponent.loadLocalImage(imageName: AppImages.threeDotFill)),
        ),
        10.sizedBoxW,
      ],
    );
  }
}
