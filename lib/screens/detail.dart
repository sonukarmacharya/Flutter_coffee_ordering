import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_ordering_app/provider/selected_provider.dart';
import 'package:coffee_ordering_app/utils/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  int data;
  DetailScreen({required this.data});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final Stream<QuerySnapshot> listStream =
      FirebaseFirestore.instance.collection('coffeelist').snapshots();

  CollectionReference coffeelist =
      FirebaseFirestore.instance.collection('coffeelist');
  int itemcount = 0;
  int count = 0;
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

  @override
  Widget build(BuildContext context) {
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
              ),
              body: Container(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 238, 236, 236)),
                // width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 170,
                        height: 240,
                        padding: EdgeInsets.all(15),
                        child: Image.network(
                          storedocs[widget.data]['Image'].toString(),
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset('assets/images/logo.png');
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 25, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 150,
                              child: Text(
                                storedocs[widget.data]['Name'].toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: heading_main_black,
                              )),
                          Text(
                            "Quantity : ${storedocs[widget.data]['Quantity'].toString()}",
                            style: sub_heading_main_black,
                          ),
                          Text(
                            "\$${storedocs[widget.data]['Price'].toString()}",
                            style: sub_heading_main_black,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      count -= 1;
                                    });
                                  },
                                  child: Text("-")),
                              Text("$count"),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      count += 1;
                                    });
                                  },
                                  child: Text("+")),
                              IconButton(
                                  onPressed: () {
                                    if (count >
                                        int.parse(storedocs[widget.data]
                                            ['Quantity'])) {
                                      Get.snackbar("Error", "Out of stock",
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white);
                                    } else if (count <= 0) {
                                      Get.snackbar("Error", "Add item quantity",
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white);
                                    } else {
                                      int price = int.parse(
                                              storedocs[widget.data]['Price']) *
                                          count;
                                      int q = int.parse(storedocs[widget.data]
                                              ['Quantity']) -
                                          count;

                                      Provider.of<SelectedProvider>(context,
                                              listen: false)
                                          .saveSelectedId(orderdata: [
                                        {
                                          'Image': storedocs[widget.data]
                                              ['Image'],
                                          'Name': storedocs[widget.data]
                                              ['Name'],
                                          'Price': price,
                                          'Quantity': count
                                        }
                                      ]);

                                      Get.snackbar("Success",
                                          "${storedocs[widget.data]['Name'].toString()} added to cart",
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white);
                                    }
                                  },
                                  icon: Icon(Icons.add_box_outlined)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}
