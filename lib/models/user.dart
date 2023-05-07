class User {
  String? id;
  String? username;
  String? email;
  String? phone;
  String? address;
  String? regdate;
  String? bankName;
  String? bankAccount;
  String? eWallet;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.phone,
      required this.address,
      required this.regdate,
      required this.bankName,
      required this.bankAccount,
      required this.eWallet
});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    regdate = json['regdate'];
    bankName = json['bankname'];
    bankAccount = json['bankaccount'];
    eWallet = json['ewallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['regdate'] = regdate;
    data['bankname'] = bankName;
    data['bankaccount'] = bankAccount;
    data['ewallet'] = eWallet;
    return data;
  }
}