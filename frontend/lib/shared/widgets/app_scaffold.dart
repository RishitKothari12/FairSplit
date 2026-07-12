import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? title;

  final Widget? floatingActionButton;
  final FloatingActionButtonLocation?
      floatingActionButtonLocation;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    required this.child,
    this.title,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
            )
          : null,
      body: child,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation:
          floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}