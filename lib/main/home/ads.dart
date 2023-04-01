import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lebask/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../others/provider1.dart';

// ignore: camel_case_types
class ads extends StatefulWidget {
  final bool close;
  const ads({Key? key, required this.close}) : super(key: key);

  @override
  State<ads> createState() => _adsState();
}

// ignore: camel_case_types
class _adsState extends State<ads> {
  List pictures = [
    'https://firebasestorage.googleapis.com/v0/b/lebask0.appspot.com/o/ads%2Feduardo-pastor-3oejsU5OQVk-unsplash%20copy.jpg?alt=media&token=8fbf3253-66d8-496e-ab25-af8296a16c58',
    'https://firebasestorage.googleapis.com/v0/b/lebask0.appspot.com/o/ads%2Fanother.jpg?alt=media&token=a7f38eaa-8429-4348-a171-60e991cecc67'
  ];
  int index1 = 0;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Stack(
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: widget.close ? 0 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: widget.close ? 0 : Get.height / 6,
            child: CarouselSlider.builder(
                itemCount: pictures.length,
                itemBuilder: (context, index, realindex) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 130),
                    child: SlideAnimation(
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration:const Duration(milliseconds: 500),
                      child: FadeInAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration:const Duration(milliseconds: 2000),
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: (ClipRRect(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FadeInImage(
                                placeholder:
                                    const AssetImage('pictures/white3.jpg'),
                                fit: BoxFit.cover,
                                image: NetworkImage(pictures[index]),
                              ),
                            ),
                          )),
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: Get.height / 6,
                  autoPlayAnimationDuration: const Duration(milliseconds: 1100),
                  viewportFraction: .7,
                  onPageChanged: (index, reason) {
                    setState(() {
                      index1 = index;
                    });
                  },
                  autoPlay: true,
                  autoPlayCurve: Curves.easeInOutCirc,
                  autoPlayInterval: const Duration(seconds: 3),
                )),
          ),
        ),

        // widget.close
        //     ? Container()
        //     : Align(
        //         heightFactor: Get.height / 70,
        //         alignment: Alignment.bottomCenter,
        //         child: Container(
        //           margin: const EdgeInsets.only(top: 0),
        //           child: AnimatedSmoothIndicator(
        //             curve: Curves.fastLinearToSlowEaseIn,
        //             activeIndex: index1,
        //             count: pictures.length,
        //             effect: SwapEffect(
        //                 activeDotColor: provider.orange,
        //                 dotHeight: Get.height / 75,
        //                 dotWidth: Get.height / 75,
        //                 spacing: 14),
        //           ),
        //         ),
        //       ),
      ],
    );
  }
}
