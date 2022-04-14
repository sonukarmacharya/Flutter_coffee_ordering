import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_ordering_app/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../model/cart.dart';
import '../provider/selected_provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  bool add = false;
  final qty = TextEditingController();
  final Stream<QuerySnapshot> listStream =
      FirebaseFirestore.instance.collection('cart').snapshots();

  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  CollectionReference clist =
      FirebaseFirestore.instance.collection('coffeelist');
  int itemcount = 0;
  List<dynamic> storedocs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storedocs.add(Provider.of<SelectedProvider>(context, listen: false).order);
  }

  delete() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Order"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: storedocs[0].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 238, 236, 236)),
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 150,
                                height: 100,
                                child: Image.network(storedocs[0][index][0]
                                        ['Image']
                                    .toString())),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        storedocs[0][index][0]['Name']
                                            .toString(),
                                        style: heading_main_black,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "\$ ${storedocs[0][index][0]['Price'].toString()}",
                                        style: sub_heading_main_black,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Quantity: ${storedocs[0][index][0]['Quantity'].toString()}",
                                            style: sub_heading_main_black,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              Get.dialog(
                                                AlertDialog(
                                                  title: const Text(
                                                      'Are you sure you want to delete?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Get.back(),
                                                        child: const Text('No')),
                                                    TextButton(
                                                        onPressed: () {
                                                          bool delete = Provider.of<
                                                                      SelectedProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .deleteSelectedId(
                                                                  name: storedocs[0][index]
                                                                              [
                                                                              0]
                                                                          [
                                                                          'Name']
                                                                      .toString());
                                                          if (delete) {
                                                            Get.back();
                                                            Get.back();
                                                            Get.snackbar(
                                                                "Success",
                                                                "Deleted",
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                colorText:
                                                                    Colors
                                                                        .white);

                                                            setState(() {});
                                                          }
                                                        },
                                                        child: const Text('Yes')),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  for (int i = 0; i < storedocs[0].length; i++) {
                
                    cart.add({
                      'Image': storedocs[0][i][0]["Image"],
                      'Name': storedocs[0][i][0]["Name"],
                      'Price': storedocs[0][i][0]["Price"],
                      'Quantity': storedocs[0][i][0]["Quantity"]
                    }).then((value) => Get.snackbar("Success", "Order Placed",
                        backgroundColor: Colors.green,
                        colorText: Colors.white));
                    Provider.of<SelectedProvider>(context, listen: false)
                        .clear();
                    setState(() {});
                  }
                  
                },
              
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Place an order",
                  ),
                ))
          ],
        ));
  }
}
