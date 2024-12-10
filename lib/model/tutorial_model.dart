import 'package:get/get.dart';

class TutorialModel{
  String? tutorialText;
  String? tutorialImage;
  String? tutorialArrowImage;
  var skipTutorial = false.obs;

  TutorialModel({this.tutorialText,this.tutorialImage,this.tutorialArrowImage});
}