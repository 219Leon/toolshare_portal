class Transaction {
  String? transactionId;
  String? toolId;
  String? toolName;
  String? userId;
  String? startDate;
  String? endDate;
  String? totalPrice;
  String? transactionDate;

  Transaction({
    required this.transactionId,
    required this.toolId,
    required this.toolName,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.transactionDate,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    toolId = json['tool_id'];
    userId = json['user_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalPrice = json['total_price'];
    transactionDate = json['transaction_date'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['tool_id'] = toolId;
    data['user_id'] = userId;
    return data;
  }
}
