class SocialMessageModel {
  String? senderId;
  String? receiverId;
  String? text;
  String? datetime;

  SocialMessageModel({
    this.senderId,
    this.receiverId,
    this.text,
    this.datetime,
  });

  SocialMessageModel.fromJson(Map<String , dynamic> json){
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    text = json['text'];
    text = json['text'];
    datetime = json['datetime'];
  }

  Map<String , dynamic> toMap(){
    return {
      'senderId':senderId,
      'receiverId':receiverId,
      'text':text,
      'datetime':datetime,
    };
  }
}