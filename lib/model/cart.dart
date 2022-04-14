class Cart {
  String? image;
  String? name;
  int? price;
  int? quantity;

  Cart({this.image, this.name, this.price, this.quantity});

  Cart.fromJson(Map<String, dynamic> json) {
    image = json['Image'];
    name = json['Name'];
    price = json['Price'];
    quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Image'] = this.image;
    data['Name'] = this.name;
    data['Price'] = this.price;
    data['Quantity'] = this.quantity;
    return data;
  }
}