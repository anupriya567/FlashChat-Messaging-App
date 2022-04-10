import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String messageText = " ";
  final messageTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async{
    try{
      final user = await _auth.currentUser;
      if(user != null)
        loggedInUser = user;
        print(loggedInUser?.email);
    }
    catch(e) {
      print(e);
    }
  }
 // void getMessages()async {
 //  final messages = await _firestore.collection('messages').get();
 //  try  {
 //    for(var message in messages.docs)
 //    {
 //      Map<String,dynamic> mp = message.data();
 //      print(mp['text']);
 //      print(mp['sender']);
 //    }
 //  }
 //  catch(e)
 //   {print(e);
 //   }
 //  }
 //  void messageStream() async{
 //    await for(var snapshot in _firestore.collection('messages').snapshots() )
 //      {
 //        for(var message in snapshot.docs)
 //          {
 //            print(message.data);
 //          }
 //      }
 //  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                // getMessages();
                // messageStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                          messageText = value;
                          },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      messageTextController.clear();
                    _firestore.collection('messages').add(
                      {
                        'text': messageText,
                        'sender': loggedInUser?.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context,snapshot)
        {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data?.docs.reversed;
          List<MessageBubble>messageWidgets = [];
          for (var message in messages!) {
            dynamic msg_data = message.data();
            final messageText = msg_data['text'];
            final messageSender = msg_data["sender"];

            final messageWidget = MessageBubble(text:messageText, sender:messageSender, isMe: (messageSender == loggedInUser?.email) );
            messageWidgets.add(messageWidget);
          }
          return Expanded(child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets,
          ));
        }
    );
  }
}

class MessageBubble extends StatelessWidget {

  String text = "ss";
  String sender = "ss";
  bool isMe = true;
  MessageBubble( {required this.text,required this.sender,required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(
            fontSize: 10.0,
            color: Colors.black54
          )),
          Material(
            borderRadius:isMe? BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)
            ) : BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)
            ),
            elevation: 5.0,
            color: isMe?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Text(text,style: TextStyle(
                fontSize: 15.0,
                color: isMe?Colors.white:Colors.black,
              ),),
            ),
          ),
        ],
      ),
    );


  }
}
