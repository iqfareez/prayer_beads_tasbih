import 'package:url_launcher/url_launcher.dart';

/// Function to launch URL
/// [url] is the URL to be launched
void launchURL(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
