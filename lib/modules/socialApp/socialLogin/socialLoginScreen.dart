import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:t2/layout/shopApp/shop_layout.dart';
import 'package:t2/layout/socialApp/socialLayoutScreen.dart';
import 'package:t2/modules/shopApp/shop_login_screen/cubit/cubit.dart';
import 'package:t2/modules/shopApp/shop_login_screen/cubit/states.dart';
import 'package:t2/modules/shopApp/shop_register_screen/shop_register_screen.dart';
import 'package:t2/modules/socialApp/socialLogin/cubit/cubit.dart';
import 'package:t2/modules/socialApp/socialLogin/cubit/states.dart';
import 'package:t2/modules/socialApp/socialRegister/socialRegisterScreen.dart';
import 'package:t2/shared/components/components.dart';
import 'package:t2/shared/network/local/cacheHelper.dart';
import 'package:t2/shared/network/remote/dioHelper.dart';



class SocialLoginScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();

  SocialLoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
        listener: (context, state) {
          if(state is SocialLoginErrorState){
            showToast(text: state.error, color: Colors.red);
          }
          if (state is SocialLoginSuccessState){
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value){
              showToast(text: 'Login success', color: Colors.green);
              navigateAndFinish(context, SocialLayout());
            });
          }
        },
        builder: (context , state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Text('Ahlan! Let\'s get started',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value){
                            if (value == null || value.isEmpty){
                              return 'Email must not be empty!';
                            }
                            return null;
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                            ),
                            labelText: 'Email Address',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Password must not be empty!';
                            }
                            return null;
                          },
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: SocialLoginCubit.get(context).isPasswordShown,
                          onFieldSubmitted: (value){
                            if (formKey.currentState!.validate()){
                            }
                          },
                          decoration:  InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              icon : Icon(SocialLoginCubit.get(context).passwordIcon) ,
                              onPressed: (){
                                SocialLoginCubit.get(context).changePasswordIcon();
                              },
                            ),
                            labelText: 'Password',

                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: ConditionalBuilder(
                            condition: state is! SocialLoginLoadingState,
                            builder: (context) => MaterialButton(onPressed: (){
                              if (formKey.currentState!.validate()){
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                              color: Colors.deepPurple,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ) ,
                            ),
                            fallback: (context) => const Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?' ,
                            ),
                            TextButton(onPressed: (){
                              navigateTo(context, SocialRegisterScreen());
                            },
                              child: const Text(
                                'Register Now',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ) ;
        },
      ),
    );
  }
}

