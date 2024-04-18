import 'package:flutter/material.dart';

class Breadcrumbs extends StatelessWidget {
  final List<String> breadCrumbs;
  final Function(int index)
      onBreadcrumbTap; // Callback for tapping a breadcrumb

  const Breadcrumbs({required this.breadCrumbs, required this.onBreadcrumbTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: Wrap(
        runSpacing: -20,
        spacing: -10,
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        children: [
          Container(
            height: 48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),
          for (int i = 0; i < breadCrumbs.length; i++)
            TextButton(
              onPressed: () => onBreadcrumbTap(i),
              child: Text(
                breadCrumbs[i] + "${i < breadCrumbs.length - 1 ? "   >" : ""}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          // if (i < breadCrumbs.length - 1) Icon(Icons.chevron_right)
        ],
      ),
    );
  }
}
