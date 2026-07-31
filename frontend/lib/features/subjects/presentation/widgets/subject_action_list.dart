import 'package:flutter/material.dart';

class SubjectActionList extends StatelessWidget {
  final List<Widget> children;
  const SubjectActionList({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          children[i],
          if (i != children.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}
