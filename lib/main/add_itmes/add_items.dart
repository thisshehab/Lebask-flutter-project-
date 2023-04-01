import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../others/provider1.dart';

// ignore: camel_case_types
class add_items extends StatefulWidget {
  const add_items({Key? key}) : super(key: key);

  @override
  State<add_items> createState() => _add_itemsState();
}

var category = [" "];
var people = [" "];

// ignore: camel_case_types
class _add_itemsState extends State<add_items> {
  final multibalpicker = ImagePicker();
  List<XFile>? images = [];
  int quantity = 1;
  String? value2;
  File? file1;
  late File file2;
  File? file3;
  File? file4;
  var name = TextEditingController();
  var price = TextEditingController();
  var size = TextEditingController();
  var discription = TextEditingController();
  var brand = TextEditingController();

  var image = ImagePicker();

  String? imagename;
  bool loading = false;
  late int maxvalue;

//upload the data to firebase  >>>>>
  Future upload(BuildContext context) async {
    // if (true) {
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.warning,
    //     animType: AnimType.rightSlide,
    //     headerAnimationLoop: false,
    //     desc: 'عذرًا لا يُمكنك رفع منتجات في الوقت الحالي',
    //     btnOkOnPress: () {},
    //     btnOkIcon: Icons.cancel,
    //     btnOkColor: Colors.orange,
    //   ).show();
    //   return;
    // }

    await getthemaxvalue();
    List<String> urls = [];
    setState(() {
      loading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? sillername = (prefs.getString('sillername'));
    String? sillerphone = (prefs.getString('sillerphone'));

    CollectionReference userref =
        FirebaseFirestore.instance.collection("products");
    if (name.text != "" &&
        price.text != "" &&
        value != null &&
        value2 != null) {
      if (images!.isNotEmpty) {
        for (int i = 0; i < images!.length; i++) {
          imagename = basename(images![i].path);
          Reference refstore =
              FirebaseStorage.instance.ref('/requsts/$imagename');
          file2 = File(images![i].path);
          await refstore.putFile(file2);
          urls.add(await refstore.getDownloadURL());
        }
        userref.add({
          "accepted": "0",
          "name": name.text,
          "pictures": [...urls],
          "price": price.text,
          "siller": sillername ?? "لِباسك",
          "size": size.text.toUpperCase(),
          "people": value2,
          "type": value,
          "seller_number": sillername == null ? "772905140" : sillerphone,
          "quantity": quantity,
          "number": maxvalue,
          'brand': brand.text != '' ? brand.text : 'غير مُحدد',
          'discription': brand.text != '' ? brand.text : 'لا يوجد وصف...',
          'silled': 0
        }).then((value) => FirebaseFirestore.instance
            .doc(value.path)
            .update({"docid": value.id}));
      }
    } else {
      showToast(' على الأقل إملئ الثلاث الحقول الأولة مع إدراج صورة كحد أدنى  ',
          context: context,
          animation: StyledToastAnimation.slideFromBottomFade,
          reverseAnimation: StyledToastAnimation.slideFromBottomFade,
          position: const StyledToastPosition(
              align: Alignment.topCenter, offset: 100.0),
          startOffset: const Offset(0.0, -5),
          reverseEndOffset: const Offset(0.0, -5),
          duration: const Duration(seconds: 3),
          //Animation duration   animDuration * 2 <= duration
          animDuration: const Duration(milliseconds: 500),
          curve: Curves.easeOutSine,
          reverseCurve: Curves.fastOutSlowIn);
    }
    setState(() {
      loading = false;
    });
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Succes',
      desc: 'تم رفع المنتج',
      dismissOnTouchOutside: false,
      btnCancelOnPress: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return const add_items();
        })));
      },
      btnOkOnPress: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return const add_items();
        })));
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {},
    ).show();
  }

  Future multiplImages() async {
    final List<XFile>? selectedimages =
        await multibalpicker.pickMultiImage(imageQuality: 23);
    if (selectedimages!.isNotEmpty) {
      setState(() {
        images!.addAll(selectedimages);
      });
    }
  }

  uploadimagecamera() async {
    final XFile? photo = await image.pickImage(source: ImageSource.camera);
    if (photo != null) {
      file1 = File(photo.path);
    }
    // ignore: unnecessary_null_comparison
    setState(() {
      imagename = basename(photo!.path);
    });
  }

  @override
  void initState() {
    super.initState();
    getthemaxvalue();

    getdata();
  }

  getthemaxvalue() {
    FirebaseFirestore.instance
        .collection("products")
        .orderBy('number', descending: true)
        .limit(1)
        .get()
        .then((value) {
      maxvalue = value.docs[0].data()['number'] != null
          ? (int.parse(value.docs[0].data()['number'].toString()) + 1)
          : 1;
    });
  }

  var docid = [];
  void getdata() async {
    //setState(() {
    people.clear();
    docid.clear();
    category.clear();
    await FirebaseFirestore.instance.collection("people").get().then((value) {
      for (var element in value.docs) {
        setState(() {
          people.add(element.data()['name']);
          docid.add(element.data()['docid']);
        });
      }
    });
  }

  getthecategorys() {
    category.clear();
    FirebaseFirestore.instance
        .collection("people")
        .where("people", isEqualTo: value2)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("people")
          .doc(docid[people.indexOf(value2 ?? "")])
          .collection("category")
          .get()
          .then((value) {
        for (var element in value.docs) {
          setState(() {
            category.add(element.data()['name'].toString());
          });
        }
      });
    });
  }

  String? value;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: provider.blue,
          title: const Text("إضافة مُنتج",
              style:
                  TextStyle(wordSpacing: 3, fontSize: 21, color: Colors.white)),
        ),
        body: loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitCubeGrid(
                      color: provider.orange,
                      size: 100.0,
                      duration: const Duration(milliseconds: 1000),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    const Text(
                      "جارٍ الرفع...",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'pictures/third.png',
                      color: Color.fromARGB(255, 70, 103, 67).withOpacity(0.11),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ListView(children: [
                      const SizedBox(height: 14),
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          "ملاحظة :",
                          style: TextStyle(
                              fontSize: Get.height / 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: height / 10,
                        padding: EdgeInsets.only(right: width / 7, top: 20),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'سيتم رفع المُنتج بعد التحقق منه من قِبل مُدير البرنامج !',
                              textStyle: TextStyle(
                                fontSize: Get.height / 50,
                              ),
                              speed: const Duration(milliseconds: 120),
                            ),
                          ],
                          totalRepeatCount: 2,
                          pause: const Duration(milliseconds: 100),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                      ),
                      Form(
                          child: Padding(
                        padding: EdgeInsets.only(
                            top: 0, right: width / 11, left: width / 11),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            TextField(
                              controller: name,
                              decoration: const InputDecoration(
                                  label: Text(
                                "أسم المُنتج",
                                style: TextStyle(fontSize: 17),
                              )),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            TextField(
                              controller: price,
                              textDirection: TextDirection.rtl,
                              decoration: const InputDecoration(
                                label: Text(
                                  "سعر المُنتج",
                                  style: TextStyle(fontSize: 17),
                                ),
                                labelStyle: TextStyle(height: 0.5),
                              ),
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                fontSize: 17,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            TextField(
                              controller: size,
                              textDirection: TextDirection.rtl,
                              decoration: const InputDecoration(
                                label: Text(
                                  "المقاسات المتوفرة",
                                  style: TextStyle(fontSize: 17),
                                ),
                                hintText: '20 - 30 أو XL - XXL - S',
                                labelStyle: TextStyle(height: 0.5),
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 17,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            TextField(
                              controller: brand,
                              textDirection: TextDirection.rtl,
                              decoration: const InputDecoration(
                                label: Text(
                                  "الماركة",
                                  style: TextStyle(fontSize: 17),
                                ),
                                hintText: 'زاد',
                                labelStyle: TextStyle(height: 0.5),
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 17,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            TextField(
                              controller: discription,
                              textDirection: TextDirection.rtl,
                              decoration: const InputDecoration(
                                label: Text(
                                  "الوصف",
                                  style: TextStyle(fontSize: 17),
                                ),
                                hintText: 'لا يزيد عن 50 حرف',
                                labelStyle: TextStyle(height: 0.5),
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 17,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            Row(
                              children: [
                                Text(
                                  'فئة المُنتج :',
                                  style: TextStyle(fontSize: Get.height / 50),
                                ),
                                SizedBox(
                                  width: width / 15,
                                ),
                                DropdownButton<String>(
                                    value: value2,
                                    items: people.map(buildmenuitem).toList(),
                                    onChanged: (Value) => setState(() {
                                          value2 = Value;
                                          getthecategorys();
                                        })),
                              ],
                            ),
                            SizedBox(
                              height: height / 100,
                            ),
                            Row(
                              children: [
                                Text(
                                  'صنف المُنتج :',
                                  style: TextStyle(fontSize: Get.height / 50),
                                ),
                                SizedBox(
                                  width: width / 30,
                                ),
                                DropdownButton<String>(
                                    value: value,
                                    items: category.map(buildmenuitem).toList(),
                                    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                                    onChanged: (Value) => setState(() {
                                          value = Value;
                                        })),
                              ],
                            ),
                            SizedBox(
                              height: height / 100,
                            ),
                            Row(
                              children: [
                                Text(
                                  'الكمية :',
                                  style: TextStyle(fontSize: Get.height / 50),
                                ),
                                SizedBox(
                                  width: width / 30,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: Get.width / 37),
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              quantity =
                                                  quantity > 1 ? --quantity : 1;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            size: 23,
                                          ),
                                        ),
                                        Text(
                                          "$quantity",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Tajawal",
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                quantity++;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 23,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (_) {
                                            return SizedBox(
                                              height: height / 4,
                                              child: SizedBox(
                                                height: height / 10,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        await uploadimagecamera();
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.camera_alt,
                                                            size: width / 5,
                                                            color:
                                                                provider.orange,
                                                          ),
                                                          const SizedBox(
                                                            height: 7,
                                                          ),
                                                          const Text(
                                                            'الكاميرا',
                                                            style: TextStyle(
                                                                fontSize: 19),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        await multiplImages();
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .photoFilm,
                                                            size: width / 5,
                                                            color:
                                                                provider.orange,
                                                          ),
                                                          const SizedBox(
                                                            height: 7,
                                                          ),
                                                          const Text(
                                                            'الاستديو',
                                                            style: TextStyle(
                                                                fontSize: 19),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Text(
                                      "إرفاق صور",
                                      style:
                                          TextStyle(fontSize: Get.height / 50),
                                    ),
                                  ),
                                  images!.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              images!.removeAt(index1);
                                              if (index1 >= 1) index1 -= 1;
                                            });
                                          },
                                          icon: const Icon(
                                            FontAwesomeIcons.trash,
                                            color: Colors.red,
                                            size: 27,
                                          ))
                                      : Container()
                                ],
                              ),
                            ),
                            images!.isNotEmpty ? thepictures() : Container(),
                            images!.isNotEmpty
                                ? Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 25),
                                      child: AnimatedSmoothIndicator(
                                        activeIndex: index1,
                                        count:
                                            images != null ? images!.length : 0,
                                        effect: SwapEffect(
                                            dotHeight: 13,
                                            dotWidth: 13,
                                            activeDotColor: provider.blue,
                                            spacing: 14),
                                      ),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                                alignment: Alignment.topCenter,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await upload(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 2,
                                          bottom: 2,
                                          right: 20,
                                          left: 20),
                                      child: const Text(
                                        "رفع",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ))),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ))
                    ]),
                  ),
                ],
              ),
      ),
    );
  }

  int index1 = 0;
  thepictures() {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: images != null ? images!.length : 0,
          itemBuilder: (context, index, realindex) {
            return Image.file(
              File(images![index].path),
              fit: BoxFit.fill,
            );
          },
          options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            height: Get.height / 3,
            viewportFraction: 3,
            onPageChanged: (index, reason) {
              setState(() {
                index1 = index;
              });
            },
            autoPlay: false,
            autoPlayCurve: Curves.easeInOutCirc,
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildmenuitem(String item) {
    return DropdownMenuItem(
      alignment: AlignmentDirectional.centerEnd,
      value: item,
      child: FittedBox(
        child: Text(
          item,
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: Get.height / 60),
        ),
      ),
    );
  }
}
