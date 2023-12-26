import 'dart:developer';

import 'package:dating_app/conversation2/chat_controller3.dart';
import 'package:dating_app/conversation2/chat_model.dart';
import 'package:dating_app/conversation2/fixed_converstaions.dart';
import 'package:dating_app/datas/user.dart';
import 'package:dating_app/plugins/video_call/utils/call_helper.dart';
import 'package:dating_app/screens/one_conversation_screen/controllers/messagesController.dart';
import 'package:dating_app/screens/one_conversation_screen/models/ChatMessage.dart';
import 'package:dating_app/screens/one_conversation_screen/widgets/messages_section/sub_widgets/Message_shape_widgets/bubbleMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'reviewed_widget.dart';

class AcceptOrRefuseChatMessageWidget extends StatelessWidget {
  final ChatMessage2 chatMessage;
  final MessageController _messageController = Get.put(MessageController());

  AcceptOrRefuseChatMessageWidget({Key? key, required this.chatMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_messageController.isThisMyMessage(chatMessage)) {
      // revieweeddd
      return ReviewedWidget(
        isDesable: false,
        chatMessage: ChatModel(),
      );
    } else {
      // revieweerrr
      return ReviewerWidget(
        disable: true,
        chatMessage: ChatModel(),
      );
    }
  }
}

class ReviewerWidget extends StatefulWidget {
  ReviewerWidget({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);
  final ChatModel chatMessage;
  final bool disable;

  @override
  State<ReviewerWidget> createState() => _ReviewerWidgetState();
}

class _ReviewerWidgetState extends State<ReviewerWidget> {
  NewChatController chatController = Get.put(NewChatController());
  // Get Date time picker app locale
  DateTimePickerLocale _getDatePickerLocale() {
    // Inicial value
    DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
    // Get the name of the current locale.

    return _locale;
  }

  /// Display date picker.
  void _showDatePicker(BuildContext context) {
    int selectedDateIndex = 0;
    int selectedTimeIndex = 0;

    List<String> dateList = List<String>.generate(6, (index) {
      DateTime currentDate = DateTime.now().add(Duration(days: 3 + index));
      String formattedDate = DateFormat('dd MMMM').format(currentDate);
      return formattedDate;
    });

    List<String> timeList = List<String>.generate(13, (index) {
      DateTime currentTime = DateTime(0, 0, 0, 10 + index);
      String formattedTime = DateFormat('h:mm a').format(currentTime);
      return formattedTime;
    });
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text('Done'),
                onPressed: () {
                  String selectedDate = dateList[selectedDateIndex];
                  String selectedTime = timeList[selectedTimeIndex];
                  DateTime selectedDateTime = DateTime.parse(
                      '${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 3 + selectedDateIndex)))} ${DateFormat('HH:mm').format(DateTime(0, 0, 0, 10 + selectedTimeIndex))}');
                  log('Selected Date: $selectedDate');
                  log('Selected Time: $selectedTime');
                  log('Selected DateTime: $selectedDateTime');
                  chatController.setVideoCallDateTime(selectedDateTime);
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              height: 1,
              color: Colors.black54,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 30,
                      diameterRatio: 10,
                      squeeze: 1,
                      useMagnifier: false,
                      selectionOverlay: Container(
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.symmetric(
                                horizontal: BorderSide(color: Colors.black54))),
                      ),
                      children: List<Widget>.generate(6, (index) {
                        DateTime currentDate =
                            DateTime.now().add(Duration(days: 3 + index));
                        String formattedDate =
                            DateFormat('dd MMMM').format(currentDate);
                        return Text(
                          formattedDate,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        );
                      }),
                      onSelectedItemChanged: (value) {
                        setState(() {
                          selectedDateIndex = value;
                        });
                      },
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 30,
                      diameterRatio: 10,
                      squeeze: 1,
                      useMagnifier: false,
                      selectionOverlay: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.symmetric(
                                horizontal: BorderSide(color: Colors.black54))),
                      ),
                      children: List<Widget>.generate(13, (index) {
                        DateTime currentTime = DateTime(0, 0, 0, 10 + index);
                        String formattedTime =
                            DateFormat('h:mm a').format(currentTime);
                        return Text(
                          formattedTime,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        );
                      }),
                      onSelectedItemChanged: (value) {
                        setState(() {
                          selectedTimeIndex = value;
                        });
                      },
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

  void accept() async {}

  void refuse() async {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleMessage(
          isMyMessage: chatController.isMyChat(widget.chatMessage),
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            child: Text(
              'Choose your preferred time for a quick  5min video call Date should be 3 days from now at least',
              // _messageController.translateText(
              //     widget.chatMessage.question, context),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
          isDisable: widget.disable,
        ),
        SizedBox(
            // height: 10.h,
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: widget.disable
                  ? null
                  : () {
                      _showDatePicker(context);
                    },
              child: BubbleMessage(
                messageWidget: Text(
                  'Set Date/Time',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    fontFamily: 'Hellix',
                  ),
                ),
                isMyMessage: true,
                isDisable: widget.disable,
              ),
            ),
            InkWell(
                onTap: widget.disable
                    ? null
                    : () {
                        chatController.endConversation();
                      },
                child: BubbleMessage(
                  messageWidget: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Hellix',
                    ),
                  ),
                  isMyMessage: true,
                  isDisable: widget.disable,
                ))
            // ButtonInMessage(
            //   // if chatMessage.answer == "YES", the the user already answered this question (disbale it)
            //   isDisabled: widget.chatMessage.answer == "YES",
            //   text: _i18n.translate("accept"),
            //   callBackMethod: accept,
            //   isThisMyMessage:
            //       _messageController.isThisMyMessage(widget.chatMessage),
            // ),
            // SizedBox(
            //   width: 20.w,
            // ),
            // ButtonInMessage(
            //   isDisabled: widget.chatMessage.answer == "YES",
            //   text: _i18n.translate("refuse"),
            //   callBackMethod: refuse,
            //   isThisMyMessage:
            //       _messageController.isThisMyMessage(widget.chatMessage),
            // ),
          ],
        ),
      ],
    );
  }
}

class RescheduleDateWidget extends StatefulWidget {
  RescheduleDateWidget({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);
  final ChatModel chatMessage;
  final bool disable;

  @override
  State<RescheduleDateWidget> createState() => _RescheduleDateWidgetState();
}

class _RescheduleDateWidgetState extends State<RescheduleDateWidget> {
  NewChatController chatController = Get.put(NewChatController());
  // Get Date time picker app locale
  DateTimePickerLocale _getDatePickerLocale() {
    // Inicial value
    DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
    // Get the name of the current locale.

    return _locale;
  }

  /// Display date picker.
  void _showDatePicker(BuildContext context) {
    int selectedDateIndex = 0;
    int selectedTimeIndex = 0;

    List<String> dateList = List<String>.generate(6, (index) {
      DateTime currentDate = DateTime.now().add(Duration(days: 3 + index));
      String formattedDate = DateFormat('dd MMMM').format(currentDate);
      return formattedDate;
    });

    List<String> timeList = List<String>.generate(13, (index) {
      DateTime currentTime = DateTime(0, 0, 0, 10 + index);
      String formattedTime = DateFormat('h:mm a').format(currentTime);
      return formattedTime;
    });
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text('Done'),
                onPressed: () {
                  String selectedDate = dateList[selectedDateIndex];
                  String selectedTime = timeList[selectedTimeIndex];
                  DateTime selectedDateTime = DateTime.parse(
                      '${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 3 + selectedDateIndex)))} ${DateFormat('HH:mm').format(DateTime(0, 0, 0, 10 + selectedTimeIndex))}');
                  log('Selected Date: $selectedDate');
                  log('Selected Time: $selectedTime');
                  log('Selected DateTime: $selectedDateTime');
                  chatController.setVideoCallDateTime(selectedDateTime);
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              height: 1,
              color: Colors.black54,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 30,
                      diameterRatio: 10,
                      squeeze: 1,
                      useMagnifier: false,
                      selectionOverlay: Container(
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.symmetric(
                                horizontal: BorderSide(color: Colors.black54))),
                      ),
                      children: List<Widget>.generate(6, (index) {
                        DateTime currentDate =
                            DateTime.now().add(Duration(days: 3 + index));
                        String formattedDate =
                            DateFormat('dd MMMM').format(currentDate);
                        return Text(
                          formattedDate,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        );
                      }),
                      onSelectedItemChanged: (value) {
                        setState(() {
                          selectedDateIndex = value;
                        });
                      },
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 30,
                      diameterRatio: 10,
                      squeeze: 1,
                      useMagnifier: false,
                      selectionOverlay: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.symmetric(
                                horizontal: BorderSide(color: Colors.black54))),
                      ),
                      children: List<Widget>.generate(13, (index) {
                        DateTime currentTime = DateTime(0, 0, 0, 10 + index);
                        String formattedTime =
                            DateFormat('h:mm a').format(currentTime);
                        return Text(
                          formattedTime,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        );
                      }),
                      onSelectedItemChanged: (value) {
                        setState(() {
                          selectedTimeIndex = value;
                        });
                      },
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

  void accept() async {}

  void refuse() async {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleMessage(
          isMyMessage: chatController.isMyChat(widget.chatMessage),
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            child: Text(
              'Choose your preferred time for a quick  5min video call Date should be 3 days from now at least',
              // _messageController.translateText(
              //     widget.chatMessage.question, context),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
          isDisable: widget.disable,
        ),
        SizedBox(
            // height: 10.h,
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: widget.disable
                  ? null
                  : () {
                      _showDatePicker(context);
                    },
              child: BubbleMessage(
                messageWidget: Text(
                  'Set Date/Time',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    fontFamily: 'Hellix',
                  ),
                ),
                isMyMessage: true,
                isDisable: widget.disable,
              ),
            ),
            InkWell(
                onTap: widget.disable
                    ? null
                    : () {
                        chatController.endConversation();
                      },
                child: BubbleMessage(
                  messageWidget: Text('Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      )),
                  isMyMessage: true,
                  isDisable: widget.disable,
                ))
            // ButtonInMessage(
            //   // if chatMessage.answer == "YES", the the user already answered this question (disbale it)
            //   isDisabled: widget.chatMessage.answer == "YES",
            //   text: _i18n.translate("accept"),
            //   callBackMethod: accept,
            //   isThisMyMessage:
            //       _messageController.isThisMyMessage(widget.chatMessage),
            // ),
            // SizedBox(
            //   width: 20.w,
            // ),
            // ButtonInMessage(
            //   isDisabled: widget.chatMessage.answer == "YES",
            //   text: _i18n.translate("refuse"),
            //   callBackMethod: refuse,
            //   isThisMyMessage:
            //       _messageController.isThisMyMessage(widget.chatMessage),
            // ),
          ],
        ),
      ],
    );
  }
}

class ReviewedWidgetCancel extends StatefulWidget {
  ReviewedWidgetCancel({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);
  final ChatModel chatMessage;
  final bool disable;
  @override
  State<ReviewedWidgetCancel> createState() => _ReviewedWidgetCancelState();
}

class _ReviewedWidgetCancelState extends State<ReviewedWidgetCancel> {
  NewChatController chatController = Get.put(NewChatController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleMessage(
          isMyMessage: chatController.isMyChat(widget.chatMessage),
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            child: Text(
              'Are you sure you want to cancel This will end the conversation',
              // _messageController.translateText(
              //     widget.chatMessage.question, context),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
          isDisable: widget.disable,
        ),
        SizedBox(
            // height: 10.h,
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: widget.disable
                    ? null
                    : () {
                        chatController.confirmEndConversation();
                      },
                child: BubbleMessage(
                  messageWidget: Text('Yes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      )),
                  isMyMessage: true,
                  isDisable: widget.disable,
                )),
            InkWell(
                onTap: widget.disable
                    ? null
                    : () {
                        chatController.rescheduleCAll();
                      },
                child: BubbleMessage(
                  messageWidget: Text('No',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      )),
                  isMyMessage: true,
                  isDisable: widget.disable,
                ))
            // ButtonInMessage(
            //   // if chatMessage.answer == "YES", the the user already answered this question (disbale it)
            //   isDisabled: widget.chatMessage.answer == "YES",
            //   text: _i18n.translate("accept"),
            //   callBackMethod: accept,
            //   isThisMyMessage:
            //       _messageController.isThisMyMessage(widget.chatMessage),
            // ),
            // SizedBox(
            //   width: 20.w,
            // ),
            // ButtonInMessage(
            //   isDisabled: widget.chatMessage.answer == "YES",
            //   text: _i18n.translate("refuse"),
            //   callBackMethod: refuse,
            //   isThisMyMessage:
            //       _messageController.isThisMyMessage(widget.chatMessage),
            // ),
          ],
        ),
      ],
    );
  }
}

class EndMatch extends StatelessWidget {
  EndMatch({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);
  final ChatModel chatMessage;
  final bool disable;

  NewChatController chatController = Get.put(NewChatController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleMessage(
          isMyMessage: chatController.isMyChat(chatMessage),
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            child: Text(
              'Are you sure you want to cancel This will end the conversation',
              // _messageController.translateText(
              //     widget.chatMessage.question, context),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
          isDisable: disable,
        ),
        SizedBox(
            // height: 10.h,
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        chatController.confirmEndConversation();
                      },
                child: BubbleMessage(
                  messageWidget: Text('Yes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      )),
                  isMyMessage: true,
                  isDisable: disable,
                )),
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        chatController.cancelEndMatch();
                      },
                child: BubbleMessage(
                  messageWidget: Text('No',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      )),
                  isMyMessage: true,
                  isDisable: disable,
                ))
            // ButtonInMessage(
            //   // if chatMessage.answer == "YES", the the user already answered this question (disbale it)
            //   isDisabled: widget.chatMessage.answer == "YES",
            //   text: _i18n.translate("accept"),
            //   callBackMethod: accept,
            //   isThisMyMessage:
            //       _messageController.isThisMyMessage(widget.chatMessage),
            // ),
            // SizedBox(
            //   width: 20.w,
            // ),
            // ButtonInMessage(
            //   isDisabled: widget.chatMessage.answer == "YES",
            //   text: _i18n.translate("refuse"),
            //   callBackMethod: refuse,
            //   isThisMyMessage:
            //       _messageController.isThisMyMessage(widget.chatMessage),
            // ),
          ],
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ReviewedWidgetCancelAfterSchedule extends StatelessWidget {
  ReviewedWidgetCancelAfterSchedule({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);
  final ChatModel chatMessage;
  final bool disable;

  NewChatController chatController = Get.put(NewChatController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleMessage(
          isMyMessage: chatController.isMyChat(chatMessage),
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            child: Text(
              'Are you sure you want to cancel This will end the conversation',
              // _messageController.translateText(
              //     widget.chatMessage.question, context),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
          isDisable: disable,
        ),
        SizedBox(
            // height: 10.h,
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        chatController.confirmEndConversation();
                      },
                child: BubbleMessage(
                  messageWidget: Text('Yes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      )),
                  isMyMessage: true,
                  isDisable: disable,
                )),
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        chatController.endConversationAfterDateSchedule(
                            chatMessage.content);
                      },
                child: BubbleMessage(
                  messageWidget: Text('No',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      )),
                  isMyMessage: true,
                  isDisable: disable,
                ))
          ],
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ReviewedWidgetCancelAfterPhoneFemale extends StatelessWidget {
  ReviewedWidgetCancelAfterPhoneFemale({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);
  final ChatModel chatMessage;
  final bool disable;

  NewChatController chatController = Get.put(NewChatController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleMessage(
          isMyMessage: chatController.isMyChat(chatMessage),
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            child: Text(
              'Are you sure you want to cancel This will end the conversation',
              // _messageController.translateText(
              //     widget.chatMessage.question, context),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
          isDisable: disable,
        ),
        SizedBox(
            // height: 10.h,
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        chatController.confirmEndConversation();
                      },
                child: BubbleMessage(
                  messageWidget: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Hellix',
                    ),
                  ),
                  isMyMessage: true,
                  isDisable: disable,
                )),
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        chatController.endConversationAfterDatePhoneFemale(
                            chatMessage.content);
                      },
                child: BubbleMessage(
                  messageWidget: Text('No',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      )),
                  isMyMessage: true,
                  isDisable: disable,
                ))
          ],
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ReviewedWidgetCancelAfterScheduleFemale extends StatelessWidget {
  ReviewedWidgetCancelAfterScheduleFemale({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);
  final ChatModel chatMessage;
  final bool disable;

  NewChatController chatController = Get.put(NewChatController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleMessage(
          isMyMessage: chatController.isMyChat(chatMessage),
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            child: Text(
              'Are you sure you want to cancel This will end the conversation',
              // _messageController.translateText(
              //     widget.chatMessage.question, context),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
          isDisable: false,
        ),
        SizedBox(
            // height: 10.h,
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        chatController.confirmEndConversation();
                      },
                child: BubbleMessage(
                  messageWidget: Text('Yes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      )),
                  isMyMessage: true,
                  isDisable: disable,
                )),
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        chatController.endConversationAfterDateScheduleFemale(
                            chatMessage.content);
                      },
                child: BubbleMessage(
                  messageWidget: Text('No',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      )),
                  isMyMessage: true,
                  isDisable: disable,
                ))
          ],
        ),
      ],
    );
  }
}

class ReviewedWidgetCancelFromFemale extends StatefulWidget {
  ReviewedWidgetCancelFromFemale({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);
  final ChatModel chatMessage;
  final bool disable;
  @override
  State<ReviewedWidgetCancelFromFemale> createState() =>
      _ReviewedWidgetCancelFromFemaleState();
}

class _ReviewedWidgetCancelFromFemaleState
    extends State<ReviewedWidgetCancelFromFemale> {
  NewChatController chatController = Get.put(NewChatController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleMessage(
          isMyMessage: chatController.isMyChat(widget.chatMessage),
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            child: Text(
              'Are you sure you want to cancel This will end the conversation',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
          isDisable: widget.disable,
        ),
        SizedBox(
            // height: 10.h,
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: widget.disable
                    ? null
                    : () {
                        chatController.confirmEndConversation();
                      },
                child: BubbleMessage(
                    isDisable: widget.disable,
                    messageWidget: Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true)),
            InkWell(
                onTap: widget.disable
                    ? null
                    : () {
                        chatController.scheduleVideoCallDateTimeAfterCancel(
                            DateTime.parse(widget.chatMessage.content!));
                      },
                child: BubbleMessage(
                    isDisable: widget.disable,
                    messageWidget: Text(
                      'No',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true))
          ],
        ),
      ],
    );
  }
}

class InitialTextWidget extends StatelessWidget {
  final ChatModel chatMessage;
  InitialTextWidget({
    Key? key,
    required this.chatMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);
    final NewChatController _messageController = Get.put(NewChatController());
    // if (chatMessage.senderUid) {
    //   return BubbleMessage(
    //     isMyMessage: false,
    //     messageWidget: Container(
    //       constraints: BoxConstraints(maxWidth: 300.w),
    //       padding: EdgeInsets.all(10.w),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(25.r),
    //       ),
    //       child: Text(
    //         'Congratulations you’ve got a match',
    //         textAlign: TextAlign.start,
    //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
    //       ),
    //     ),
    //   );
    // }
    return BubbleMessage(
      isDisable: false,
      isMyMessage: _messageController.isMyChat(chatMessage),
      messageWidget: Container(
        constraints: BoxConstraints(maxWidth: 300.w),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: RichText(
          text: TextSpan(
            //textAlign: TextAlign.start,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                text:
                    'You will answer some questions selected by your match Please choose one of your match languages to answer ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  fontFamily: 'Hellix',
                ),
              ),
              TextSpan(
                  text: '“app language or additional languages”',
                  style: TextStyle(
                      color: Colors.purple[200],
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Hellix',
                      fontSize: 16.sp)),
              TextSpan(
                text:
                    'You can\'t explore or like other profiles until you finish conversation',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  fontFamily: 'Hellix',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberWidget extends StatelessWidget {
  final ChatModel chatMessage;
  final bool isDisable;
  PhoneNumberWidget({
    Key? key,
    required this.chatMessage,
    required this.isDisable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);
    final NewChatController _messageController = Get.put(NewChatController());
    return BubbleMessage(
      isDisable: isDisable,
      isMyMessage: _messageController.isMyChat(chatMessage),
      messageWidget: Container(
        constraints: BoxConstraints(maxWidth: 300.w),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: RichText(
          text: TextSpan(
            //textAlign: TextAlign.start,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                text: 'She accepted your request Her phone number is ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  fontFamily: 'Hellix',
                ),
              ),
              TextSpan(
                  text: '${chatMessage.content}',
                  style: TextStyle(
                      color: Colors.purple[200],
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Hellix',
                      fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class RequestDateScheduleTextWidget extends StatelessWidget {
  final ChatModel chatMessage;
  final bool disable;
  RequestDateScheduleTextWidget({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);
    final NewChatController _messageController = Get.put(NewChatController());

    DateTime parseDate = DateTime.parse(chatMessage.content!);

    return Column(
      children: [
        BubbleMessage(
          isDisable: disable,
          isMyMessage: false,
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: RichText(
              text: TextSpan(
                //textAlign: TextAlign.start,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'Your match proposed this date to have a 5min video call on',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Hellix',
                    ),
                  ),
                  TextSpan(
                      text:
                          ' ${DateFormat.yMMMd().format(parseDate)} from ${DateFormat.jm().format(parseDate)} to ${DateFormat.jm().format(parseDate.add(Duration(minutes: 5)))}',
                      style: TextStyle(
                          color: Colors.purple[200],
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Hellix',
                          fontSize: 16)),
                  TextSpan(
                    text:
                        ' You have ${chatMessage.chatTime!.add(Duration(days: 2)).difference(DateTime.now()).inHours}hr from now to respond to his request',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Hellix',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        _messageController.requestForRescheduleFromFemale();
                      },
                child: BubbleMessage(
                    isDisable: disable,
                    messageWidget: Text(
                      'Reschedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true)),
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        _messageController
                            .callTimeAccepted(chatMessage.content!);
                      },
                child: BubbleMessage(
                    isDisable: disable,
                    messageWidget: Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true)),
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        _messageController
                            .endConversationFromFemale(chatMessage.content!);
                      },
                child: BubbleMessage(
                    isDisable: disable,
                    messageWidget: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true))
          ],
        ),
      ],
    );
  }
}

class CallNowWidget extends StatelessWidget {
  final ChatModel chatMessage;
  final bool disable;
  final User user;
  CallNowWidget({
    Key? key,
    required this.chatMessage,
    required this.disable,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleMessage(
          isDisable: disable,
          isMyMessage: false,
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Text(
              FixedConversation.itsTimeForVideoCallMale,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: disable
                    ? null
                    : () async {
                        ///For Agora Video call
                        // CallHelper.makeCall(context, userReceiver: user);
                        await CallHelper.makeCall(context, userReceiver: user);
                      },
                child: BubbleMessage(
                    isDisable: disable,
                    messageWidget: Text(
                      'Call',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true)),
          ],
        ),
      ],
    );
  }
}

class RequestForPhoneNumberMale extends StatelessWidget {
  final ChatModel chatMessage;
  final bool disable;
  RequestForPhoneNumberMale({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);
    final NewChatController _messageController = Get.put(NewChatController());
    return Column(
      children: [
        BubbleMessage(
          isDisable: disable,
          isMyMessage: false,
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Text(
              FixedConversation.requestPhoneNumberMale,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        _messageController.requestPhoneNumber();
                      },
                child: BubbleMessage(
                    isDisable: disable,
                    messageWidget: Text(
                      'Request her phone number',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true)),
          ],
        ),
      ],
    );
  }
}

class RequestForPhoneNumberFemale extends StatelessWidget {
  final ChatModel chatMessage;
  final bool disable;
  RequestForPhoneNumberFemale({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);
    final NewChatController _messageController = Get.put(NewChatController());
    return Column(
      children: [
        BubbleMessage(
          isDisable: disable,
          isMyMessage: false,
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Text(
              FixedConversation.requestPhoneNumberFemale,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        _messageController.endConversationFromFemaleAfterPhone(
                            chatMessage.content!);
                      },
                child: BubbleMessage(
                    isDisable: disable,
                    messageWidget: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true)),
          ],
        ),
      ],
    );
  }
}

class DateScheduleTextWidget extends StatelessWidget {
  final ChatModel chatMessage;
  final bool disable;
  DateScheduleTextWidget({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);
    final NewChatController _messageController = Get.put(NewChatController());
    DateTime parseDate = DateTime.parse(chatMessage.content!);

    return Column(
      children: [
        BubbleMessage(
          isDisable: disable,
          isMyMessage: false,
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: RichText(
              text: TextSpan(
                //textAlign: TextAlign.start,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                children: <TextSpan>[
                  TextSpan(
                    text: '5min video call is scheduled on',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Hellix',
                    ),
                  ),
                  TextSpan(
                      text:
                          ' ${DateFormat.yMMMd().format(parseDate)} from ${DateFormat.jm().format(parseDate)} to ${DateFormat.jm().format(parseDate.add(Duration(minutes: 5)))} ',
                      style: TextStyle(
                          color: Colors.purple[200],
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Hellix',
                          fontSize: 16)),
                  TextSpan(
                    text:
                        'When time comes your match is suppose to call you Time left',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Hellix',
                    ),
                  ),
                  TextSpan(
                      text:
                          '${parseDate.difference(DateTime.now()).inDays} days ${parseDate.difference(DateTime.now()).inHours % 24}hr ${parseDate.difference(DateTime.now()).inMinutes % 60}min ${parseDate.difference(DateTime.now()).inSeconds % 60}sec',
                      style: TextStyle(
                          color: Colors.purple[200],
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Hellix',
                          fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        _messageController.requestForRescheduleFromFemale();
                      },
                child: BubbleMessage(
                    isDisable: disable,
                    messageWidget: Text(
                      'Reschedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true)),
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        _messageController
                            .endConversationAfterDateScheduleFemaleCancel(
                                chatMessage.content!);
                      },
                child: BubbleMessage(
                    isDisable: disable,
                    messageWidget: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true))
          ],
        ),
      ],
    );
  }
}

class DateScheduleTextWidgetMale extends StatelessWidget {
  final ChatModel chatMessage;
  final bool disable;
  DateScheduleTextWidgetMale({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);
    final NewChatController _messageController = Get.put(NewChatController());
    DateTime parseDate = DateTime.parse(chatMessage.content!);

    return Column(
      children: [
        BubbleMessage(
          isDisable: disable,
          isMyMessage: false,
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: RichText(
              text: TextSpan(
                //textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  fontFamily: 'Hellix',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'Congratulations your match accepted the date 5min video call is scheduled on',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Hellix',
                    ),
                  ),
                  TextSpan(
                      text:
                          ' ${DateFormat.yMMMd().format(parseDate)} from ${DateFormat.jm().format(parseDate)} to ${DateFormat.jm().format(parseDate.add(Duration(minutes: 5)))} ',
                      style: TextStyle(
                          color: Colors.purple[200],
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Hellix',
                          fontSize: 16)),
                  TextSpan(
                    text:
                        'Congratulations your match accepted You’ll have the chance to request her phone number after the call When time comes a call button will appear to call her, Only you have the option to call Time left ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Hellix',
                    ),
                  ),
                  TextSpan(
                      text:
                          '${parseDate.difference(DateTime.now()).inDays} days ${parseDate.difference(DateTime.now()).inHours % 24}hr ${parseDate.difference(DateTime.now()).inMinutes % 60}min ${parseDate.difference(DateTime.now()).inSeconds % 60}sec',
                      style: TextStyle(
                          color: Colors.purple[200],
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Hellix',
                          fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        _messageController.requestForRescheduleFromMale();
                      },
                child: BubbleMessage(
                    isDisable: disable,
                    messageWidget: Text(
                      'Reschedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true)),
            InkWell(
                onTap: disable
                    ? null
                    : () {
                        _messageController
                            .rescheduleCAllCancel(chatMessage.content);
                      },
                child: BubbleMessage(
                    isDisable: disable,
                    messageWidget: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontFamily: 'Hellix',
                      ),
                    ),
                    isMyMessage: true))
          ],
        ),
      ],
    );
  }
}

class RescheduleCallWidgetMale extends StatelessWidget {
  final ChatModel chatMessage;
  final bool disable;
  RescheduleCallWidgetMale({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);
    return BubbleMessage(
      isDisable: disable,
      isMyMessage: false,
      messageWidget: Container(
        constraints: BoxConstraints(maxWidth: 300.w),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Text(
          'Your match is notified to reschedule the date. This conversation will end if your match don’t respond to this request within 48hr from now',
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

class RescheduleCallWidgetFemale extends StatelessWidget {
  final ChatModel chatMessage;
  final bool disable;
  RescheduleCallWidgetFemale({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);
    return BubbleMessage(
      isMyMessage: false,
      isDisable: disable,
      messageWidget: Container(
        constraints: BoxConstraints(maxWidth: 300.w),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Text(
          'Your match is notified to reschedule the date. This conversation will end if your match don’t respond to this request within 48hr from now',
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

class RescheduleCallWidgetMaleText extends StatelessWidget {
  final ChatModel chatMessage;
  final bool disable;
  RescheduleCallWidgetMaleText({
    Key? key,
    required this.chatMessage,
    required this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);

    return Column(
      children: [
        BubbleMessage(
          isDisable: disable,
          isMyMessage: false,
          messageWidget: Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Text(
              'Your match is notified with the new date This conversation will end if your match don’t respond to this request within 48hr from now',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReviewAndAcceptWidget extends StatelessWidget {
  final ChatMessage2 chatMessage;
  ReviewAndAcceptWidget({
    Key? key,
    required this.chatMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLocalizations _i18n = AppLocalizations.of(context);
    final MessageController _messageController = Get.put(MessageController());
    if (_messageController.isThisMyMessage(chatMessage)) {
      return BubbleMessage(
        isDisable: false,
        isMyMessage: false,
        messageWidget: Container(
          constraints: BoxConstraints(maxWidth: 300.w),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Text(
            'Congratulations you’ve got a match',
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
    return BubbleMessage(
      isMyMessage: _messageController.isThisMyMessage(chatMessage),
      messageWidget: Container(
        constraints: BoxConstraints(maxWidth: 300.w),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: RichText(
          text: TextSpan(
            //textAlign: TextAlign.start,
            style: _messageController.messagesTextStyle,
            children: <TextSpan>[
              TextSpan(
                text:
                    'You will answer some questions selected by your match Please choose one of your match languages to answer ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  fontFamily: 'Hellix',
                ),
              ),
              TextSpan(
                  text: '“app language or additional languages”',
                  style: TextStyle(
                      color: Colors.purple[200],
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Hellix',
                      fontSize: 16)),
              TextSpan(
                text:
                    'You can\'t explore or like other profiles until you finish conversation',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  fontFamily: 'Hellix',
                ),
              ),
            ],
          ),
        ),
      ),
      isDisable: false,
    );
  }
}
