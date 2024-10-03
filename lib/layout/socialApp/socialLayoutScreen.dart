import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t2/layout/socialApp/cubit/cubit.dart';
import 'package:t2/layout/socialApp/cubit/states.dart';
import 'package:t2/modules/socialApp/newPost/newPostScreen.dart';
import 'package:t2/shared/components/components.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = SocialCubit.get(context);
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is NewPostState)
          navigateTo(context, NewPostScreen());
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title:
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child:  Text(cubit.titles[cubit.currentIndex],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            actions: [
              Icon(Icons.search),
              const SizedBox(width: 20),
              Icon(Icons.notifications),
              const SizedBox(width: 20),
            ],
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: ConditionalBuilder(
            condition: cubit.model != null,
            builder: (context) {
              return cubit.screens[cubit.currentIndex];
            },
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,
            elevation: 4.0,
            type: BottomNavigationBarType.fixed, // Ensures that all items are the same width
            selectedFontSize: 14.0, // Adjust font size if needed
            unselectedFontSize: 12.0,
            onTap: cubit.changeBottomNav,
            currentIndex: cubit.currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                activeIcon: Icon(Icons.home, color: Colors.deepPurple),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined),
                activeIcon: Icon(Icons.chat, color: Colors.deepPurple), // Change icon when selected
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_to_photos_outlined),
                activeIcon: Icon(Icons.add_to_photos, color: Colors.deepPurple),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                activeIcon: Icon(Icons.person, color: Colors.deepPurple),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                activeIcon: Icon(Icons.settings, color: Colors.deepPurple),
                label: 'Settings',
              ),
            ],
          ),

        );
      },
    );
  }
}
