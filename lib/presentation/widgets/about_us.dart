import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '/analytics/analytics.dart';
import '/presentation/widgets/developer_info.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class AboutUsPopup extends StatelessWidget {
  const AboutUsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        logEvent('about_us', 'opened');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AboutUs();
          },
        );
      },
      icon: const FaIcon(FontAwesomeIcons.circleInfo),
      label: const Text('About Us'),
    );
  }
}

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        'About Us',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      titleTextStyle: bigTitleStyle,
      contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => {
              logEvent('contact_us', 'opened'),
              openMail('Playfulsols@gamil.com'),
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email),
                SizedBox(width: 7),
                Text(
                  'Contact Us',
                  style: normalStyle,
                )
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => {
              logEvent('github', 'opened'),
              openUrl('https://github.com/PlayfulSol/flutter-btd6-wiki'),
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(FontAwesomeIcons.github),
                SizedBox(width: 7),
                Text(
                  'To Our GitHub',
                  style: normalStyle,
                )
              ],
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
            linkedinUrl: 'https://www.linkedin.com/in/asaf-hadad/',
          ),
          const DeveloperInfo(
            name: 'Shai Holczer',
            email: 'Shaitnto@gmail.com',
            githubUrl: 'https://github.com/namelessto',
            linkedinUrl: 'https://www.linkedin.com/in/shai-holczer/',
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            logEvent('about_us', 'closed');
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
          ),
        ),
      ],
    );
  }
}
