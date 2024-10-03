class SocialUserModel {
  String? name;
  String? email;
  String? phone;
  String? image;
  String? cover;
  String? bio;
  String? uId;
  bool? isEmailVerified;

  SocialUserModel({
    this.email,
    this.name,
    this.phone,
    this.image,
    this.cover,
    this.bio,
    this.uId,
    this.isEmailVerified,
});

  SocialUserModel.fromJson(Map<String , dynamic> json){
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String , dynamic> toMap(){
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'image':image,
      'cover':cover,
      'bio':bio,
      'uId':uId,
      'isEmailVerified':isEmailVerified,
    };
  }
}