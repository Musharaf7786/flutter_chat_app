import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  int index;

  ChatItem(this.index, {super.key});

  bool left = false;

  @override
  Widget build(BuildContext context) {
    if (index % 2 == 0) {
      left = true;
    } else {
      left = false;
    }
    return Row(
      mainAxisAlignment: left ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: left ? Colors.black12 : Color(0xFF573894),
            borderRadius: BorderRadius.circular(30),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
          ),
          child: Column(
            crossAxisAlignment:
                left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                "Your message will show here",
                style: TextStyle(
                  color: left ? Colors.black : Colors.white,
                  fontSize: 12,
                ),
              ),
              left
                  ? Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "09:43 AM",
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "09:43 AM",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.done_all, color: Colors.grey, size: 13),
                    ],
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
