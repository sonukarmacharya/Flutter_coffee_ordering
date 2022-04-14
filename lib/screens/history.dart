import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_ordering_app/utils/textstyle.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> storedocs = [];
  final Stream<QuerySnapshot> listStream =
      FirebaseFirestore.instance.collection('cart').snapshots();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('cart')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        storedocs.add(querySnapshot);
      });
    });
    print(storedocs);
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
              title: const Text("Order History"),
            ),
            body: ListView.builder(
                itemCount: storedocs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 238, 236, 236)),
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 150,
                              height: 100,
                              child: Image.network(
                                  storedocs[index]['Image'].toString())),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  storedocs[index]['Name'].toString(),
                                  style: heading_main_black,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "\$ ${storedocs[index]['Price'].toString()}",
                                  style: sub_heading_main_black,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Quantity: ${storedocs[index]['Quantity'].toString()}",
                                  style: sub_heading_main_black,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
