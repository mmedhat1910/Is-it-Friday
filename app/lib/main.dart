import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final now = new DateTime.now();
  int count = 0;
  final friday = 5;
  bool isLoading = false;
  bool clicked = false;

  @override
  void initState() {
    super.initState();
    getCount();
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not lauunch $url';
    }
  }

  void getCount() async {
    isLoading = true;
    var resposne = await http.get('http://127.0.0.1:3000/count');
    var data = convert.jsonDecode(resposne.body)[0];
    print(data['count']);
    setState(() {
      count = data['count'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int today = now.weekday;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff22232E),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                Icons.info_outline,
                color: Color(0xff6C8BF5),
                size: 30,
              ),
              onPressed: () {
                launchURL('https://github.com/mmedhat1910/Friday');
              },
            ),
          )
        ],
      ),
      backgroundColor: Color(0xff22232E),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  getCount();
                  setState(() {
                    clicked = true;
                  });
                },
                child: Center(
                  child: Text(
                    'Is It Friday?',
                    style: TextStyle(color: Color(0xff6C8BF5), fontSize: 35),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: !clicked
                    ? Container()
                    : Text(
                        today == friday ? 'Yes' : 'No',
                        style: TextStyle(fontSize: 25),
                      ),
              ),
            ),
            Expanded(
                child: Text(
              isLoading ? 'World Count: ' : 'World Count: $count',
              style: TextStyle(fontSize: 18),
            ))
          ],
        ),
      )),
    );
  }
}
