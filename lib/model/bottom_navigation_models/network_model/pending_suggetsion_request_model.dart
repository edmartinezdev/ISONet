import 'network_tab_model.dart';


///********** PendingRequestModel ***********///
class PendingRequestModel{
  int? totalRecord;
  int? filterRecord;
  List<PendingRequest>? pendingRequestList;

  PendingRequestModel({this.totalRecord, this.filterRecord, this.pendingRequestList});

  PendingRequestModel.fromJson(Map<String,dynamic> json){
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['pending_request_data'] != null) {
      pendingRequestList = <PendingRequest>[];
      json['pending_request_data'].forEach((v) {
        pendingRequestList!.add(PendingRequest.fromJson(v));
      });
    }
  }
}


///********* ConnectionSuggestion Model **********///

class ConnectionSuggestionModel{
  int? totalRecord;
  int? filterRecord;
  List<ConnectionSuggestion>? connectionSuggestionList;

  ConnectionSuggestionModel({this.totalRecord, this.filterRecord, this.connectionSuggestionList});

  ConnectionSuggestionModel.fromJson(Map<String,dynamic> json){
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['connection_suggestion_data'] != null) {
      connectionSuggestionList = <ConnectionSuggestion>[];
      json['connection_suggestion_data'].forEach((v) {
        connectionSuggestionList!.add(ConnectionSuggestion.fromJson(v));
      });
    }
  }
}