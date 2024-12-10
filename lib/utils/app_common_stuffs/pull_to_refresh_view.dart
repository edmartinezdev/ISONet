// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

typedef RefreshCallback = Future<void> Function();
typedef ListBuilderCallBack = Widget Function(BuildContext context, int index);

class PullToRefreshListViewNew extends StatefulWidget {
  final int scrollOffset;
  final VoidCallback onEndOfPage;
  final bool isLoading;
  final RefreshCallback onRefresh;
  final double displacement;
  final Color? color;
  final Color? backgroundColor;
  final ScrollNotificationPredicate notificationPredicate;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double strokeWidth;
  final RefreshIndicatorTriggerMode triggerMode;
  final ListBuilderCallBack builder;
  final EdgeInsets? padding;
  final int itemCount;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const PullToRefreshListViewNew({
    Key? key,
    required this.onEndOfPage,
    required this.onRefresh,
    this.scrollOffset = 100,
    this.isLoading = false,
    this.displacement = 40.0,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 2.0,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    required this.builder,
    required this.itemCount,
    this.physics,
    this.controller,
    this.padding,
  }) : super(key: key);

  @override
  _PullToRefreshListViewNewState createState() => _PullToRefreshListViewNewState();
}

class _PullToRefreshListViewNewState extends State<PullToRefreshListViewNew> {
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isLoading;
  }

  @override
  void didUpdateWidget(PullToRefreshListViewNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isLoading = widget.isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleLoadMoreScroll,
      child: RefreshIndicator(
        onRefresh: widget.onRefresh,
        backgroundColor: widget.backgroundColor,
        color: widget.color,
        displacement: widget.displacement,
        notificationPredicate: widget.notificationPredicate,
        strokeWidth: widget.strokeWidth,
        triggerMode: widget.triggerMode,
        semanticsLabel: widget.semanticsLabel,
        semanticsValue: widget.semanticsValue,
        child: ListView.builder(
          physics: widget.physics,
          padding: widget.padding,
          scrollDirection: Axis.vertical,
          itemCount: widget.itemCount,
          itemBuilder: widget.builder,
          controller: widget.controller,
        ),
      ),
    );
  }

  bool _handleLoadMoreScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.maxScrollExtent > notification.metrics.pixels && notification.metrics.maxScrollExtent - notification.metrics.pixels <= widget.scrollOffset) {
        if (!_isLoading) {
          _isLoading = true;
          widget.onEndOfPage();
        }
      }
    }
    return false;
  }
}
