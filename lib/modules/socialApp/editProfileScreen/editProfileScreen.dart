import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t2/layout/socialApp/cubit/cubit.dart';
import 'package:t2/layout/socialApp/cubit/states.dart';
import 'package:t2/layout/socialApp/socialLayoutScreen.dart';
import 'package:t2/modules/socialApp/accountScreen/accountScreen.dart';
import 'package:t2/shared/components/components.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var model = SocialCubit.get(context).model;
    var nameController = TextEditingController();
    var bioController = TextEditingController();
    var phoneController = TextEditingController();
    var profileImage = SocialCubit.get(context).profileImage;
    var coverImage = SocialCubit.get(context).coverImage;
    var formKey = GlobalKey<FormState>();

    nameController.text = '${model!.name}';
    bioController.text ='${model.bio}';
    phoneController.text ='${model.phone}';

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialUpdateUserSuccessState) {
          showToast(text: 'Updated Successfully', color: Colors.green);
        } else if (state is SocialUpdateUserLoadingState) {
          // No toast should be shown here as it's only for loading.
        } else if (state is SocialUpdateUserErrorState) {
          showToast(text: 'Error occurred while updating', color: Colors.red);
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
              centerTitle: true,
              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()){
                      // Check if any changes were made before calling updateUser
                      if (nameController.text != model.name ||
                          phoneController.text != model.phone ||
                          bioController.text != model.bio ||
                          profileImage != null ||
                          coverImage != null) {
                        SocialCubit.get(context).updateUser(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text,
                        );
                      } else {
                        showToast(text: 'Nothing has changed', color: Colors.amber);
                      }
                    }

                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(height: 10,),
                            const Text('Profile picture',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const Spacer(),
                            TextButton(onPressed: (){
                              // SocialCubit.get(context).getProfileImage();
                            },
                              child: const Text('Edit',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          child: CircleAvatar(
                            backgroundImage: profileImage == null ?
                            NetworkImage('${model.image}') : FileImage(profileImage)
                            ,
                            radius: 70,
                          ),
                          onTap: (){
                            // SocialCubit.get(context).getProfileImage();
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(height: 10,),
                            const Text('Cover photo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const Spacer(),
                            TextButton(onPressed: (){
                              // SocialCubit.get(context).getCoverImage();
                            },
                              child: const Text('Edit',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                )
                                ,),
                            ),
                          ],
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              decoration:  BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image:coverImage == null ?
                                  NetworkImage('${model.cover}')
                                      : FileImage(coverImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 150,
                              width: double.infinity,
                            ),
                          ),
                          onTap: (){
                            // SocialCubit.get(context).getCoverImage();
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        const Text('Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name must not be empty!';
                            }
                            return null;
                          },
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(), // Correct InputBorder type
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 14,
                            ),
                            labelText: 'Name',
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        const Text('Phone',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone must not be empty!';
                            }
                            return null;
                          },
                          controller: phoneController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(), // Correct InputBorder type
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 14,
                            ),
                            labelText: 'Phone',
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        const Text('Bio',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bio must not be empty!';
                            }
                            return null;
                          },
                          controller: bioController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(), // Correct InputBorder type
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 14,
                            ),
                            labelText: 'Bio',
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}