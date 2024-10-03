import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t2/layout/socialApp/cubit/cubit.dart';
import 'package:t2/layout/socialApp/cubit/states.dart';
import 'package:t2/models/socialApp/socialUserModel.dart';
import 'package:t2/modules/socialApp/chatScreen/chatDetails.dart';
import 'package:t2/shared/components/components.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocConsumer<SocialCubit , SocialStates>(
        listener: (context , state) {},
        builder:  (context , state) =>  ConditionalBuilder(
    condition: SocialCubit.get(context).users.isNotEmpty ,
    builder: (context) => ListView.separated(
      separatorBuilder: (context , index ) => const Divider(),
      itemBuilder:(context , index ) =>  buildChatItem(SocialCubit.get(context).users[index] , context) ,
      itemCount: SocialCubit.get(context).users.length,
    ),
          fallback: (context) {
            if (state is SocialGetUserLoadingState ) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text('No chats available'));
            }
          },
        ),

      ),
    );
  }

  Widget buildChatItem (SocialUserModel model , context) => InkWell(
    onTap: (){
      navigateTo(context, ChatDetailsScreen(model: model,));
    },
    child: Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(''
              '${model.image}'),
          radius: 25,
        ),
        const SizedBox(width: 15),
        Text(
          '${model.name}',
          style: const TextStyle(fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
