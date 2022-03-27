class ChatModel {
  String name;
  String? icon;
  String imgUrl;
  String anotherUserId;
  bool? isGroup;
  String? time;
  String? currentMessage;
  String status;
  bool? select = false;
  DateTime? startIn;
  String? userOne;
  String id;
  ChatModel({
    required this.name,
    required this.status,
    required this.id,
    required this.imgUrl,
    required this.anotherUserId,
    this.icon,
    this.isGroup,
    this.time,
    this.currentMessage,
    this.select = false,
    this.startIn,
    this.userOne,
  });
}
