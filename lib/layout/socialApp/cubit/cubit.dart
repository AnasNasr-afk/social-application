

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t2/layout/socialApp/cubit/states.dart';
import 'package:t2/models/socialApp/socialMessageModel.dart';
import 'package:t2/models/socialApp/socialPostModel.dart';
import 'package:t2/models/socialApp/socialUserModel.dart';
import 'package:t2/modules/socialApp/accountScreen/accountScreen.dart';
import 'package:t2/modules/socialApp/chatScreen/chatScreen.dart';
import 'package:t2/modules/socialApp/homeScreen/commentDetails.dart';
import 'package:t2/modules/socialApp/homeScreen/homeScreen.dart';
import 'package:t2/modules/socialApp/newPost/newPostScreen.dart';
import 'package:t2/modules/socialApp/settingsScreen/settingsScreen.dart';
import 'package:t2/modules/socialApp/socialRegister/cubit/states.dart';
import 'package:t2/modules/socialApp/usersScreen/usersScreen.dart';
import 'package:t2/shared/components/constants.dart';

import '../../../../shared/network/remote/dioHelper.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);


  SocialUserModel? model;

  void getUserData() {
    emit(SocialLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().
    then((value) {
      model = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).
    catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  List <Widget> screens = [

    HomeScreen(),
    ChatScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
    // AccountScreen(),

  ];

  int currentIndex = 0;

  void changeBottomNav(int index) {
    if (index == 1)
      getUsers();
    if (index == 2)
      emit(NewPostState());
    else {
      currentIndex = index;
      emit(ChangeBottomNavState());
    }
  }

  List <String> titles = [
    'Home',
    'Chats',
    'Posts',
    'Users',
    'Settings',
  ];


  File? profileImage;
  File? coverImage;
  File? postImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    }
    else {
      print('No image selected ! ');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  Future<void> getCoverImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    }
    else {
      print('No image selected ! ');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  Future<void> getPostImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    }
    else {
      print('No selected image!');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void uploadProfileImage() {
    FirebaseStorage.instance.ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().
      then((value) {
        emit(SocialUploadProfileImageSuccessState());
      }).
      catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    })
        .catchError((error) {

    });
  }

  void uploadCoverImage() {
    FirebaseStorage.instance.ref()
        .child('users/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
        emit(SocialUploadCoverImageSuccessState());
      })
          .catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    })
        .catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUpdateUserLoadingState());
    SocialUserModel userModel = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      image: model!.image,
      cover: model!.cover,
      isEmailVerified: false,
      uId: model!.uId,
      email: model!.email,
    );
    FirebaseFirestore.instance.
    collection('users').
    doc(model!.uId).
    update(userModel.toMap()).
    then((value) {
      getUserData();
      emit(SocialUpdateUserSuccessState());
    }).
    catchError((error) {
      emit(SocialUpdateUserErrorState());
    });
  }

  void uploadPostImage({
    required String datetime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    FirebaseStorage.instance.ref()
        .child('users/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
        createPost(text: text,
            datetime: datetime,
            image: value);
        emit(SocialCreatePostSuccessState());
      })
          .catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    })
        .catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String text,
    required String datetime,
    String? image,
  }) {
    emit(SocialCreatePostLoadingState());
    SocialPostModel postModel = SocialPostModel(
      name: model!.name,
      profileImage: model!.image,
      uId: model!.uId,
      datetime: datetime,
      text: text,
      postImage: image,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      getPostData();
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  List <SocialPostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];
  List<int> comments = [];


  void getPostData() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datetime',)
        .get()
        .then((value) {
      posts.clear();
      comments.clear();
      value.docs.forEach((element) {
        element.reference
            .collection('likes')
            .get()
            .then((value) {
          likes.add(value.docs.length);
          postId.add(element.id);
          posts.add(SocialPostModel.fromJson(element.data()));
          comments.add(0); // Initialize comment count
          element.reference
              .collection('comments')
              .get()
              .then((commentValue) {
            comments[posts.length - 1] =
                commentValue.docs.length; // Update comment count
            emit(SocialGetPostSuccessState());
          });
        }).catchError((error) {});
      });
    }).catchError((error) {
      emit(SocialGetPostErrorState());
    });
  }


  void likePost(String postId) {
    var likeCollection = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes');

    // Check if the user has already liked the post
    likeCollection.where('uId', isEqualTo: model!.uId).get().then((value) {
      if (value.docs.isEmpty) {
        // User hasn't liked the post yet, so allow them to like
        likeCollection.add({
          'like': true,
          'uId': model!.uId,
          'datetime': DateTime.now().toString(),
        }).then((value) {
          int postIndex = this.postId.indexOf(postId); // Ensure correct index
          if (postIndex != -1) {
            likes[postIndex]++; // Increment the like count
          }
          emit(SocialLikePostSuccessState());
        }).catchError((error) {
          emit(SocialLikePostErrorState());
        });
      } else {
        // User has already liked the post, show an error or do nothing
        emit(SocialAlreadyLikedPostState()); // Create a new state if needed
      }
    }).catchError((error) {
      emit(SocialLikePostErrorState());
    });
  }


  void addComment(String postId, String commentText) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'comment': commentText,
      'uId': model!.uId,
      'datetime': DateTime.now().toString(),
    }).then((value) {
      // Increment the comment count
      int postIndex = this.postId.indexOf(postId); // Ensure correct index
      if (postIndex != -1) {
        comments[postIndex]++; // Increment the comment count
      }
      emit(SocialAddCommentSuccessState());
    }).catchError((error) {
      emit(SocialAddCommentErrorState());
      // Optionally, show a snackbar or alert to notify the user of the error
    });
  }



  List<SocialUserModel> users = [];

  void getUsers() {
    users.clear();
    // users = [];

    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] != model!.uId)
          users.add(SocialUserModel.fromJson(element.data()));
      });
      emit(SocialGetAllUserSuccessState());
    })
        .catchError((error) {
      emit(SocialGetAllUserErrorState());
    });
  }

  void sendMessage({
    required String receiverId,
    required String text,
    required String datetime,
  }) {
    SocialMessageModel messageModel = SocialMessageModel(
      senderId: model!.uId,
      receiverId: receiverId,
      text: text,
      datetime: datetime,
    );

    FirebaseFirestore.instance
        .collection('users').doc(model!.uId)
        .collection('chats').doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users').doc(receiverId)
        .collection('chats').doc(model!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List <SocialMessageModel> messages = [];

  void getMessage({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users').doc(model!.uId)
        .collection('chats').doc(receiverId)
        .collection('messages')
        .orderBy('datetime')
        .snapshots()
        .listen((value) {
      messages = [];
      value.docs.forEach((element) {
        messages.add(SocialMessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
}