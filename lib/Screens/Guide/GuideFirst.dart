import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tt/Bloc/MenuBlocGuide.dart';
import 'package:tt/models/model.dart';
import 'package:tt/utils/uidata.dart';

import 'ConfirmRequests.dart';

class HomePageGuide extends StatelessWidget {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  Size deviceSize;
  BuildContext _context;

  //menuStack
  Widget menuStack(BuildContext context, Menu menu) => InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfirmRequests()),
          );
        },
        splashColor: Colors.orange,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              menuImage(menu),
              menuColor(),
              menuData(menu),
            ],
          ),
        ),
      );

  //stack 1/3
  Widget menuImage(Menu menu) => Image.asset(
        menu.image,
        fit: BoxFit.cover,
      );

  //stack 2/3
  Widget menuColor() => new Container(
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 5.0,
          ),
        ]),
      );

  //stack 3/3
  Widget menuData(Menu menu) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            menu.icon,
            color: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            menu.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      );

  //appbar
  Widget appBar() => SliverAppBar(
        backgroundColor: Colors.black,
        pinned: true,
        elevation: 10.0,
        forceElevated: true,
        expandedHeight: 150.0,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          background: Container(
            decoration: BoxDecoration(),
          ),
          title: Row(
            children: <Widget>[
              FlutterLogo(
                colors: Colors.yellow,
                textColor: Colors.white,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(UIData.appName)
            ],
          ),
        ),
      );

  //bodygrid
  Widget bodyGrid(List<Menu> menu) => SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(_context).orientation == Orientation.portrait
                  ? 2
                  : 3,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return menuStack(context, menu[index]);
        }, childCount: menu.length),
      );

  Widget homeScaffold(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: Scaffold(key: _scaffoldState, body: bodySliverList()),
      );

  Widget bodySliverList() {
    MenuBloc menuBloc = MenuBloc();
    return StreamBuilder<List<Menu>>(
        stream: menuBloc.menuItemsGuide,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? CustomScrollView(
                  slivers: <Widget>[
                    appBar(),
                    bodyGrid(snapshot.data),
                  ],
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    deviceSize = MediaQuery.of(context).size;
    return homeScaffold(context);
  }
}
