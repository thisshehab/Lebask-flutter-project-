import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lebask/main/home/Category.dart';
import 'package:lebask/main/home/ads.dart';
import 'package:lebask/main/search/goods.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../others/provider1.dart';
import '../other/item_details.dart';
import '../other/likedbutton.dart';
import 'converter.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => homeState();
}

class homeState extends State<home> {
  int selectedpage = 0;
  String selectedcategory = "ولادي";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Counterprovider>(context, listen: false)
        .categorys("58PN1DHfKWw5WkfuZxzI", "ولادي");
    change();
    bool setthesttate = false;
    controller.addListener(() {
      if (controller.offset >= -100 && controller.offset < 400) {
        if (controller.offset > 1) {
          closeads = true;
        }
        closeTopContainer = controller.offset > 100;
        setState(() {});
      }
    });

    InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        activeConnection = status == InternetConnectionStatus.connected;

        if (activeConnection == false) {
          showToast('تأكد من إتصالك بالانترنت',
              context: context,
              animation: StyledToastAnimation.slideFromBottomFade,
              reverseAnimation: StyledToastAnimation.slideFromBottomFade,
              position: const StyledToastPosition(
                  align: Alignment.topCenter, offset: 20.0),
              startOffset: const Offset(0.0, -3.0),
              reverseEndOffset: const Offset(0.0, -3.0),
              duration: const Duration(seconds: 3),
              //Animation duration   animDuration * 2 <= duration
              animDuration: const Duration(milliseconds: 500),
              curve: Curves.easeOutSine,
              reverseCurve: Curves.fastOutSlowIn);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    Query<Welcome> userref = FirebaseFirestore.instance
        .collection("people")
        .withConverter<Welcome>(
            fromFirestore: (snapshot, _) =>
                (Welcome.fromJson(snapshot.data()!)),
            toFirestore: (user, _) => user.toJson());
    return FirestoreQueryBuilder(
        pageSize: 30,
        query: userref,
        builder: (context1, snapshot, _) {
          Counterprovider provider = Provider.of<Counterprovider>(context);

          return Column(
            children: [
              !closeads
                  ? SizedBox(
                      height: Get.height / 80,
                    )
                  : Container(),
              ads(
                close: closeads,
              ),
              SizedBox(
                height: Get.height / 120,
              ),
              SizedBox(
                height: Get.height / 11,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        AnimationConfiguration.staggeredList(
                            position: index,
                            delay: const Duration(milliseconds: 120),
                            duration: const Duration(milliseconds: 130),
                            child: SlideAnimation(
                                curve: Curves.fastLinearToSlowEaseIn,
                                duration:const Duration(milliseconds: 2500),
                                verticalOffset: 10,
                                child: FadeInAnimation(
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  duration: Duration(milliseconds: 2000),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 6,
                                        left: 4,
                                        right: index != 0 ? 0 : 7),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              selectedpage = index;
                                              selectedcategory =
                                                  snapshot.docs[index]['name'];
                                              provider.categorys(
                                                  snapshot.docs[index]['docid'],
                                                  snapshot.docs[index]['name']);
                                              print(snapshot.docs[index]
                                                  ['docid']);
                                              setState(() {
                                                change();
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                right: Get.height / 41,
                                                left: Get.height / 41,
                                                top: Get.height / 92,
                                                bottom: Get.height / 92,
                                              ),
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: selectedpage == index
                                                        ? provider.orange
                                                        : Colors.grey,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                snapshot.docs[index]['name'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        selectedpage == index
                                                            ? FontWeight.w600
                                                            : FontWeight.w500,
                                                    fontSize: Get.height / 56,
                                                    color: selectedpage != index
                                                        ? const Color.fromARGB(
                                                            221, 158, 158, 158)
                                                        : provider.orange),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))),
                      ],
                    );
                  },
                ),
              ),
              Expanded(child: thehome())
            ],
          );
        });
  }

  bool closeTopContainer = false;
  bool closeads = false;
  bool activeConnection = true;
  bool canclick = true;
  ScrollController controller = ScrollController();
  var number = 1;

  bool loading = true;
  change() {
    Future.delayed(const Duration(milliseconds: 1000), () {
// Here you can write your code

      setState(() {
        loading = false;
        // Here you can write your code for open new view
      });
    });
    loading = true;
  }

  shimmer() {
    return Container(
        margin: const EdgeInsets.only(bottom: 12, right: 10, left: 10),
        width: Get.width / 2,
        height: 320,
        child: Shimmer(
          period: const Duration(milliseconds: 1000),
          gradient: const LinearGradient(
              colors: [Color.fromARGB(0, 125, 125, 125), Colors.white]),
          loop: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
                height: 40,
                width: 40,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
                height: 150,
                width: Get.width,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
                height: 20,
                width: Get.width / 4,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
                height: 20,
                width: Get.width / 6,
              )
            ],
          ),
        ));
  }

  Widget thehome() {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        closeads = false;
        change();
      },
      child: Container(
        height: Get.height / 1.34,
        child: Column(
          children: [
            // ads(close: closeads, categoryname: widget.categoryname),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 5, right: 17),
                height: Get.height / 28,
                child: Text(
                  closeTopContainer ? 'الأحدث' : 'التصنيفات',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: Get.height / 50),
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              height: 2,
            ),
            const SizedBox(
              height: 14,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: closeTopContainer ? 0 : 1,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: closeTopContainer ? 0 : Get.height / 5,
                  //here will make the animations
                  width: Get.width,
                  child: mycategory(
                    categoryname: selectedcategory,
                  )),
            ),
            closeTopContainer
                ? Container()
                : Container(
                    margin: EdgeInsets.only(top: 10),
                    height: Get.height / 75,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: AnimatedSmoothIndicator(
                        curve: Curves.easeInOutQuint,
                        duration: Duration(milliseconds: 600),
                        activeIndex: provider.currentdotindex,
                        count: provider.name.length,
                        effect: WormEffect(
                            activeDotColor: provider.orange,
                            dotHeight: Get.height / 210,
                            dotWidth: Get.width / 27,
                            spacing: 22 - provider.name.length.toDouble()),
                      ),
                    ),
                  ),
            SizedBox(
              height: closeTopContainer ? 0 : 15,
            ),
            tryigjust(),
            Expanded(child: Goods("products", selectedcategory)),
          ],
        ),
      ),
    );
  }

  tryigjust() {
    Query<Welcome> userref1 = FirebaseFirestore.instance
        .collection("products")
        // .where("people", isEqualTo: selectedcategory2)
        .orderBy('number', descending: true)
        .withConverter<Welcome>(
            fromFirestore: (snapshot, _) =>
                (Welcome.fromJson(snapshot.data()!)),
            toFirestore: (user, _) => user.toJson());
    return FirestoreQueryBuilder(
        pageSize: 1000,
        query: userref1,
        builder: (context1, snapshot, _) {
          return Container();
        });

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  }

  // ignore: non_constant_identifier_names
  Goods(String type, selectedcategory2) {
    //this is just to make the rest of it work>>>>>>>>>>>>>
    Counterprovider provider = Provider.of<Counterprovider>(context);

    Query<Welcome> userref = FirebaseFirestore.instance
        .collection(type)
        .where("people", isEqualTo: selectedcategory2)
        .orderBy('number', descending: true)
        .withConverter<Welcome>(
            fromFirestore: (snapshot, _) =>
                (Welcome.fromJson(snapshot.data()!)),
            toFirestore: (user, _) => user.toJson());
    return FirestoreQueryBuilder(
        pageSize: 1000,
        query: userref,
        builder: (context1, snapshot, _) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent:
                    Get.width > 490 ? Get.width / 3 : Get.width / 2,
                mainAxisExtent: Get.height / 3.5,
                mainAxisSpacing: 30,
                crossAxisSpacing: Get.width / 66),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            controller: controller,
            itemCount: snapshot.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return loading
                  ? goodsState.shammer()
                  : AnimationConfiguration.staggeredList(
                      position: index,
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 130),
                      child: SlideAnimation(
                        verticalOffset: 22,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: Duration(milliseconds: 1800),
                        child: FadeInAnimation(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: Duration(milliseconds: 2000),
                          child: Container(
                            margin: EdgeInsets.only(
                              right: Get.width > 490
                                  ? Get.width / 60
                                  : Get.width / 22,
                              left: Get.width > 490
                                  ? Get.width / 60
                                  : Get.width / 22,
                            ),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: provider.colortheme,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: provider.containershadow),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: ItemDetails(
                                      mykey: '3',
                                      brand: snapshot.docs[index]['brand'],
                                      discription: snapshot.docs[index]
                                          ['discription'],
                                      sillername: snapshot.docs[index]
                                          ['siller'],
                                      name: snapshot.docs[index]['name'],
                                      price: snapshot.docs[index]['price'],
                                      size: snapshot.docs[index]['size'],
                                      type: snapshot.docs[index]['type'],
                                      quantity: snapshot.docs[index]
                                          ['quantity'],
                                      people: snapshot.docs[index]['people'],
                                      pictures: snapshot.docs[index]
                                          ['pictures'],
                                      docid: snapshot.docs[index]['docid'],
                                    ),
                                    type: PageTransitionType.fade,
                                    duration: const Duration(milliseconds: 280),
                                    reverseDuration:
                                        const Duration(milliseconds: 290),
                                  ),
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: the_items(
                                  docid: snapshot.docs[index]['docid'],
                                  name: snapshot.docs[index]['name'],
                                  sillername: snapshot.docs[index]['siller'],
                                  price: snapshot.docs[index]['price'],
                                  size: snapshot.docs[index]['size'],
                                  type: snapshot.docs[index]['type'],
                                  quantity: snapshot.docs[index]['quantity'],
                                  people: snapshot.docs[index]['people'],
                                  pictures: snapshot.docs[index]['pictures']),
                            ),
                          ),

                          // child: Column(
                          //   children: [
                          //     for (int i = 0;
                          //         i < snapshot.docs[index]['pictures'].length;
                          //         i++)
                          //       Text('${snapshot.docs[index]['pictures'][i]}')
                          //   ],
                          // ),
                        ),
                      ),
                    );
            },
          );
        });
  }

  // ignore: non_constant_identifier_names
  the_items(
      {name,
      price,
      size,
      type,
      quantity,
      people,
      pictures,
      sillername,
      docid}) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 5, top: 5),
                child: likebutton(
                  docid: docid,
                )),
            //  deleteitem(docid: docid,),
            Container(
              height: Get.height / 36,
              width: Get.width / 5,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'نفذت الكمية !',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Get.height / 70),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: Container(
            height: Get.height / 10,
            width: Get.width,
            child: Hero(
              tag: docid + "3",
              child: FadeInImage(
                placeholder: const AssetImage('pictures/third2.png'),
                fit: BoxFit.fitWidth,
                image: NetworkImage(pictures[0]),
              ),
            ),
          ),
        ),
        SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: FittedBox(
                  child: Text(
                    name,
                    style: TextStyle(
                        fontSize: Get.height / 60,
                        wordSpacing: 3,
                        color: provider.black,
                        // ignore: prefer_const_literals_to_create_immutables
                        shadows: [
                          const BoxShadow(
                            color: Color.fromARGB(27, 0, 0, 0),
                            offset: Offset(4, 4),
                            blurRadius: 7,
                            spreadRadius: 3.0,
                          )
                        ]),
                  ),
                ),
              ),
              Text(
                "$price ريال",
                style:
                    TextStyle(fontSize: Get.height / 66, color: provider.orange,
                        // ignore: prefer_const_literals_to_create_immutables
                        shadows: [
                      const BoxShadow(
                        color: Color.fromARGB(56, 0, 0, 0),
                        offset: Offset(4, 4),
                        blurRadius: 10,
                        spreadRadius: 3.0,
                      )
                    ]),
              ),
              Text(
                // ignore: prefer_interpolation_to_compose_strings
                "البائع: " + sillername,
                style: TextStyle(
                    fontSize: Get.height / 66,
                    color: provider.black.withOpacity(0.7),
                    // ignore: prefer_const_literals_to_create_immutables
                    shadows: [
                      const BoxShadow(
                        color: Color.fromARGB(56, 0, 0, 0),
                        offset: Offset(4, 4),
                        blurRadius: 10,
                        spreadRadius: 3.0,
                      )
                    ]),
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget? likebuilder(bool isLiked) {
    return Icon(
      isLiked ? Icons.favorite : Icons.favorite_border,
      color: isLiked ? Colors.red : Colors.grey,
      size: Get.width / 13,
    );
  }
}
