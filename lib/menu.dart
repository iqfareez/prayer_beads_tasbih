import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatelessWidget {
  const Menu({Key key}) : super(key: key);
  final menuButtonTextStyle = const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMenuButton(
              name: 'GitHub',
              icon: Icons.code,
              action: () {
                _launchURL('http://github.com/iqfareez/prayer_beads_tasbih');
                // i use http here to avoid error:
                // component name for https://github.com/iqfareez/prayer_beads_tasbih is null
              }),
          const Divider(color: Colors.white54),
          !kIsWeb
              ? buildMenuButton(
                  name: 'Try on web',
                  icon: Icons.web_asset,
                  action: () {
                    _launchURL('https://online-tasbeeh.web.app/');
                  })
              : buildMenuButton(
                  name: 'Get the app',
                  icon: Icons.android,
                  action: () {
                    _launchURL(
                        'https://play.google.com/store/apps/details?id=com.iqfareez.prayer_beads');
                  }),
          const Divider(color: Colors.white54),
          buildMenuButton(
              name: 'Share this app',
              icon: Icons.share,
              action: () {
                Share.share(
                    'I use Tasbeeh app in my daily life. Download it now on Google Play Store: http://bit.ly/3aEgsQS or access it on the web https://online-tasbeeh.web.app/',
                    subject: 'Sharing Tasbeeh app');
              }),
          !kIsWeb
              ? TextButton.icon(
                  icon: const Icon(
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
                )
              : const SizedBox.shrink(),
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
