import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lebask/main/other/navbar.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../others/provider1.dart';

class likebutton extends StatefulWidget {
  final docid;
  static List<String?> userfa = [];
  static List<String?> userfadoc = [];
  likebutton({Key? key, required this.docid}) : super(key: key);

  @override
  State<likebutton> createState() => _likebuttonState();
}

class _likebuttonState extends State<likebutton> {
  @override
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return LikeButton(
      isLiked: likebutton.userfa.contains(widget.docid),
      onTap: (bool isLiked) async {
        final prefs = await SharedPreferences.getInstance();

        var userdoc = nav2.userdoc ?? prefs.getString('userid');
        if (userdoc == null) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            headerAnimationLoop: false,
            desc: " !قُم بتسجيل الدخول ",
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.orange,
          ).show();
          return isLiked;
        }

        if (isLiked == false) {
          if (!likebutton.userfa.contains(widget.docid)) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(userdoc)
                .collection('fav')
                .add({'itemid': widget.docid}).then((value) {
              FirebaseFirestore.instance
                  .doc(value.path)
                  .update({"docid": value.id});
              setState(() {
                likebutton.userfa.add(widget.docid);
                likebutton.userfadoc.add(value.id);
              });
            });

            AwesomeDialog(
              context: context,
              animType: AnimType.leftSlide,
              headerAnimationLoop: false,
              dialogType: DialogType.success,
              showCloseIcon: true,
              title: 'Succes',
              desc: 'تمت الإضافة للمفضلة',
              btnOkOnPress: () {},
              btnOkIcon: Icons.check_circle,
              onDismissCallback: (type) {},
            ).show();

            prefs.setInt('favnumber', provider.favnumber);
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              headerAnimationLoop: false,
              title: 'Error',
              desc: 'المُنتج في قائمة المفضلة',
              btnOkOnPress: () {},
              btnOkIcon: Icons.cancel,
              btnOkColor: Colors.red,
            ).show();
            return !isLiked;
          }
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            borderSide: const BorderSide(
              color: Colors.green,
              width: 2,
            ),
            width: Get.width,
            buttonsBorderRadius: const BorderRadius.all(
              Radius.circular(2),
            ),
            dismissOnTouchOutside: true,
            dismissOnBackKeyPress: false,
            onDismissCallback: (type) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('Dismissed by $type'),
              //   ),
              // );
            },
            headerAnimationLoop: false,
            animType: AnimType.bottomSlide,
            desc: 'هل تريد إزالة المُنتج من المفضلة؟',
            showCloseIcon: true,
            btnCancelOnPress: () {},
            btnOkOnPress: () async {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(userdoc)
                  .collection('fav')
                  .doc(likebutton
                      .userfadoc[likebutton.userfa.indexOf(widget.docid)])
                  .delete();
              setState(() {
                likebutton.userfadoc
                    .removeAt(likebutton.userfa.indexOf(widget.docid));
                likebutton.userfa.remove(widget.docid);
              });
              prefs.setInt(
                  'favnumber', provider.favnumber < 0 ? 0 : provider.favnumber);
            },
          ).show();
        }
      },
      mainAxisAlignment: MainAxisAlignment.start,
      size: Get.width / 13,
      circleColor: const CircleColor(
          start: Color.fromARGB(255, 144, 0, 255),
          end: Color.fromARGB(255, 0, 41, 204)),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Color.fromARGB(255, 15, 88, 40),
        dotSecondaryColor: Color(0xff0099cc),
      ),
      likeBuilder: likebuilder,
    );
  }

  getuserfav() async {
    final prefs = await SharedPreferences.getInstance();
    String userdoc = prefs.getString('userid')!;
    likebutton.userfa.clear();
    likebutton.userfadoc.clear();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('fav')
        .get()
        .then((value) {
      for (var element in value.docs) {
        likebutton.userfa.add(element.data()['itemid']);
        likebutton.userfadoc.add(element.data()['docid']);
      }
    });
  }

  Widget? likebuilder(bool isLiked) {
    return Icon(
      isLiked ? Icons.favorite : Icons.favorite_border,
      color: isLiked ? Colors.red : Colors.grey,
      size: Get.width / 13,
    );
  }
}
