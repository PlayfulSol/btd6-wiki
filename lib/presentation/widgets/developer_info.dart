import 'package:btd6wiki/utilities/analytics.dart';

import '/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utilities/utils.dart';

class DeveloperInfo extends StatelessWidget {
  final String name;
  final String email;
  final String githubUrl;
  final String linkedinUrl;

  const DeveloperInfo({
    super.key,
    required this.name,
    required this.email,
    required this.githubUrl,
    required this.linkedinUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white38,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 4,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: normalStyle,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.email),
                onPressed: () =>
                    {logEvent('email_personal', name), openMail(email)},
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.github),
                onPressed: () =>
                    {logEvent('github_personal', name), openUrl(githubUrl)},
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.linkedin),
                onPressed: () =>
                    {logEvent('linkedin_personal', name), openUrl(linkedinUrl)},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
