import 'package:flutter/material.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../style/text_style.dart';

class CustomNavBarWidget extends StatefulWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items; // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  final ValueChanged<int> onItemSelected;

  const CustomNavBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<CustomNavBarWidget> createState() => _CustomNavBarWidgetState();
}

class _CustomNavBarWidgetState extends State<CustomNavBarWidget> with AutomaticKeepAliveClientMixin<CustomNavBarWidget>{

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top:8),
      height: 60.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: 22.0,
                  color: isSelected
                      ? (item.activeColorSecondary ?? item.activeColorPrimary)
                      : item.inactiveColorPrimary ?? item.activeColorPrimary),
              child: isSelected ? item.icon : item.inactiveIcon!,
            ),
          ),
          4.sizedBoxH,
          Material(
            type: MaterialType.transparency,
            child: FittedBox(
                child: Text(
              item.title ?? '',
              style: isSelected
                  ? ISOTextStyles.openSenseBold(
                      size: 10,
                    )
                  : ISOTextStyles.openSenseSemiBold(size: 10, color: AppColors.showTimeColor),
            )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black,
            width: 0.1,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.items.map((item) {
            int index = widget.items.indexOf(item);
            return Flexible(
              child: GestureDetector(
                onTap: () {
                  widget.onItemSelected(index);
                },
                child: _buildItem(item, widget.selectedIndex == index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
