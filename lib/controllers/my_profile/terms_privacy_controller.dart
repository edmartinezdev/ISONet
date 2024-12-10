import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/my_profile/terms_privacy_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

class TermsPrivacyController extends GetxController{
  var cmsKey = Get.arguments;
  Rxn<TermsPrivacyModel> termsPrivacyData = Rxn();
  var termsPrivacyText = ''.obs;

  getTermsPrivacy()async{
    Map<String,dynamic> params = {};
    params['cms_key'] = cmsKey;
    ResponseModel<TermsPrivacyModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.termsPrivacyCms,params: params);
    ShowLoaderDialog.dismissLoaderDialog();
    if(responseModel.status == ApiConstant.statusCodeSuccess){
      //termsPrivacyData.value = responseModel.data;
      termsPrivacyText.value = responseModel.data?.cmsText ?? '';
    }else{
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

}