import 'package:flutter/material.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({super.key});

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
            color: Color(0xFF573894),
            borderRadius: BorderRadius.circular(9),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
          ),
          child: Column(
            children: [
              Text(
                "Your message will show here",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "09:43 AM",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.done_all, color: Colors.grey, size: 13),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
