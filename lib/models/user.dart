class User {
  String? id;
  String? name;
  String? username;
  String? email;
  String? phone;
  String? address;
  String? regdate;
  String? bank;
  String? bankNo;
  String? ewallet;
  String? ewalletNo;

  User(
      {required this.id,
      required this.username,
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.regdate,
      required this.bank,
      required this.bankNo,
      required this.ewallet,
      required this.ewalletNo});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    regdate = json['regdate'];
    bank = json['bank'];
    bankNo = json['bankNo'];
    ewallet = json['ewallet'];
    ewalletNo = json['ewalletNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['regdate'] = regdate;
    data['bank'] = bank;
    data['bankNo'] = bankNo;
    data['ewallet'] = ewallet;
    data['ewalletNo'] = ewalletNo;
    return data;
  }
}