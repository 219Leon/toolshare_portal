class Tool{
  String? toolId;
  String? userId;
  String? toolName;
  String? toolDesc;
  String? toolRentPrice;
  String? toolDelivery;
  String? toolQty;
  String? toolState;
  String? toolLocal;
  String? toolLat;
  String? toolLng;
  String? toolDate;

  Tool(
    {required this.toolId,
    required this.userId,
    required this.toolName,
    required this.toolQty,    
    required this.toolRentPrice,
    required this.toolDelivery,
    required this.toolDesc,
    required this.toolDate,
    required this.toolState,
    required this.toolLocal,
    required this.toolLat,
    required this.toolLng});

  Tool.fromJson(Map<String, dynamic> json) {
    toolId = json['tool_id'];
    userId = json['user_id'];
    toolName = json['tool_name'];
    toolDesc = json['tool_desc'];
    toolRentPrice = json['tool_rent_price'];
    toolDelivery = json['tool_delivery'];
    toolQty = json['tool_qty'];
    toolState = json['tool_state'];
    toolLocal = json['tool_local'];
    toolLat = json['tool_lat'];
    toolLng = json['tool_lng'];
    toolDate = json['tool_date'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tool_id'] = toolId;
    data['user_id'] = userId;
    data['tool_name'] = toolName;
    data['tool_desc'] = toolDesc;
    data['tool_rent_price'] = toolRentPrice;
    data['tool_delivery'] = toolDelivery;
    data['tool_qty'] = toolQty;
    data['tool_state'] = toolState;
    data['tool_local'] = toolLocal;
    data['tool_lat'] = toolLat;
    data['tool_lng'] = toolLng;
    data['tool_date'] = toolDate;
    return data;
  }

}