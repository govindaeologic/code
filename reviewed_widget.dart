import 'package:dating_app/conversation2/chat_controller3.dart';
import 'package:dating_app/conversation2/chat_model.dart';
import 'package:dating_app/conversation2/fixed_converstaions.dart';
import 'package:dating_app/screens/one_conversation_screen/controllers/messagesController.dart';
import 'package:dating_app/screens/one_conversation_screen/widgets/messages_section/sub_widgets/Message_shape_widgets/bubbleMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReviewedWidget extends StatelessWidget {
  final ChatModel chatMessage;
  final bool isDesable;
  ReviewedWidget({
    Key? key,
    required this.chatMessage,
    required this.isDesable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewChatController _chatController = Get.put(NewChatController());

    final MessageController _messageController = Get.put(MessageController());
    return BubbleMessage(
      isDisable: isDesable,
      isMyMessage: _chatController.isMyChat(chatMessage),
      messageWidget: Container(
        constraints: BoxConstraints(maxWidth: 300.w),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Text(
          _messageController.translateText(chatMessage.content, context),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            fontFamily: 'Hellix',
          ),
        ),
      ),
    );
  }
}

class CallNowWidgetFemale extends StatelessWidget {
  final ChatModel chatMessage;
  CallNowWidgetFemale({
    Key? key,
    required this.chatMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewChatController _chatController = Get.put(NewChatController());

    final MessageController _messageController = Get.put(MessageController());
    return BubbleMessage(
      isDisable: false,
      isMyMessage: _chatController.isMyChat(chatMessage),
      messageWidget: Container(
        constraints: BoxConstraints(maxWidth: 300.w),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Text(
          FixedConversation.itsTimeForVideoCallFemale,
          textAlign: TextAlign.start,
          style: _messageController.messagesTextStyle,
        ),
      ),
    );
  }
}
