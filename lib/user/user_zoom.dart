import 'package:csi/user/user_home.dart';
import 'package:csi/user/user_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class UserZoomDrawer extends StatelessWidget {
  final int index;

  const UserZoomDrawer({super.key, required this.index});
  static final ZoomDrawerController drawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ZoomDrawer(
          showShadow: true,
          style: DrawerStyle.style1,
          controller: drawerController,
          mainScreenTapClose: true,
          menuScreenTapClose: true,
          mainScreen: UserHomeScreen(
            index: index,
            // zoomController: drawerController,
          ),
          menuScreen: const UserMenu(),
          borderRadius: 24.0,
          slideWidth: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }
}
