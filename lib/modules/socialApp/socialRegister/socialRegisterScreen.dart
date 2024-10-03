import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t2/layout/socialApp/socialLayoutScreen.dart';
import 'package:t2/modules/socialApp/socialLogin/cubit/cubit.dart';
import 'package:t2/modules/socialApp/socialLogin/socialLoginScreen.dart';
import 'package:t2/modules/socialApp/socialRegister/cubit/cubit.dart';
import 'package:t2/modules/socialApp/socialRegister/cubit/states.dart';
import 'package:t2/shared/components/components.dart';

class SocialRegisterScreen extends StatelessWidget {
  const SocialRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var userNameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit,SocialRegisterStates>(
        listener:(context,state){
          if(state is SocialCreateUserSuccessState){
            navigateAndFinish(context, SocialLayout());
            showToast(text: 'Login Success', color: Colors.green);
          }
        } ,
        builder: (context,state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    children: [
                      const Text('REGISTER',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      TextFormField(
                        validator: (value){
                          if (value == null || value.isEmpty){
                            return 'User Name must not be empty!';
                          }
                          return null;
                        },
                        controller: userNameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          labelText: 'User Name',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                        obscureText: SocialRegisterCubit.get(context).isPasswordShown,
                        onFieldSubmitted: (value){
                          if (formKey.currentState!.validate()){
                          }
                        },
                        decoration:  InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),
                          suffixIcon: IconButton(
                            icon : Icon(SocialRegisterCubit.get(context).passwordIcon) ,
                            onPressed: (){
                              SocialRegisterCubit.get(context).changePasswordIcon();
                            },
                          ),
                          labelText: 'Password',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value){
                          if (value == null || value.isEmpty){
                            return 'Phone must not be empty!';
                          }
                          return null;
                        },
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                          ),
                          labelText: 'Phone',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => MaterialButton(onPressed: (){
                            if (formKey.currentState!.validate()){
                              SocialRegisterCubit.get(context).userRegister(
                                email: emailController.text,
                                password: passwordController.text,
                                name: userNameController.text,
                                phone: phoneController.text,);
                              navigateAndFinish(context, SocialLoginScreen());
                            }
                          },
                            color: Colors.deepPurple,
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ) ,
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

