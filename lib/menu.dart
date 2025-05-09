import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Drawer items
class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/tasbih-cover-photo.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox.shrink(),
        ),
        ListTile(
          leading: const Icon(Icons.code),
          title: const Text('GitHub'),
          onTap: () {
            _launchURL('http://github.com/iqfareez/prayer_beads_tasbih');
          },
        ),
        const Divider(),
        !kIsWeb
            ? ListTile(
              leading: const Icon(Icons.web),
              title: const Text('Try on web'),
              onTap: () {
                _launchURL('https://online-tasbeeh.web.app/');
              },
            )
            : ListTile(
              leading: const Icon(Icons.android),
              title: const Text('Get the app'),
              onTap: () {
                _launchURL(
                  'https://play.google.com/store/apps/details?id=com.iqfareez.prayer_beads',
                );
              },
            ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share this app'),
          onTap: () {
            SharePlus.instance.share(
              ShareParams(
                text:
                    'I use Tasbeeh app in my daily life. Download it now on Google Play Store: http://bit.ly/3aEgsQS or access it on the web https://online-tasbeeh.web.app/',
                subject: 'Sharing Tasbeeh app',
              ),
            );
          },
        ),
        !kIsWeb
            ? ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text('Rate this app'),
              onTap: () {
                _launchURL(
                  'https://play.google.com/store/apps/details?id=com.iqfareez.prayer_beads',
                );
              },
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}

/// Function to launch URL
/// [url] is the URL to be launched
void _launchURL(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
