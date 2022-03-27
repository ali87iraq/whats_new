class ChatRoomModel {
  bool isGroup;
  DateTime latestUse;
  String imgUrl;
  String roomId;
  String roomName;
  String userId;
  ChatRoomModel({
    required this.isGroup,
    required this.latestUse,
    required this.imgUrl,
    required this.roomId,
    required this.roomName,
    required this.userId,
  });
}
