import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class DeveloperInfo extends StatelessWidget {
  final String name;
  final String email;
  final String githubUrl;
  final String linkedinUrl;
  final AnalyticsHelper analyticsHelper;

  const DeveloperInfo({
    super.key,
    required this.name,
    required this.email,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.analyticsHelper,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
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
                style: bolderNormalStyle.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.email),
                onPressed: () {
                  analyticsHelper.logEvent(
                    name: buttonPress,
                    parameters: {
                      'screen': aboutUs,
                      'button': '${email}_$name',
                      'value': buttonOpen,
                    },
                  );
                  openMail(email);
                },
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.github),
                onPressed: () {
                  analyticsHelper.logEvent(
                    name: buttonPress,
                    parameters: {
                      'screen': aboutUs,
                      'button': '${gitRepo}_$name',
                      'value': buttonOpen,
                    },
                  );
                  openUrl(githubUrl);
                },
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.linkedin),
                onPressed: () {
                  analyticsHelper.logEvent(
                    name: buttonPress,
                    parameters: {
                      'screen': aboutUs,
                      'button': '${linkedin}_$name',
                      'value': buttonOpen,
                    },
                  );
                  openUrl(linkedinUrl);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
