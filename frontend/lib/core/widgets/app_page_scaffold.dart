import 'package:flutter/material.dart';

class AppPageScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Future<void> Function()? onFabPressed;

  const AppPageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: child,
      floatingActionButton: onFabPressed == null
          ? null
          : FloatingActionButton(
              onPressed: onFabPressed,
              child: const Icon(Icons.add),
            ),
    );
  }
}
