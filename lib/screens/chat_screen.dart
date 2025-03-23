import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedINputuser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  late String messageText;

  @override
  void initState() {
    super.initState();
    getcurrentUser();
  }

  void getcurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedINputuser = user;
        print(loggedINputuser);
      }
    } catch (e) {
      print(e);
    }
  }

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
                _auth.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
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
            Streambuilder(),
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
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      //we have messageText + loggedin Email
                      _firestore.collection('messages').add({
                        'sender': loggedINputuser.email,
                        'text': messageText,
                        'date': DateTime.now().toIso8601String().toString(),
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

class Streambuilder extends StatelessWidget {
  const Streambuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('date').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          } else {
            final message = snapshot.data?.docs.reversed;

            List<MessageBubble> messageWidget = [];
            for (var messages in message!) {
              final messageText =
                  (messages.data() as Map<String, dynamic>)['text'];
              final messageSender =
                  (messages.data() as Map<String, dynamic>)['sender'];
              final currentUser = loggedINputuser.email;
              final messagebubble = MessageBubble(
                sender: messageSender,
                text: messageText,
                isMe: currentUser == messageSender,
              );
              messageWidget.add(messagebubble);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                children: messageWidget,
              ),
            );
          }
          return Center(child: Text('Loading...........'));
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text('$sender'),
            Material(
              borderRadius: BorderRadius.circular(30.0),
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  ' $text',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: isMe ? Colors.white : Colors.black54,
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
