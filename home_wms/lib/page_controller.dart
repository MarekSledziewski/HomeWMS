import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_wms/add/ui/add_screen.dart';
import 'package:home_wms/delete/ui/delete_screen.dart';
import 'package:home_wms/menu/ui/menu_screen.dart';
import 'package:home_wms/options/ui/options_screen.dart';

import 'list/ui/list_screen.dart';
import 'menu/bloc/menu_bloc.dart';

class PageViewController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PageViewControllerState();
}

class PageViewControllerState extends State<PageViewController> {
  late final PageController _controller1 = PageController(initialPage: 1, keepPage: true);
  late final PageController _controller2 = PageController(initialPage: 1, keepPage: true);

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  bool scrollingAllower = true;
  horizontalScroll() {
    if (scrollingAllower == false) {
      return NeverScrollableScrollPhysics();
    } else {
      return AlwaysScrollableScrollPhysics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return blocListener();
  }

  Widget buildPageView() => PageView(
          controller: _controller1,
          physics: horizontalScroll(),
          children: [
            DeleteScreen(),
            PageView(
                controller: _controller2,
                scrollDirection: Axis.vertical,
                onPageChanged: (value) {
                  setState(() {
                    if (value == 0 || value == 2) {
                      scrollingAllower = false;
                    } else {
                      scrollingAllower = true;
                    }
                  });
                },
                children: [
                  ListScreen(),
                  MenuScreen(),
                  OptionsScreen(),
                ]),
            AddScreen(),
          ]);

  Widget blocListener() => BlocListener<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuButtonActionNavigator) {
            switch (state.buttonName) {
              case "Add":
                {
                  return animateToAdd();
                }
              case "Delete":
                {
                  return animateToDelete();
                }
              case "List":
                {
                  return animateToList();
                }
                  case "Options":
                {
                  return animateToOptions();
                }
            }
          }
        },
        child: buildPageView(),
      );
  animateToAdd() => _controller1.animateToPage(2,
      duration: Duration(seconds: 1), curve: Curves.decelerate , );
  animateToDelete() => _controller1.animateToPage(0,
      duration: Duration(seconds: 1), curve: Curves.decelerate);
  animateToOptions() => _controller2.animateToPage(2,
      duration: Duration(seconds: 1), curve: Curves.decelerate);
  animateToList() => _controller2.animateToPage(0,
      duration: Duration(seconds: 1), curve: Curves.decelerate);
}
