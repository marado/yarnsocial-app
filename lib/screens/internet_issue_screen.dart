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
      backgroundColor: Color(0xff1F2B38),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                    "assets/icon/yarn_front_1024.png",
                  ),
                  width: 150,
                ),
                Text(
                  "Connection Error!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Oops! There seems to be some issue with your internet connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
