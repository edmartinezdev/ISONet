import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../../../model/bottom_navigation_models/chat_model/recent_chat_model.dart';

class SearchMessageController extends GetxController{
  var chatList = <ChatDataa>[].obs;
  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;
  var isSearchEnable = false.obs;
  var isSearching = false.obs;

  apiCallSearchMessages({required String searchText, bool isShowLoader = false})async{
    Map<String,dynamic> params= {};
    params['user_id'] = userSingleton.id;
    params['search'] = searchText;
    params['skip'] = chatList.length;
    params['limit'] = defaultFetchLimit;
    ResponseModel<ChatListData> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.searchMessage,params: params);
    isSearchEnable.value = true;
    isSearching.value = false;
    if(isShowLoader){
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if(responseModel.status == ApiConstant.statusCodeSuccess){
      if(chatList.isEmpty){
        chatList.value = responseModel.data?.data ?? [];
      }else{
        chatList.addAll(responseModel.data?.data ?? []);
      }
      isAllDataLoaded.value = (chatList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    }else{
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }
}