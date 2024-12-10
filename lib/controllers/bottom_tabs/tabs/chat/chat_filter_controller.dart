// import 'package:get/get.dart';
//
// import '../messenger_tab_controller.dart';
//
// class ChatFilterController extends GetxController{
//
//   var filterSelectionList = <FilterChat>[].obs;
//
//   onFilterChatSelect({required int index}) {
//     filterSelectionList.value = filterSelectionList.map((e) {
//       e.isFilterSelected.value = false;
//
//       return e;
//     }).toList();
//     filterSelectionList[index].isFilterSelected.value = true;
//     filterType.value = filterSelectionList[index].apiChatParam ?? '';
//     print(filterSelectionList[index].isFilterSelected.value);
//     print(filterType.value);
//   }
// }