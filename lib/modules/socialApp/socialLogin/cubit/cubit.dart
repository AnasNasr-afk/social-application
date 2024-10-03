import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t2/models/shopApp/login_model.dart';
import 'package:t2/modules/shopApp/shop_login_screen/cubit/states.dart';

import 'package:t2/modules/socialApp/socialLogin/cubit/states.dart';
import 'package:t2/shared/network/remote/dioHelper.dart';

import '../../../../shared/network/endPoints.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates>{

  SocialLoginCubit() : super(SocialLoginInitialState() );

  static SocialLoginCubit get(context) => BlocProvider.of(context);


  void userLogin({
    required String email,
    required String password,
  }){
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password)
        .then((value){
      print(value.user!.email);
      emit(SocialLoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  bool isPasswordShown = true;
  IconData passwordIcon = Icons.visibility;

  void changePasswordIcon(){
    isPasswordShown = !isPasswordShown;
    passwordIcon = isPasswordShown? Icons.visibility_off: Icons.visibility;

    emit(ChangePasswordIconState());
  }
}

