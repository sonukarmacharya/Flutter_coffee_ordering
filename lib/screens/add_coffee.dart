import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/textstyle.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  CollectionReference coffeeadd =
      FirebaseFirestore.instance.collection('coffeelist');
  final _imagecontroller = TextEditingController();
  final _namecontroller = TextEditingController();
  final _pricecontroller = TextEditingController();
  final _qtycontroller = TextEditingController();

  List clist = [];
  _submit() {
    FirebaseFirestore.instance
        .collection('coffeelist')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["Name"] == _namecontroller.text) {
          Get.snackbar("Error", "Name already exist",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      });
    });

    if (_imagecontroller.text.isNotEmpty &&
        _namecontroller.text.isNotEmpty &&
        _pricecontroller.text.isNotEmpty &&
        _qtycontroller.text.isNotEmpty) {
     
        coffeeadd.add({
          'Image': _imagecontroller.text,
          'Name': _namecontroller.text,
          'Price': _pricecontroller.text,
          'Quantity': _qtycontroller.text
        }).then((value) => Get.back());
     
    } else {
      Get.snackbar("Error", "All fields are required",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Add Coffee",
      )),
      body: Container(
        padding: const EdgeInsets.all(25),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              "Add Coffee",
              style: heading_main_black,
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _imagecontroller,
              decoration: const InputDecoration(
                  labelText: 'Enter url of image',
                  prefixIcon: Icon(Icons.image)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _namecontroller,
              decoration: const InputDecoration(
                  labelText: 'Name', prefixIcon: Icon(Icons.text_fields)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _pricecontroller,
              decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.price_change_outlined)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _qtycontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Quantiry', prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                child: const Text(
                  "Submit",
                ),
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
