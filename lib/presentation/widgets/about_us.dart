import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '/presentation/widgets/developer_info.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class AboutUsPopup extends StatelessWidget {
  const AboutUsPopup({
    super.key,
    required this.analyticsHelper,
  });

  final AnalyticsHelper analyticsHelper;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        analyticsHelper.logEvent(
          name: buttonPress,
          parameters: {
            'screen': drawer,
            'button': aboutUsButton,
            'value': buttonOpen,
          },
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AboutUs(analyticsHelper: analyticsHelper);
          },
        );
      },
      icon: const FaIcon(FontAwesomeIcons.circleInfo),
      label: const Text('About Us'),
    );
  }
}

class AboutUs extends StatelessWidget {
  const AboutUs({
    super.key,
    required this.analyticsHelper,
  });
  final AnalyticsHelper analyticsHelper;

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
            onPressed: () {
              analyticsHelper.logEvent(
                name: buttonPress,
                parameters: {
                  'screen': aboutUs,
                  'button': '${email}_playful',
                  'value': buttonOpen,
                },
              );
              openMail(playfulEmail);
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
            onPressed: () {
              analyticsHelper.logEvent(
                name: buttonPress,
                parameters: {
                  'screen': aboutUs,
                  'button': gitRepo,
                  'value': buttonOpen,
                },
              );
              openUrl(playfulGitRepo);
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
          DeveloperInfo(
            analyticsHelper: analyticsHelper,
            name: asaf[name]!,
            email: asaf[email]!,
            githubUrl: asaf[git]!,
            linkedinUrl: asaf[linkedin]!,
          ),
          DeveloperInfo(
            analyticsHelper: analyticsHelper,
            name: shai[name]!,
            email: shai[email]!,
            githubUrl: shai[git]!,
            linkedinUrl: shai[linkedin]!,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            analyticsHelper.logEvent(
              name: buttonPress,
              parameters: {
                'screen': aboutUs,
                'button': aboutUsButton,
                'value': buttonClose,
              },
            );
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
