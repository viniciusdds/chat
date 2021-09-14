import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatMessage>>(
      stream: ChatService().messagesStream(),
      builder: (ctx, snapshot){
        print(snapshot.hasData);
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if(!snapshot.hasData || snapshot.data.isEmpty){
           return Center(
             child: Text('Sem Dados. Vamos conversar?'),
           );
        }else{
           final msgs = snapshot.data;
           return ListView.builder(
             reverse: true,
             itemCount: msgs.length,
             itemBuilder: (ctx, index) => Text(msgs[index].text),
           );
        }
      },
    );
  }
}
