import 'package:flutter/material.dart';

class Breadcrumbs extends StatelessWidget {
  final List<String> breadCrumbs;
  final Function(int index)
      onBreadcrumbTap; // Callback for tapping a breadcrumb

  const Breadcrumbs({required this.breadCrumbs, required this.onBreadcrumbTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.home,
            color: Colors.deepPurple,
          ),
          for (int i = 0; i < breadCrumbs.length; i++)
            Row(
              children: [
                TextButton(
                  onPressed: () => onBreadcrumbTap(i),
                  child: Text(
                    breadCrumbs[i],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (i < breadCrumbs.length - 1) Icon(Icons.chevron_right),
              ],
            ),
        ],
      ),
    );
  }
}
