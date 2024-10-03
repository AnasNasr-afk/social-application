import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t2/layout/socialApp/cubit/cubit.dart';
import 'package:t2/layout/socialApp/cubit/states.dart';
import 'package:t2/models/socialApp/socialPostModel.dart';
import 'package:t2/models/socialApp/socialUserModel.dart';
import 'package:t2/modules/socialApp/homeScreen/commentDetails.dart';
import 'package:t2/shared/components/components.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialGetUserErrorState) {
          print('User data fetching failed');
        }
        if (state is SocialGetPostErrorState) {
          print('Posts data fetching failed');
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        print('User: ${cubit.model}');
        print('Posts: ${cubit.posts.length}');

        return ConditionalBuilder(
          condition: cubit.posts.isNotEmpty && cubit.model != null,
          builder: (context) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  itemBuilder: (context, index) => buildPostItem(cubit.posts[index], context, index),
                  itemCount: cubit.posts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          ),
          fallback: (context) {
            if (state is SocialGetUserLoadingState || state is SocialGetPostLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text(''));
            }
          },
        );
      },
    );
  }
}

Widget buildPostItem(SocialPostModel model, BuildContext context, int index) {
  var commentController = TextEditingController();
  SocialUserModel? userModel = SocialCubit.get(context).model;

  return Card(
    color: Colors.white,
    elevation: 5,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Existing user details and post content
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${model.profileImage}'),
                radius: 25,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.verified, color: Colors.blue, size: 18),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${model.datetime}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          Text('${model.text}', style: const TextStyle(fontWeight: FontWeight.bold)),
          // Existing hashtags
          Wrap(
            children: [
              for (var tag in ['#software', '#flutter', '#google', '#mobile_application'])
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 5),
                  child: MaterialButton(
                    onPressed: () {},
                    minWidth: 1,
                    padding: EdgeInsets.zero,
                    child: Text(
                      tag,
                      style: const TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          // Likes and comments section
          Row(
            children: [
              const Icon(Icons.favorite_border, color: Colors.redAccent),
              Text('${SocialCubit.get(context).likes[index]}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const Spacer(),
              IconButton(onPressed: (){
                navigateTo(context, CommentDetails(postIndex: index, comments: [], newComment: '',));
              },
                icon: Icon(Icons.comment, color: Colors.amberAccent),),
              Text('${SocialCubit.get(context).comments[index]}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),

            ],
          ),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${userModel!.image}'),
                radius: 18,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextFormField(
                  controller: commentController,
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      // Add comment logic
                      SocialCubit.get(context).addComment(SocialCubit.get(context).postId[index], value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Comment submitted!')),
                      );
                      commentController.clear(); // Clear input after submission
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Write a comment...',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 1, // Limit to one line
                ),
              ),
              const SizedBox(width: 8), // Add some spacing
              ElevatedButton(
                onPressed: () {
                  if (commentController.text.isNotEmpty) {
                    // Add comment logic
                    SocialCubit.get(context).addComment(SocialCubit.get(context).postId[index], commentController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Comment submitted!')),
                    );
                    commentController.clear(); // Clear input after submission
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () {
                  SocialCubit.get(context).likePost(SocialCubit.get(context).postId[index]);
                },
                child: const  Row(
                  children:  [
                    Icon(Icons.favorite_border, color: Colors.redAccent),
                    SizedBox(width: 5),
                    Text('Like', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

