class Tool{
  String? toolID;
  String? userID;
  String? toolName;
  String? toolCategory;
  String? toolRentPrice;
  String? toolDescription;
  String? toolDate;
  String? toolState;
  String? toolLat;

  Tool(
    {required this.toolID,
    required this.userID,
    required this.toolName,
    required this.toolCategory,    
    required this.toolRentPrice,
    required this.toolDescription,
    required this.toolDate,
    required this.toolState,
    required this.toolLat});

  Tool.fromJson(Map<String, dynamic> json) {
    toolID = json['toolID'];
    userID = json['userID'];
    toolName = json['toolName'];
    toolCategory = json['toolCategory'];
    toolRentPrice = json['toolRentPrice'];
    toolDescription = json['toolDescription'];  
    toolDate = json['toolDate']; 
    toolState = json['toolState']; 
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tool_id'] = toolID;
    data['user_id'] = userID;
    data['tool_name'] = toolName;
    data['tool_category'] = toolCategory;
    data['tool_rent_price'] = toolRentPrice;
    data['tool_description'] = toolDescription;
    data['tool_date'] = toolDate;
    data['tool_state'] = toolState;
    return data;
  }

}