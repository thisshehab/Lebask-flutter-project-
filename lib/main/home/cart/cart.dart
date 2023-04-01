import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lebask/main.dart';
import 'package:lebask/main/home/cart/cart_pages/confirm.dart';
import 'package:lebask/main/home/cart/cart_pages/get_location.dart';
import 'package:lebask/main/home/cart/cart_pages/products.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_change/status_change.dart';
import '../../../others/provider1.dart';
import 'finish_view.dart';
import 'helper/constance.dart';

// ignore: camel_case_types
class cart extends StatefulWidget {
  const cart({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HorizontalExampleState createState() => _HorizontalExampleState();
}

class _HorizontalExampleState extends State<cart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int _processIndex = 0;

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return Colors.orange;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        provider.darckblue,
        const Color.fromARGB(255, 14, 67, 126)
      ])),
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              leading: BackButton(color: Colors.white),
              centerTitle: true,
              backgroundColor: provider.darckblue,
              elevation: 0.0,
              title: Text(
                "السلة",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 170,
                  child: StatusChange.tileBuilder(
                    theme: StatusChangeThemeData(
                      direction: Axis.horizontal,
                      connectorTheme: const ConnectorThemeData(
                        space: 1.0,
                        thickness: 1.0,
                      ),
                    ),
                    builder: StatusChangeTileBuilder.connected(
                      itemWidth: (_) =>
                          MediaQuery.of(context).size.width / _processes.length,
                      contentWidgetBuilder: (context, index) {
                        return SizedBox(
                          height: 60,
                          child: Icon(
                            icons[index],
                            color: getColor(index),
                          ),
                        );
                      },
                      nameWidgetBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            _processes[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getColor(index),
                            ),
                          ),
                        );
                      },
                      indicatorWidgetBuilder: (_, index) {
                        if (index <= _processIndex) {
                          return DotIndicator(
                            size: Get.height / 23,
                            border:
                                Border.all(color: provider.orange, width: 1),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: provider.orange,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return OutlinedDotIndicator(
                            size: Get.height / 27,
                            borderWidth: 1.0,
                            color: todoColor,
                          );
                        }
                      },
                      lineWidgetBuilder: (index) {
                        if (index > 0) {
                          if (index == _processIndex) {
                            final prevColor = getColor(index - 1);
                            final color = getColor(index);
                            List<Color> gradientColors;
                            gradientColors = [
                              prevColor,
                              Color.lerp(prevColor, color, 0.5)!
                            ];
                            return DecoratedLineConnector(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                ),
                              ),
                            );
                          } else {
                            return SolidLineConnector(
                              color: getColor(index),
                            );
                          }
                        } else {
                          return null;
                        }
                      },
                      itemCount: _processes.length,
                    ),
                  ),
                ),
                pages[_processIndex]
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_processIndex < pages.length - 1) _processIndex++;
                  provider.getuserlocations();
                });
              },
              backgroundColor: Colors.amber,
              child: const Icon(Icons.skip_previous),
            ),
          ),
        ),
      ),
    );
  }
}

List<IconData> icons = [
  FontAwesomeIcons.cartShopping,
  FontAwesomeIcons.mapLocationDot,
  Icons.backup_sharp
];

List<Widget> pages = [
  const Products(),
  location(),
  const Confirm(),
  FinishView()
];
final _processes = [
  'سلة المشتريات',
  'الموقع',
  'تأكيد الطلب',
];
