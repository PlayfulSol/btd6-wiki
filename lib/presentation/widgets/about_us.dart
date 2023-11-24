import '/presentation/widgets/developer_info.dart';
import '/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utilities/utils.dart';

class AboutUsPopup extends StatelessWidget {
  const AboutUsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.teal),
      ),
      onPressed: () {
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
      title: const Text(
        'About Us',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: bigTitleStyle,
      contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal),
            ),
            onPressed: () => openMail('Playfulsols@gamil.com'),
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal),
            ),
            onPressed: () =>
                openUrl('https://github.com/PlayfulSol/flutter-btd6-wiki'),
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
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.teal),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
