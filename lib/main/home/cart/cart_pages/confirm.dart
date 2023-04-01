import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lebask/main/home/cart/cart_pages/products.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../../main.dart';
import '../../../../others/provider1.dart';
import '../../../other/item_details.dart';

class Confirm extends StatefulWidget {
  const Confirm({Key? key}) : super(key: key);


  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  int total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getthesillersdistnation();
  }

  settotal() {
    int total1 = 0;
    for (int i = 0; i < ItemDetails.userprice.length; i++) {
      total1 += int.parse(ItemDetails.userprice[i].toString()) *
          int.parse(ItemDetails.userquantity[i].toString());
    }
    total = total1;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: Get.height / 80,
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: ItemDetails.usercartitem.length + 1,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 850),
                  child: SlideAnimation(
                    verticalOffset: 14,
                    child: FadeInAnimation(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Table(
                            defaultColumnWidth: FixedColumnWidth(Get.width / 4),
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              index == 0
                                  ? const TableRow(children: [
                                      Text(
                                        "المنتج",
                                        style:
                                            TextStyle(height: 3, fontSize: 16),
                                      ),
                                      Text(
                                        "الكمية",
                                        style:
                                            TextStyle(height: 3, fontSize: 16),
                                      ),
                                      Text(
                                        "السعر",
                                        style:
                                            TextStyle(height: 3, fontSize: 16),
                                      ),
                                    ])
                                  : TableRow(children: [
                                      Text(ItemDetails.useritemname[index - 1]),
                                      Text((ItemDetails.userquantity[index - 1])
                                          .toString()),
                                      Text((ItemDetails.userprice[index - 1] *
                                              ItemDetails
                                                  .userquantity[index - 1])
                                          .toString())
                                    ])
                            ]),
                      ),
                    ),
                  ));
            },
          ),
        ),
        SizedBox(
          height: 17,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "المجموع: ${settotal()} ريال",
              style: TextStyle(
                  fontSize: Get.height / 55,
                  fontFamily: 'Roboto',
                  color: provider.black),
            ),
            Text(
              "سعر التوصيل: ${MyApp.dilivreyprice} ريال",
              style: TextStyle(
                  fontSize: Get.height / 55,
                  fontFamily: 'Roboto',
                  color: provider.black),
            ),
          ],
        ),
        const Divider(
          thickness: 1.2,
          height: 30,
        ),
        Text(
          "الإجمالي : ${settotal() + 1000} ريال",
          style: TextStyle(
              fontSize: Get.height / 55,
              fontFamily: 'Roboto',
              color: provider.black),
        ),
        SizedBox(
          height: Get.height / 4,
        )
      ],
    );
  }

  var sillerslist = [];
  var sillerslocations = [];
  var distnation = [];
  getthesillersdistnation() {
    delivryprice();
    print(sillerslist);
    sillerslocations.map((locations) {
      double theidstnation = 0;
      double x1 = double.parse(locations.split('-')[0]);
      double y1 = double.parse(locations.split('-')[1]);
      double x2;
      double y2;
      if (sillerslocations.length == 1) {
        Counterprovider provider = Provider.of<Counterprovider>(context);
        x2 = double.parse(
            provider.locaiton[provider.selectedindex ?? 0].split('-')[0]);
        y2 = double.parse(
            provider.locaiton[provider.selectedindex ?? 0].split('-')[1]);
        double dist = sqrt(((pow(x2 - x1, 2)) + (pow(y2 - y1, 2))));
        print("this is value:" + dist.toString());
      }
    });
  }

  delivryprice() {
    print("shehab");
    ItemDetails.usercartitem.map((docid) {
      FirebaseFirestore.instance
          .collection("products")
          .where("docid", isEqualTo: docid)
          .get()
          .then((value) {
        print("hi2");
        for (var element in value.docs) {
          if (!sillerslist.contains(element.data()['seller_number'])) {
            sillerslist.add(element.data()['seller_number']);
            print("sillerphone:" + element.data()['seller_number']);
          }
        }
      });

// usercartdoc
    });
    sillerslist.map((sillerphone) {
      FirebaseFirestore.instance
          .collection("sillers")
          .where("phone", isEqualTo: sillerphone)
          .get()
          .then((value) {
        sillerslocations.add(value.docs[0].data()['location']);
        print("sillerlocation:" + value.docs[0].data()['location']);
      });
    });
    finalpricedelivry();
  }

  finalpricedelivry() {}
}
