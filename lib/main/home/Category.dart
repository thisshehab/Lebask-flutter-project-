// ignore: file_names
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lebask/main/home/Home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../others/provider1.dart';
import 'categorysgoods/categorygoods.dart';

// ignore: camel_case_types
class mycategory extends StatefulWidget {
  var categoryname;
  mycategory({Key? key, required this.categoryname}) : super(key: key);

  @override
  State<mycategory> createState() => _mycategoryState();
}

class _mycategoryState extends State<mycategory> {
  @override
  void initState() {
    super.initState();
  }

  void getdata() {}

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return provider.pictures.isNotEmpty
        ? AnimatedContainer(
            duration: const Duration(seconds: 1),
            child: Directionality(
                textDirection: TextDirection.ltr, child: categorybuilder2()))
        : shimmer();
  }

  int curnnetindex = 0;
  shimmer() {
    return CarouselSlider.builder(
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1100),
        viewportFraction: 0.7,
        onPageChanged: (index, reason) {
          curnnetindex = index;
          setState(() {});
        },
        autoPlay: true,
        autoPlayCurve: Curves.easeInOutCirc,
        autoPlayInterval: const Duration(seconds: 7),
      ),
      itemCount: 3,
      itemBuilder: ((context, index, realindex) {
        return Shimmer(
          period: const Duration(milliseconds: 700),
          gradient: const LinearGradient(
              colors: [Color.fromARGB(0, 125, 125, 125), Colors.white]),
          loop: 100,
          child: Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(7)),
            height: Get.height / 4,
            width: Get.width / 1.2,
          ),
        );
      }),
    );
  }

  CarouselSlider categorybuilder2() {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return CarouselSlider.builder(
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1100),
        viewportFraction: 0.7,
        onPageChanged: (index, reason) {
          provider.setdotindex(index);
        },
        autoPlay: true,
        autoPlayCurve: Curves.easeInOutCirc,
        autoPlayInterval: const Duration(seconds: 7),
      ),
      itemCount: provider.pictures.length,
      itemBuilder: ((context, index, realindex) {
        Counterprovider provider = Provider.of<Counterprovider>(context);

        return Hero(
          tag: 'picture $index',
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                    child: categorygoods(
                        name: provider.name[index],
                        picture: provider.pictures[index],
                        index: index),
                    type: PageTransitionType.fade,
                    duration: const Duration(milliseconds: 280),
                    reverseDuration: const Duration(milliseconds: 280),
                  ));
            },
            child: AnimationConfiguration.staggeredList(
              position: index,
              delay: const Duration(milliseconds: 300),
              child: SlideAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: Duration(milliseconds: 500),
                child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(milliseconds: 2000),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Container(
                          width: Get.width,
                          child: LayoutBuilder(
                            builder: (_, constraints) => FadeInImage(
                              placeholder:
                                  const AssetImage('pictures/white3.jpg'),
                              fit: BoxFit.fill,
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              image: NetworkImage(provider.pictures[index]),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(144, 0, 0, 0),
                                  Colors.transparent
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 8, right: Get.width / 20),
                            child: Text(
                              provider.name[index].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: Get.height / 37,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  CarouselSlider categorybuilder1() {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlayAnimationDuration: const Duration(milliseconds: 1100),
        viewportFraction: 0.7,
        onPageChanged: (index, reason) {},
        autoPlay: true,
        autoPlayCurve: Curves.easeInOutCirc,
        autoPlayInterval: const Duration(seconds: 7),
      ),
      itemCount: provider.pictures.length,
      itemBuilder: ((context, index, realindex) {
        return Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: categorygoods(
                        name: provider.name[index],
                        picture: provider.pictures[index],
                        index: index),
                    type: PageTransitionType.fade,
                    duration: const Duration(milliseconds: 280),
                    reverseDuration: const Duration(milliseconds: 280),
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: LayoutBuilder(
                        builder: (_, constraints) => Hero(
                          tag: 'picture $index',
                          child: FadeInImage(
                            placeholder:
                                const AssetImage('pictures/third2.png'),
                            fit: BoxFit.fill,
                            width: constraints.maxHeight,
                            image: NetworkImage(provider.pictures[index]),
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(top: 2),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color.fromARGB(255, 0, 0, 0)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      width: 220,
                      height: 50,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            provider.name[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Get.height / 50,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      }),
    );
  }
}
