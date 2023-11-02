import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeveloperInfo extends StatelessWidget {
  final String name;
  final String email;
  final String githubUrl;

  const DeveloperInfo({
    Key? key,
    required this.name,
    required this.email,
    required this.githubUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                name,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.email),
              onPressed: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: email,
                  queryParameters: {'subject': 'About BTD6 Wiki'},
                );
                if (!await launchUrl(emailLaunchUri)) {
                  throw 'Could not launch $emailLaunchUri';
                }
              },
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              onPressed: () async {
                final Uri url = Uri.parse(githubUrl);
                if (!await launchUrl(url)) {
                  throw 'Could not launch $url';
                }
              },
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.linkedin),
              onPressed: () async {
                final Uri url = Uri.parse(githubUrl);
                if (!await launchUrl(url)) {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
