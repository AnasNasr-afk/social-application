import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t2/layout/socialApp/cubit/cubit.dart';
import 'package:t2/layout/socialApp/cubit/states.dart';
import 'package:t2/models/socialApp/socialMessageModel.dart';
import 'package:t2/models/socialApp/socialUserModel.dart';

class ChatDetailsScreen extends StatelessWidget {
  final SocialUserModel model;

  ChatDetailsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    var messageController = TextEditingController();
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessage(receiverId: '${model.uId}');
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('${model.image}'),
                    ),
                    const SizedBox(width: 10),
                    Text('${model.name}'),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            var message = SocialCubit.get(context).messages[index];
                            if (SocialCubit.get(context).model!.uId == message.senderId)
                              return buildMyMessage(message);

                            return buildMessage(message);
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 15),
                          itemCount: SocialCubit.get(context).messages.length,
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: messageController,
                                onFieldSubmitted: (value) {
                                  SocialCubit.get(context).sendMessage(
                                    receiverId: '${model.uId}',
                                    text: messageController.text,
                                    datetime: DateTime.now().toIso8601String(),
                                  );
                                  messageController.clear();
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Type your message here...',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              color: Colors.blue,
                              child: MaterialButton(
                                onPressed: () {
                                  SocialCubit.get(context).sendMessage(
                                    receiverId: '${model.uId}',
                                    text: messageController.text,
                                    datetime: DateTime.now().toIso8601String(),
                                  );
                                  messageController.clear();
                                },
                                minWidth: 1,
                                child: const Icon(Icons.send, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) => const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(SocialMessageModel model) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
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
          ' ${model.text}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget buildMyMessage(SocialMessageModel model) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            bottomStart: Radius.circular(10),
          ),
        ),
        child: Text(
          ' ${model.text}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
