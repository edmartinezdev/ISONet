import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SwipeBackWidget<T> extends StatefulWidget {
  final Widget child;
  T result;


  SwipeBackWidget({Key? key, required this.child, required this.result}) : super(key: key);

  @override
  State<SwipeBackWidget<T>> createState() => _SwipeBackWidgetState<T>();
}

class _SwipeBackWidgetState<T> extends State<SwipeBackWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /*onHorizontalDragEnd: (DragEndDetails details) {
        if ((details.primaryVelocity ?? 0) > 0 && Platform.isIOS) {
          *//*Get.back<FeedData>(result: postDetails);*//*
          //Navigator.pop(context);
        }
      },*/
      onHorizontalDragUpdate: (details) {
        if (details.globalPosition.dx < 50 && Platform.isIOS) {
          // Only trigger swipe back from the left edge of the screen

          Get.back<T>(result: widget.result);
        }
      },
      child: widget.child,
    );
  }
}
