import 'package:flutter/material.dart';
import 'package:main_jobs/screens/user.dart';

class FetchScreen extends StatefulWidget {
  static const routeName = '/FetchScreen';

  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData.fallback(),
      ),
      drawer: UserScreen(),
      body: Container(
        color: Colors.white,
        child: Text(
          'Home screen',
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
