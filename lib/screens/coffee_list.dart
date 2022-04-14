import 'package:coffee_ordering_app/screens/add_coffee.dart';
import 'package:coffee_ordering_app/screens/detail.dart';
import 'package:coffee_ordering_app/screens/history.dart';
import 'package:coffee_ordering_app/screens/login.dart';
import 'package:coffee_ordering_app/screens/place_order.dart';
import 'package:coffee_ordering_app/utils/textstyle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../provider/login_provider.dart';
import '../provider/selected_provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool add = false;
  final qty = TextEditingController();
  final Stream<QuerySnapshot> listStream =
      FirebaseFirestore.instance.collection('coffeelist').snapshots();

  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  int itemcount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('cart')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        itemcount = querySnapshot.docs.length;
      });
    });
  }

  call() {
    FirebaseFirestore.instance
        .collection('cart')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        itemcount = querySnapshot.docs.length;
      });
    });
  }

  logout() {
    Get.dialog(
      AlertDialog(
        title: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('No')),
          TextButton(
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  Provider.of<LoginProvider>(context, listen: false)
                      .clearLogin();
                });
                Get.to(LoginScreen());
              },
              child: Text('Yes')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    call();
    return StreamBuilder<QuerySnapshot>(
        stream: listStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something went wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List storedocs = [];
          Map<String, dynamic> dt;
          snapshot.data!.docs.map((DocumentSnapshot doc) {
            dt = doc.data() as Map<String, dynamic>;
            storedocs.add(dt);
          }).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text("Detail"),
              automaticallyImplyLeading: false,
              actions: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(PlaceOrderScreen()),
                      child: Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 150, child: Icon(Icons.shopping_cart)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 0, 8),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircleAvatar(
                                child: Text(
                                    "${Provider.of<SelectedProvider>(context, listen: false).order.length}"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == "History") {
                          Get.to(HistoryScreen());
                        } else if (value == "logout") {
                          logout();
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          child: Text('Order History'),
                          value: "History",
                        ),
                        const PopupMenuItem(
                          child: Text('Logout'),
                          value: "logout",
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            body: GridView.count(
              crossAxisCount: 2,
              children: List.generate(storedocs.length, (index) {
                return GestureDetector(
                  onTap: () => Get.to(DetailScreen(
                    data: index,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: 1200,
                              height: 120,
                              child: Image.network(
                                storedocs[index]['Image'].toString(),
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset('assets/images/logo.png');
                                },
                              )),
                          Text(
                            storedocs[index]['Name'].toString(),
                            style: heading_main_black,
                          ),
                          Text(
                            "\$\'${storedocs[index]['Price'].toString()}",
                            style: sub_heading_main_black,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.to(() => AddScreen()),
              child: Center(child: Icon(Icons.add)),
              backgroundColor: Color(0xFF0C4BA2),
            ),
          );
        });
  }
}
