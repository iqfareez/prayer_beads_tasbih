import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var menuButtonTextStyle = TextStyle(color: Colors.white);
    return Container(
      padding: const EdgeInsets.all(8.0),
      // color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.code,
                color: Colors.white,
              ),
              label: Text(
                'GitHub',
                style: menuButtonTextStyle,
              )),
          Divider(
            color: Colors.white54,
          ),
          TextButton.icon(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {},
            label: Text(
              'Share this app',
              style: menuButtonTextStyle,
            ),
          ),
          TextButton.icon(
            icon: Icon(
              Icons.rate_review,
              color: Colors.white,
            ),
            onPressed: () {},
            label: Text(
              'Rate this app',
              style: menuButtonTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
