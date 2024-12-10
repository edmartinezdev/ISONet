// ignore_for_file: prefer_generic_function_type_aliases, use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';
import 'package:iso_net/utils/platform_channel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'DownloadProgressDailog.dart';

typedef void DownloadProgressCallback(received, total);

class FileUtils {
  downloadFile(String fileName, String url,BuildContext context) async {
    Dio dio = Dio();
     await PlatformChannel().checkForPermission(Platform.isAndroid ? Permission.storage : Permission.mediaLibrary);

    String dirloc = "";

    if (Platform.isAndroid) {
      dirloc = "/storage/emulated/0/Download";
      await Directory("/storage/emulated/0/Download").create();
      if (kDebugMode) {
        print("dirPath$dirloc");
      }
      // Directory? dir ;
      // dir = await getExternalStorageDirectory();
      // dirloc = dir!.path.split('/').last;
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path;
      if(url.videoFormat()){
        GallerySaver.saveVideo(url);
        return true;
      }else{
        GallerySaver.saveImage(url);
        return false;
      }

    }

    try {

       await download2(dio, url, "$dirloc/$fileName",context);
       return true;

    } catch (e) {
      if (kDebugMode) {
        print(e);

      }
    }
  }

  download2(Dio dio, String url, String savePath,BuildContext context) async {
    ShowLoaderDialog.showLoaderDialog(context);
    try {
      Response response = await dio.get(
        url,
        //onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      if (kDebugMode) {
        print(response.headers);
      }
      File(savePath).create(recursive: true);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      ShowLoaderDialog.dismissLoaderDialog();
      return file;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ShowLoaderDialog.dismissLoaderDialog();
    }
  }

  void showDownloadProgress(received, total) {
    if (kDebugMode) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }

    if (total != -1) {
      if (kDebugMode) {
        print((received / total * 100).toStringAsFixed(0) + "%");
      }
      // ignore: unused_local_variable
      double progress = (received / total * 100);
//      _donwloadDailog.update(progress: progress);
//      if (progress >= 99) {
//        _donwloadDailog.hide();
//      }
    }
  }

/// CREATE & DOWNLOAD PDFVIEW WITH URL ------------------------------------------------------------------------------------------------------
// Future<File> createFileOfPdfUrl({String pdfUrl,String fileName = ""}) async {
//   final url = pdfUrl;
//   final filename = fileName;
//   var request = await HttpClient().getUrl(Uri.parse(url),);
//   var response = await request.close();
//   var bytes = await consolidateHttpClientResponseBytes(response);
//   String dir = Platform.isIOS ? (await getApplicationDocumentsDirectory()).path : "/storage/emulated/0/Downloads/";
//   File file = new File('$dir/$filename'+ '.pdf');
//   await file.writeAsBytes(bytes);
//   return file;
// }
}
