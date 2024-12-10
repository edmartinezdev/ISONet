import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/add_group_name_controller.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/recent_chat_model.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_map_keys.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../style/button_components.dart';
import '../../../../style/image_components.dart';
import '../../../../style/text_style.dart';
import '../../../../style/textfield_components.dart';

class AddGroupNameScreen extends StatefulWidget {
  const AddGroupNameScreen({Key? key}) : super(key: key);

  @override
  State<AddGroupNameScreen> createState() => _AddGroupNameScreenState();
}

class _AddGroupNameScreenState extends State<AddGroupNameScreen> {

  AddGroupNameController groupNameController = Get.find<AddGroupNameController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  PreferredSizeWidget appBarBody() {
    return AppBar(
      leading: IconButton(
        icon: ImageComponent.loadLocalImage(imageName: AppImages.arrow),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  Widget buildBody() {
    return CommonUtils.constrainedBody(children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.addGroupName,
              style: ISOTextStyles.openSenseBold(size: 22),
            ),
            22.sizedBoxH,
            groupNameAndTextField()
          ],
        ),
      ),
      addGroupNameButton(),
    ]);
  }

  Widget groupNameAndTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.groupName,
          style: ISOTextStyles.openSenseSemiBold(size: 18),
        ),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.groupName,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            groupNameController.groupNameController.text = value;
            groupNameController.validateButton();
          },
        ),
      ],
    );
  }

  Widget addGroupNameButton() {
    return Obx(() =>
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: ButtonComponents.cupertinoButton(
            width: double.infinity,
            context: context,
            title: AppStrings.addGroupName,
            backgroundColor: groupNameController.isEnabled.value ? AppColors.primaryColor : AppColors.disableButtonColor,
            textStyle: groupNameController.isEnabled.value ? ISOTextStyles.openSenseSemiBold(size: 17,color: AppColors.blackColor) :ISOTextStyles.openSenseRegular(size: 17,color: AppColors.disableTextColor),
            onTap: () {
              groupNameController.groupName = groupNameController.groupNameController.text;
              onAddGroupNameButtonPressed();
            },
          ),
        ));
  }

  onAddGroupNameButtonPressed() async{
    var validationResult = groupNameController.isValidFormForGroupName();
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {

      /// Todo:- Change this as per new socket manager
      Map<String, dynamic> socketParams = <String, dynamic>{};
      socketParams[AppMapKeys.room_name] = groupNameController.roomName ?? "";
      socketParams[AppMapKeys.group_name] = groupNameController.groupNameController.text;
      socketParams[AppMapKeys.user_Id] = userSingleton.id ?? -1;

      SocketManagerNew().updateGroupEvent(socketParams, onSend: (ChatDataa objChatData){

      }, onError: (msg){
        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
      });
    }
  }
}
