class SocialPostModel {
  String? name;
  String? profileImage;
  String? postImage;
  String? uId;
  String? text;
  String? datetime;

  SocialPostModel({
    this.name,
    this.profileImage,
    this.postImage,
    this.text,
    this.uId,
    this.datetime,
  });

  SocialPostModel.fromJson(Map<String , dynamic> json){
    name = json['name'];
    profileImage = json['profileImage'];
    postImage = json['postImage'];
    text = json['text'];
    datetime = json['datetime'];
    uId = json['uId'];
  }

  Map<String , dynamic> toMap(){
    return {
      'name':name,
      'profileImage':profileImage,
      'postImage':postImage,
      'text':text,
      'datetime':datetime,
      'uId':uId,
    };
  }
}