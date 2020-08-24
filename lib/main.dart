import 'package:flutter/material.dart';
import 'package:little_hero/sub.dart';
import 'package:little_hero/noti.dart';
import 'package:little_hero/gridMain.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //페이지 연결 라우팅 형식
      initialRoute: '/',
      routes: {
        '/': (context) => new routes(),
        '/gridMain': (context) => new gridMain(),
        '/noti': (context) => new noti(),
        '/sub': (context) => new sub(),
      },
    );
  }

}

class routes extends StatefulWidget {
  @override
  _Routes createState() => _Routes();

}

class _Routes extends State<routes> {
  @override

  void initState(){
    super.initState();
    Timer(Duration(seconds: 1), () => Navigator.of(context).pushReplacementNamed('/gridMain'));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,

      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
          decoration: BoxDecoration(
            color:Colors.lightBlueAccent
          ),
        ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex:2,
                child: Container(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: Icon(
                            Icons.adb,
                            color: Colors.greenAccent,
                            size:50.0,
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:10.0),
                        ),
                        Text(
                          "LITTLE HERO",
                          style:TextStyle(
                            color: Colors.white,
                            fontSize:24.0,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                ),
              ),
              Expanded(
                flex:1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(padding: EdgeInsets.only(top:20.0),),
                    Text('들어가는 중',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
