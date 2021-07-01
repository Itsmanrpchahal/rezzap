class ChatMsg {
  final String messageType;
  final int id;
  final String message;

  ChatMsg({
    this.messageType,
    this.id,
    this.message,
  });

  factory ChatMsg.fromJson(Map<String, dynamic> json) {
    return ChatMsg(
      messageType: json['message_type'],
      id: json['id'],
      message: json['message'],
    );
  }
}
