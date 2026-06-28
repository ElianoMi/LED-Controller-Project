import 'connected_page.dart';
import 'more_actions_page.dart';
import 'package:flutter/material.dart';

class ConnectedWrapper extends StatelessWidget {
  const ConnectedWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (index) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      children: const [
        MyAppPage(),
        MyNotAppPage(),
      ],
    );
  }
}