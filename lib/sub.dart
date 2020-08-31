import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:little_hero/noti.dart';
import 'package:little_hero/favorite.dart';
import 'dart:async' show Future;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:little_hero/db.dart';


class detailGet {
  final int id;
  final String created_at;
  final int regist_no;
  final String url;
  final String title;
  final String text;
  final String do_date_extra;
  final String domain;
  final String address_remainder;
  detailGet(
      {this.id,
      this.created_at,
      this.regist_no,
      this.url,
      this.title,
      this.text,
      this.do_date_extra,
      this.domain,
      this.address_remainder});

  factory detailGet.fromJSON(Map<String, dynamic> json) {
    return detailGet(
        id: json['id'],
        created_at: json['created_at'],
        regist_no: json['regist_no'],
        url: json['url'],
        title: json['title'],
        do_date_extra: json['do_date_extra'],
        text: json['text'],
      domain:json['domain'],
        address_remainder:json['address_remainder'],
    );
  }
}

class sub extends StatefulWidget {
  final Noti noti;

  sub({Key key, this.noti}) : super(key: key);

  _Sub createState() => _Sub(noti);
}

class _Sub extends State<sub> {
  @override
  List<detailGet> _detail = []; // detail

  Noti noti; // navigation results 얻어온 값
  _Sub(this.noti);

  String registNo = '';

  void _detailGets() async {
    var get = await http.get(
        'http://54.180.31.78:8000/api/posts/detail?registNo=' +
            registNo +
            '&siteDomain=');

    final List<detailGet> parsedGet1 = jsonDecode(utf8.decode(get.bodyBytes))
        .map<detailGet>((json) => detailGet.fromJSON(json))
        .toList();
    setState(() {
      _detail.clear();
      _detail.addAll(parsedGet1);
    });
  }


  void initState() {
    super.initState();
    _detailGets();
  }

  String detailNoti = '';
  String do_date_extra = '';    //봉사일시
  String domain = '';
  String address_remainder = '';
  int regist_no = 0;
  Widget build(BuildContext context) {
    noti = ModalRoute.of(context).settings.arguments;

    final size = MediaQuery.of(context).size;

    for (int i = 0; i < _detail.length; i++) {
      if (noti.regist_no == _detail[i].regist_no) {
        detailNoti = _detail[i].text;
        do_date_extra = _detail[i].do_date_extra;
        domain = _detail[i].domain;
        address_remainder = _detail[i].address_remainder;
        regist_no = _detail[i].regist_no;
      }

    }
    bool state = false;

    _btnClicked() {
      if(state == false){
        state = true;
        DBHelper().insert(regist_no);
      }
      else if(state == true){
        state = false;
        DBHelper().delete(regist_no);
      }
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.star_border,
              color: Colors.white,
            ),
            onPressed: (){
              setState(() {

                _btnClicked();
              });
            },
          ),
          SizedBox(
            width: size.width * 0.02,
          )
        ],
      ),
      body: new SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: size.height * 0.17),
                padding: EdgeInsets.only(
                  top: size.height * 0.04,
                  left: size.width * 0.05,
                  right: size.width * 0.05,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    )),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: '지역\n',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: '  ' + noti.address_city,
                                  ),
                                ]),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: '구\n',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: '   ' + noti.address_gu ,
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: '상세 내용\n',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: detailNoti,
                            ),
                          ]),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: '봉사 장소\n',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: address_remainder ,
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: '봉사 일시\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: do_date_extra ,
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: '분류\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: domain,
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: '봉사 센터\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: domain,
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      noti.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Spacer(),
                        /*Text(
                          noti.start_date + ' ~ ' + noti.end_date,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        */
                        /*
                        Spacer(flex: 3),
                        Text(
                          '모집중',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(2.5),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.greenAccent,
                              )),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        */
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
