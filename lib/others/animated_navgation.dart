import 'package:flutter/cupertino.dart';

// ignore: camel_case_types
class pageroute extends PageRouteBuilder {
  final Widget? widget;
  pageroute({this.widget})
      : super(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation, _, Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.fastOutSlowIn);
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (_, __, ___) {
              return widget!;
            });
}
