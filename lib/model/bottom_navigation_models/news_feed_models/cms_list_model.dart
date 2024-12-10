class CMSModel {
  List<CMSModelData>? data;

  CMSModel({this.data});

  CMSModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CMSModelData>[];
      json['data'].forEach((v) {
        data!.add(CMSModelData.fromJson(v));
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

class CMSModelData {
  int? id;
  String? cmsKey;
  String? cmsText;

  CMSModelData({this.id, this.cmsKey, this.cmsText});

  CMSModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cmsKey = json['cms_key'];
    cmsText = json['cms_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cms_key'] = cmsKey;
    data['cms_text'] = cmsText;
    return data;
  }
}