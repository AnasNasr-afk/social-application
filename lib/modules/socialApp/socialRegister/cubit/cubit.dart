import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t2/models/socialApp/socialUserModel.dart';
import 'package:t2/modules/socialApp/socialRegister/cubit/states.dart';

import '../../../../shared/network/remote/dioHelper.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  bool isPasswordShown = true;
  IconData passwordIcon = Icons.visibility;

  void changePasswordIcon() {
    isPasswordShown = !isPasswordShown;
    passwordIcon = isPasswordShown ? Icons.visibility_off : Icons.visibility;
    emit(ChangePasswordIconState());
  }

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email,
      password: password,).
    then((value) {
      // print(value.user!.email);
      // print(value.user!.uid);
      userCreate(
        email: email,
        name: name,
        phone: phone,
        uId: value.user!.uid,
      );
      emit(SocialRegisterSuccessState());
    }).
    catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }
  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }){
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      isEmailVerified: false,
      image: 'https://i.sstatic.net/l60Hf.png',
      cover: 'https://i.sstatic.net/l60Hf.png',
      bio: 'Write your bio ...',
    );
    FirebaseFirestore.instance.
    collection('users').
    doc(uId).
    set(model.toMap()).
    then((value){
      emit(SocialCreateUserSuccessState());
    }).catchError((error){
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }
}

