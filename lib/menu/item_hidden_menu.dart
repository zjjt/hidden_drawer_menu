import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/bloc/simple_hidden_drawer_bloc.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/provider/simple_hidden_drawer_provider.dart';

//transforming into a stateful widget class ZJJT
//animating each element with a slide in fadein ZJJT

class ItemHiddenMenu extends StatefulWidget {
  /// name of the menu item
  final String name;

  /// callback to recibe action click in item
  final Function onTap;

  /// color used for selected item in line
  final Color colorLineSelected;

  /// color used in text for selected item
  final Color colorTextSelected;

  /// color used in text for unselected item
  final Color colorTextUnSelected;

  final bool selected;

  ItemHiddenMenu(
      {Key key,
      this.name,
      this.selected = false,
      this.onTap,
      this.colorLineSelected = Colors.blue,
      this.colorTextSelected = Colors.white,
      this.colorTextUnSelected = Colors.grey})
      : super(key: key);

  _ItemHiddenMenuState createState() => _ItemHiddenMenuState();
}

class _ItemHiddenMenuState extends State<ItemHiddenMenu>
    with TickerProviderStateMixin {
  AnimationController slideInCtrl, fadeInCtrl;
  Animation<double> fadeIn;
  Animation<Offset> slideIn;
  //bloc instance added here ZJJT
  SimpleHiddenDrawerBloc _bloc;

  void initState() {
    slideInCtrl =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    fadeInCtrl =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    slideIn = Tween<Offset>(
            begin: Offset.fromDirection(1.5708), end: Offset(0.0, 0.0))
        .animate(
      CurvedAnimation(parent: slideInCtrl, curve: Curves.easeInOutBack),
    );
    fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: slideInCtrl, curve: Curves.easeOutSine),
    );

    //widget.slideInCtrl.forward();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _bloc = SimpleHiddenDrawerProvider.of(
        context); //getting thebloc instance here and listening to opening menu
    _bloc.controllers.getActionToggle.listen((d) {
      if (slideInCtrl.status == AnimationStatus.completed) {
        fadeInCtrl.reverse();
        slideInCtrl.reverse();
      } else if (slideInCtrl.status == AnimationStatus.dismissed) {
        slideInCtrl.forward();
        fadeInCtrl.forward();
      }
    });
    print("value of the slidein animation : ${slideIn.value}");
    return SlideTransition(
      position: slideIn,
      child: FadeTransition(
        opacity: fadeIn,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 15.0),
          child: InkWell(
            onTap: widget.onTap,
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.0),
                      bottomRight: Radius.circular(4.0)),
                  child: Container(
                    height: 40.0,
                    color: widget.selected
                        ? widget.colorLineSelected
                        : Colors.transparent,
                    width: 5.0,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          color: widget.selected
                              ? widget.colorTextSelected
                              : widget.colorTextUnSelected,
                          fontSize: 25.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //slideInCtrl.dispose();
    //fadeInCtrl.dispose();
    super.dispose();
  }
}
