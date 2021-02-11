import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatelessWidget {
  final menuButtonTextStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      // color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMenuButton(
              name: 'GitHub',
              icon: Icons.code,
              action: () {
                _launchURL('https://github.com/iqfareez/prayer_beads_tasbih');
              }),
          Divider(
            color: Colors.white54,
          ),
          buildMenuButton(
              name: 'Share this app',
              icon: Icons.share,
              action: () {
                Share.share(
                    'I use Tasbeeh app in my daily life. Download it now on Google Play Store: bit.ly/3aEgsQS');
              }),
          TextButton.icon(
            icon: Icon(
              Icons.rate_review,
              color: Colors.white,
            ),
            onPressed: () {
              _launchURL(
                  'https://play.google.com/store/apps/details?id=com.iqfareez.prayer_beads');
            },
            label: Text(
              'Rate this app',
              style: menuButtonTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  TextButton buildMenuButton(
      {@required String name,
      @required IconData icon,
      @required Function action}) {
    return TextButton.icon(
      onPressed: action,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        name,
        style: menuButtonTextStyle,
      ),
    );
  }
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
