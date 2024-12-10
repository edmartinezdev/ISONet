import 'package:iso_net/helper_manager/network_manager/api_const.dart';

class ChatMediaModel {
  List<MediaData>? data;

  ChatMediaModel({this.data});

  ChatMediaModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MediaData>[];
      json['data'].forEach((v) {
        data!.add(MediaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MediaData {
  int? id;
  String? mediaType;
  String? chatMedia;
  String? thumbnail;
  String? createdAt;

  MediaData(
      {this.id,
        this.mediaType,
        this.chatMedia,
        this.thumbnail,
        this.createdAt});

  MediaData.fromJson(Map<String, dynamic> json) {
    if(json['id'] is String){
      id = int.parse(json['id'] ?? "-1");
    }else{
      id = json['id'];
    }

    mediaType = json['media_type'];
    chatMedia = json['chat_media'];
    thumbnail = json['thumbnail'] != null ? (json['thumbnail'].toString().startsWith('http') ? (json['thumbnail']) : ("${ApiConstant.imageBaseDomain}/${json['thumbnail']}")) : json['thumbnail'];

    /*if(json['thumbnail'] != null){
      var image = json['thumbnail'] as String ;
      if(image.startsWith("http")){
        thumbnail = json['thumbnail'];
      }else{
        thumbnail = "${ApiConstant.baseDomain}/media/${json['thumbnail']}";
      }

    }*/

    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['media_type'] = mediaType;
    data['chat_media'] = chatMedia;
    data['thumbnail'] = thumbnail;
    data['created_at'] = createdAt;
    return data;
  }
}