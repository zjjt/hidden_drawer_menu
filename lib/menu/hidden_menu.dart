import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/bloc/simple_hidden_drawer_bloc.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/provider/simple_hidden_drawer_provider.dart';

class HiddenMenu extends StatefulWidget {
  /// Decocator that allows us to add backgroud in the menu(img)
  final DecorationImage background;

  /// Decocator that allows us to add foreground in the menu(img) zjjt
  final DecorationImage foreground;

  /// that allows us to add shadow above menu items
  final bool enableShadowItensMenu;

  /// that allows us to add backgroud in the menu(color)
  final Color backgroundColorMenu;

  /// Items of the menu
  final List<ItemHiddenMenu> itens;

  /// Callback to recive item selected for user
  final Function(int) selectedListern;

  /// position to set initial item selected in menu
  final int initPositionSelected;

  HiddenMenu(
      {Key key,
      this.background,
      this.foreground,
      this.itens,
      this.selectedListern,
      this.initPositionSelected,
      this.backgroundColorMenu,
      this.enableShadowItensMenu = false})
      : super(key: key);

  @override
  _HiddenMenuState createState() => _HiddenMenuState();
}

class _HiddenMenuState extends State<HiddenMenu>
    with TickerProviderStateMixin {
  int _indexSelected;
  bool isconfiguredListern = false;
  //Adding an animation to the background image
  Animation<Offset> slideBackground;
  AnimationController slideInCtrl;
  //bloc instance added here ZJJT
  SimpleHiddenDrawerBloc _bloc;
  @override
  void initState() {
    _indexSelected = widget.initPositionSelected;
    slideInCtrl =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this);
    slideBackground = Tween<Offset>(
            begin: Offset.fromDirection(0),end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: slideInCtrl, curve: Curves.easeInOutBack));
    super.initState();
  }

  //disposing of the animations
  @override
  void dispose() {
    //slideInCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isconfiguredListern) {
      confListern();
      isconfiguredListern = true;
    }
    debugPrint('current range of elements in drawer menu is ${widget.itens.length}');
    //listening to the bloc opening the drawer to know when to animate
    _bloc = SimpleHiddenDrawerProvider.of(
        context); //getting thebloc instance here and listening to opening menu
    _bloc.controllers.getActionToggle.listen((d) {
      if (slideInCtrl.status == AnimationStatus.completed) {
        slideInCtrl.reverse();
      } else if (slideInCtrl.status == AnimationStatus.dismissed) {
        slideInCtrl.forward();
      }
    });
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: widget.background,
          color: widget.backgroundColorMenu,
        ),
        //added a stack to simulate animation of the background image
        child: Stack(children: <Widget>[
          SlideTransition(
            position: slideBackground,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(right: 20.0),
                height:400.0,
                decoration: BoxDecoration(image: widget.foreground),
              ),
            ),
          ),
          Container(
            child: Center(
              child: Container(
                padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                decoration: BoxDecoration(
                    boxShadow: widget.enableShadowItensMenu
                        ? [
                            new BoxShadow(
                              color: const Color(0x44000000),
                              offset: const Offset(0.0, 5.0),
                              blurRadius: 50.0,
                              spreadRadius: 30.0,
                            ),
                          ]
                        : []),
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    itemCount: widget.itens.length,
                    itemBuilder: (context, index) {
                      return new ItemHiddenMenu(
                        name: widget.itens[index].name,
                        selected: index == _indexSelected,
                        colorLineSelected:
                            widget.itens[index].colorLineSelected,
                        colorTextSelected:
                            widget.itens[index].colorTextSelected,
                        colorTextUnSelected:
                            widget.itens[index].colorTextUnSelected,
                        onTap: () {
                          SimpleHiddenDrawerProvider.of(context)
                              .setSelectedMenuPosition(index);
                        },
                      );
                    }),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void confListern() {
    SimpleHiddenDrawerProvider.of(context)
        .getPositionSelectedListern()
        .listen((position) {
      setState(() {
        _indexSelected = position;
      });
    });
  }
}
