import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class deleteitem extends StatelessWidget {
  final docid;
  const deleteitem({Key? key, required this.docid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 8),
      child: IconButton(
          onPressed: () {
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
              desc: 'إزالة المُنتج  !',
              showCloseIcon: true,
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                FirebaseFirestore.instance
                    .collection("products")
                    .doc(docid)
                    .delete();
              },
            ).show();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
            size: Get.width / 15,
          )),
    );
  }
}
