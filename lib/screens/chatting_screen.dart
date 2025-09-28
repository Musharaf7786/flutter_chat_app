import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/room_model.dart';
import 'package:flutter_chat_app/widgets/chat_item.dart';

class ChattingScreen extends StatelessWidget {
  final RoomModel roomModel;

  ChattingScreen(this.roomModel, {super.key});

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF573894),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("User", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ChatItem(index);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: TextField(
                      buildCounter: (
                        BuildContext context, {
                        int? currentLength,
                        bool? isFocused,
                        int? maxLength,
                      }) {
                        return null;
                      },

                      controller: messageController,
                      keyboardType: TextInputType.multiline,

                      decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.attach_file,
                                color: Color(0xFF573894),
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                color: Color(0xFF573894),
                                size: 30,
                              ),
                            ),
                          ],
                        ),

                        label: Text("Enter message"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Color(0xFF573894),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Color(0xFF573894),
                            width: 2,
                          ),
                        ),
                        errorMaxLines: 2,
                      ),
                      maxLines: null,
                      minLines: 1,
                    ),
                  ),
                  // SizedBox(width: 2,),
                  Expanded(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        color: Color(0xFF573894),
                        size: 28,
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
  }
}
