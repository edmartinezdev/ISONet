

extension ValidationExtension on String {
  bool isStringValid({int minLength = 2, int maxLength = 250}) {
    if (length < minLength) {
      return false;
    } else if (length > maxLength) {
      return false;
    }
    return true;
  }

  String replaceSpaceAndComma() {
    return replaceAll("\$", "").replaceAll(",", "");
  }
  String replaceSpaceAndPlus() {
    return replaceAll("+", "");
  }

  bool videoFormat() {
    if (contains('.mp4') ||
        contains('.mov') ||
        contains('.mkv') ||
        contains('.wmv') ||
        contains('.avi') ||
        contains('.avchd') ||
        contains('.webm') ||
        contains('.html5') ||
        contains('.flv') ||
        contains('.f4v') ||
        contains('.swf')) {
      return true;
    } else {
      return false;
    }
  }
  String commentPlural(){
    if(length > 1){
      return 'comments';
    }else{
      return 'comment';
    }
  }

  String getMessageOnChatType(){
    if(contains("feed")){
      return 'Feed';
    }else if(contains("forum")){
      return 'Forum';
    }else if(contains("media")){
      return 'Media';
    }else{
      return '';
    }
  }




  String buyRates(){
    if(contains('.00')){
      return '';
    }else{
      return '.00';
    }
  }

}
