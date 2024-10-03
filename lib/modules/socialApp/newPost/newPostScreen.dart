import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t2/layout/socialApp/cubit/cubit.dart';
import 'package:t2/layout/socialApp/cubit/states.dart';
import 'package:t2/layout/socialApp/socialLayoutScreen.dart';
import 'package:t2/models/socialApp/socialPostModel.dart';
import 'package:t2/models/socialApp/socialUserModel.dart';
import 'package:t2/shared/components/components.dart';
import 'package:intl/intl.dart';


class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var model = SocialCubit.get(context).model;
    var textController = TextEditingController();
    return BlocConsumer<SocialCubit,SocialStates>(
      listener:  (context , state){
        if (state is SocialCreatePostSuccessState){
          showToast(text: 'Post added successfully',
              color: Colors.green);
        } else if (state is SocialCreatePostErrorState){
          showToast(text: 'Post added failed',
              color: Colors.red);
        }
      },
      builder: (context , state){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: (){
                navigateAndFinish(context, SocialLayout());
              },
              icon: const Icon(Icons.cancel_outlined ,
                size: 30,),
            ),
            centerTitle: true,
            title: const Text('Create Post' ,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Ensure you format the current date and time correctly
                  String formattedDateTime = DateFormat('MMMM d, y, h:mm a').format(DateTime.now());

                  if (SocialCubit.get(context).postImage == null) {
                    SocialCubit.get(context).createPost(
                      text: textController.text,
                      datetime: formattedDateTime,
                    );
                    navigateAndFinish(context, SocialLayout());
                  } else {
                    SocialCubit.get(context).uploadPostImage(
                      text: textController.text,
                      datetime: formattedDateTime,
                    );
                    navigateAndFinish(context, SocialLayout());
                  }
                },
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  children: [
                     CircleAvatar(
                      backgroundImage: NetworkImage('${model!.image}'),
                      radius: 25,
                    ),
                    const SizedBox(width: 15),
                     Text(
                      '${model.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                        hintText: 'What is on your mind ...',
                        border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: null,
                  ),
                ),
                if (SocialCubit.get(context).postImage != null)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: FileImage(SocialCubit.get(context).postImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 150,
                          width: double.infinity,
                        ),
                        IconButton(
                          onPressed: () {
                            SocialCubit.get(context).removePostImage();
                          },
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(onPressed: (){
                          // SocialCubit.get(context).getPostImage();
                        },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image,
                                color: Colors.blue,),
                              Text('Add photo',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(onPressed: (){},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center ,
                            children: [
                              Icon(Icons.tag,
                                color: Colors.blue,),
                              Text('Add tag' ,
                                style: TextStyle(
                                  color: Colors.blue,
                                ),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
