import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flashChat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  String messageText;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(loggedInUser);
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
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
                  MaterialButton(
                    elevation: 5,
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add(
                          {'text': messageText, 'sender': loggedInUser.email});
                      print(messageText);
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LinearProgressIndicator(),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubbles> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final currentUser = loggedInUser.email;
          final messageBubble = MessageBubbles(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubbles extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  MessageBubbles({this.sender, this.text, this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            child: Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topLeft: Radius.circular(30))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30)),
              elevation: 5,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: isMe
                            ? BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(26))
                            : BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(26)),
                      ),
                      child: Text(
                        sender,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
