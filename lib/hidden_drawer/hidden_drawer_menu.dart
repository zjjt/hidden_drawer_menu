import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/screen_hidden_drawer.dart';
import 'package:hidden_drawer_menu/menu/hidden_menu.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/simple_hidden_drawer.dart';

class HiddenDrawerMenu extends StatelessWidget {
  /// List item menu and respective screens
  final List<ScreenHiddenDrawer> screens;

  /// position initial item selected in menu( sart in 0)
  final int initPositionSelected;

  /// Decocator that allows us to add backgroud in the content(color)
  final Color backgroundColorContent;

  //AppBar
  /// enable auto title in appbar with menu item name
  final bool whithAutoTittleName;

  /// Style of the title in appbar
  final TextStyle styleAutoTittleName;

  /// change backgroundColor of the AppBar
  final Color backgroundColorAppBar;

  ///Change elevation of the AppBar
  final double elevationAppBar;

  ///Change iconmenu of the AppBar
  final Widget iconMenuAppBar;

  /// Add actions in the AppBar
  final List<Widget> actionsAppBar;

  /// Set custom widget in tittleAppBar
  final Widget tittleAppBar;

  //Menu
  /// Decocator that allows us to add backgroud in the menu(img)
  final DecorationImage backgroundMenu;

    /// Decocator that allows us to add foreground in the menu(img) zjjt
  final DecorationImage foregroundMenu;

  /// that allows us to add backgroud in the menu(color)
  final Color backgroundColorMenu;

  /// that allows us to add shadow above menu items
  final bool enableShadowItensMenu;

  /// enable and disable open and close with gesture
  final bool isDraggable;

  /// enable and disable perspective
  final bool enablePerspective;

  //Modified by zjjt
  //enable stacked appbar
  final bool transparentAppBar;

  final Curve curveAnimation;

  HiddenDrawerMenu(
      {
      this.transparentAppBar,
      this.screens,
      this.initPositionSelected = 0,
      this.backgroundColorAppBar,
      this.elevationAppBar = 4.0,
      this.iconMenuAppBar = const Icon(Icons.menu),
      this.backgroundMenu,
      this.foregroundMenu,
      this.backgroundColorMenu,
      this.backgroundColorContent = Colors.white,
      this.whithAutoTittleName = true,
      this.styleAutoTittleName,
      this.actionsAppBar,
      this.tittleAppBar,
      this.enableShadowItensMenu = false,
      this.curveAnimation = Curves.decelerate,
      this.isDraggable = true,
      this.enablePerspective = false});

  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
      isDraggable: isDraggable,
      curveAnimation: curveAnimation,
      menu: buildMenu(),
      screenSelectedBuilder: (position, bloc) {
        if (transparentAppBar) {
          return Scaffold(
              resizeToAvoidBottomPadding: false, //modified by zjjt
              backgroundColor: backgroundColorContent,
              body: Stack(
                children: <Widget>[
                  screens[position].screen,
                  new Positioned(
                    //Place it at the top, and not use the entire screen
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: AppBar(
                      backgroundColor: backgroundColorAppBar,
                      elevation: elevationAppBar,
                      title: getTittleAppBar(position),
                      leading: iconMenuAppBar,
                      actions: actionsAppBar,
                    ), //Shadow gone
                  ),
                ],
              )
              //modification of the body to allow for transparent app bar
              );
        }
        return Scaffold(
          backgroundColor: backgroundColorContent,
          appBar: AppBar(
            backgroundColor: backgroundColorAppBar,
            elevation: elevationAppBar,
            title: getTittleAppBar(position),
            leading: iconMenuAppBar,
            actions: actionsAppBar,
          ),
          body: screens[position]
              .screen, //modification of the body to allow for transparent app bar
        );
      },
    );
  }

  getTittleAppBar(int position) {
    if (tittleAppBar == null) {
      return whithAutoTittleName
          ? Text(
              screens[position].itemMenu.name,
              style: styleAutoTittleName,
            )
          : Container();
    } else {
      return tittleAppBar;
    }
  }

  buildMenu() {
    List<ItemHiddenMenu> _itensMenu = new List();

    screens.forEach((item) {
      _itensMenu.add(item.itemMenu);
    });

    return HiddenMenu(
      itens: _itensMenu,
      background: backgroundMenu,
      foreground: foregroundMenu,
      backgroundColorMenu: backgroundColorMenu,
      initPositionSelected: initPositionSelected,
      enableShadowItensMenu: enableShadowItensMenu,
    );
  }
}
