import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utilities/utils.dart';

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
            Flexible(
              flex: 3,
              child: Text(
                name,
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.email),
                onPressed: () => openMail(email),
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.github),
                onPressed: () => openUrl(githubUrl),
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.linkedin),
                onPressed: () => openUrl(githubUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
