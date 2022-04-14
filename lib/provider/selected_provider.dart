import 'package:flutter/cupertino.dart';

class SelectedProvider with ChangeNotifier {
  List<dynamic> order = [];
  saveSelectedId({required List<dynamic> orderdata}) {
    print("orderdata");
    order.add(orderdata);
    print(order);
    notifyListeners();
  }

  deleteSelectedId({required String name}) {
    for (int i = 0; i < order.length; i++) {
      if (order[i][0]['Name'] == name) {
        order.removeAt(i);
        return true;
      }
    }
    notifyListeners();
  }

  clear() {
    order.clear();
    notifyListeners();
  }
}
