import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t2/layout/socialApp/cubit/cubit.dart';
import 'package:t2/layout/socialApp/cubit/states.dart';

class CommentDetails extends StatelessWidget {
  final int postIndex; // Accept post index

  const CommentDetails({super.key, required this.postIndex,
   required String newComment, required List<dynamic> comments}); // Constructor

  @override
  Widget build(BuildContext context) {

    var comments = SocialCubit.get(context).comments[postIndex]; // Access comments related to the post
    var cubit = SocialCubit.get(context).model;

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context , state  ) {},
      builder:(context , state  ) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title:  Text(
              'Comments',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              const SizedBox(width: 10,),
              Icon(Icons.comment, color: Colors.amberAccent),
              const SizedBox(width: 10,),
              Text('${SocialCubit.get(context).comments[postIndex]}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(width: 10,),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          '${cubit!.image}',

                      ),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(10),
                          topEnd: Radius.circular(10),
                          bottomEnd: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        '{}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },

    );
  }
}
