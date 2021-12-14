// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:blood_donation/components/constant/colors.dart';
import 'package:blood_donation/components/constant/size.dart';
import 'package:blood_donation/model/assistant/chat_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_types/text_message.dart';

class Message extends StatelessWidget {
  final ChatMessage chat;

  const Message({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSender = (chat.sender == FirebaseAuth.instance.currentUser!.uid);
    Widget messageContained(ChatMessage message) {
      switch (message.messageType) {
        case "text":
          return new TextMessage(
            chat: chat,
          );
        // case "audio":
        //   return new AudioMessage();
        // case "video":
        //   return new VideoMessage();
        // case "image":
        //   return new ImageMessage();
        default:
          return SizedBox();
      }
    }

    return new Padding(
      padding: EdgeInsets.only(
        top: MySizes.defaultSpace / 2,
        right: (!isSender) ? MySizes.defaultSpace * 2 : 0,
        left: (isSender) ? MySizes.defaultSpace * 2 : 0,
      ),
      child: new Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (!isSender) ...[
            new CircleAvatar(
              radius: 16,
              backgroundImage:
                  (chat.image != null) ? NetworkImage(chat.image!) : null,
              child: (chat.image == null)
                  ? Icon(Icons.account_circle)
                  : SizedBox(),
            ),
            new SizedBox(
              width: MySizes.defaultSpace / 2,
            ),
          ],
          messageContained(chat),
          if (isSender) new MessageStatusDot(status: chat.messageStatus!)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final String status;

  const MessageStatusDot({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color dotColor(String status) {
      switch (status) {
        case "notSent":
          return Colors.red;
        case "notViewed":
          return Colors.red;
        case "viewed":
          return MyColors.primary;
        default:
          return Colors.transparent;
      }
    }

    return new Container(
      margin: EdgeInsets.only(
        left: 10,
      ),
      height: 12,
      width: 12,
      decoration: new BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: new Icon(
        (status == "notSent") ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
