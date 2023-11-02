import 'package:btd6wiki/presentation/widgets/developer_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/utils.dart';

class AboutUsPopup extends StatelessWidget {
  const AboutUsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AboutUs();
          },
        );
      },
      child: const Text('About Us'),
    );
  }
}

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'About Us',
        textAlign: TextAlign.center,
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'Playfulsols@gamil.com',
                  query: encodeQueryParameters({'subject': 'About BTD6 Wiki'}),
                );
                if (!await launchUrl(emailLaunchUri)) {
                  throw 'Could not launch $emailLaunchUri';
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.email), Text('  Contact Us')],
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'This app is made with love by:',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const DeveloperInfo(
              name: 'Asaf Hadad',
              email: 'asaf147369@gmail.com',
              githubUrl: 'https://github.com/asaf147369',
            ),
            const DeveloperInfo(
              name: 'Shai Holczer',
              email: 'Shaitnto@gmail.com',
              githubUrl: 'https://github.com/namelessto',
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.github),
              title: Text(
                'To Our GitHub',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                final Uri url = Uri.parse(
                    'https://github.com/PlayfulSol/flutter-btd6-wiki');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
          ]),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
