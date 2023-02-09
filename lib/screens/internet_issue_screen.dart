import 'package:flutter/material.dart';

class InternetIssueScreen extends StatefulWidget {
  const InternetIssueScreen({Key? key}) : super(key: key);

  @override
  State<InternetIssueScreen> createState() => _InternetIssueScreenState();
}

class _InternetIssueScreenState extends State<InternetIssueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text("NO INTERNET"),
        ),
      ),
    );
  }
}
