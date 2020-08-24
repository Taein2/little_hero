import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:sqflite/sqflite.dart';
import 'dart:async' show Future, StreamController, StreamSink;
import 'package:http/http.dart' as http;
import 'dart:convert';


class Get {

  final int count;
  final String previous;
  final String next;
  final List<Noti> results;


  Get({
    this.count,
    this.previous,
    this.next,
    this.results,
  });

  factory Get.fromJSON(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Noti> notiList = list.map((i) => Noti.fromJSON(i)).toList();

    return Get(
      count: json['count'],
      previous: json['previous'],
      next: json['next'],
      results: notiList,
    );
  }
}

class Noti {
  final int regist_no;
  final String title;
  final String address_city;
  final String address_gu;
  final bool recruit_status;
  final bool adult_status;
  final String start_date;
  final String end_date;

  Noti({
    this.regist_no,
    this.title,
    this.address_city,
    this.address_gu,
    this.recruit_status,
    this.adult_status,
    this.end_date,
    this.start_date,
  });

  factory Noti.fromJSON(Map<String, dynamic> json) {
    return Noti(
      regist_no: json['regist_no'],
      title: json['title'],
      address_city: json['address_city'],
      address_gu: json['address_gu'],
      recruit_status: json['recruit_status'],
      adult_status: json['adult_status'],
      start_date: json['start_date'],
      end_date: json['end_date'],
    );
  }
}

class dropGet {
  final int id;
  final String city;

  dropGet({
    this.id,
    this.city,
  });

  factory dropGet.fromJSON(Map<String, dynamic> json) {
    return dropGet(
        id: json['id'],
        city: json['city']
    );
  }
}

class dropGet2 {
  final int id;
  final String city;
  final String gu;

  dropGet2({
    this.id,
    this.city,
    this.gu,
  });

  factory dropGet2.fromJSON(Map<String, dynamic> json) {
    return dropGet2(
      id: json['id'],
      city: json['city'],
      gu: json['gu'],
    );
  }
}

class dropGet3 {
  final String li;

  dropGet3({
    this.li,
  });

  factory dropGet3.fromJSON(Map<String, dynamic> json) {
    return dropGet3(
      li: json['li'],
    );
  }
}

class noti extends StatefulWidget {
  _noti createState() => _noti();
}

class _noti extends State<noti> {
  StreamController<List<Noti>> _listNoti;
  List<Get> _listGet =[];

  List<dropGet> _dropItem = [];
  List<dropGet2> _dropItem2 = [];
  List<dropGet2> _dropItem2_1 = [];
  List<dropGet3> _dropItem3 = [];
  List<dropGet3> _dropItem4 = [];

  String _selectedValue1 = '';
  String _selectedValue2 = '';
  String _selectedValue3 = '';
  String _selectedValue4 = '';

  //search
  int page_size = 1;
  String address_city = '';
  String address_gu = '';
  String recruitStatus = '';
  String adultStatus = '';
  String startDate = '';
  String endDate = '';
  String searchData = '';

  Future<List<Noti>> _fetchGets() async {
    var get = await http.get(
        'http://ec2-15-164-213-200.ap-northeast-2.compute.amazonaws.com:8000/api/posts/all?page_size=' + page_size.toString() + '&addressCity=' + address_city +
            '&addressGu= ' + address_gu + '&recruitStatus=' + recruitStatus +
            '&adultStatus=' + adultStatus + '&startDate=' + startDate +
            '&endDate=' + endDate + '&search=' + searchData + '&like=');


    if (get.statusCode == 200) { //통신 성공
      var r1 = json.decode(utf8.decode(get.bodyBytes));
      Get r = new Get.fromJSON(r1);
      _listGet.add(r);
      return r.results;
    }
  }


  void _dropGets() async {
    var get = await http.get(
        'http://ec2-15-164-213-200.ap-northeast-2.compute.amazonaws.com:8000/api/cities/list');

    final List<dropGet> parsedGet1 = jsonDecode(utf8.decode(get.bodyBytes))
        .map<dropGet>((json) => dropGet.fromJSON(json))
        .toList();
    setState(() {
      _dropItem.clear();
      _dropItem.addAll(parsedGet1);
      _selectedValue1 = _dropItem[0].city;
    });
  }

  void _dropGets2() async {
    var get = await http.get(
        'http://ec2-15-164-213-200.ap-northeast-2.compute.amazonaws.com:8000/api/cities/detail');
    final List<dropGet2> parsedGet2 = jsonDecode(utf8.decode(get.bodyBytes))
        .map<dropGet2>((json) => dropGet2.fromJSON(json))
        .toList();
    setState(() {
      _dropItem2.clear();
      _dropItem2.addAll(parsedGet2);
      for (int i = 0; i < _dropItem2.length; i++) {
        if ('서울특별시' == _dropItem2[i].city) {
          _dropItem2_1.add(_dropItem2[i]);
          _selectedValue2 = _dropItem2_1[0].gu;
        }
      }
    });
  }

  void _dropGets3() async {
    var get = await http.get(
        'http://ec2-15-164-213-200.ap-northeast-2.compute.amazonaws.com:8000/api/posts/dropdown?kinds=%EB%8C%80%EC%83%81');
    final List<dropGet3> parsedGet3 = jsonDecode(utf8.decode(get.bodyBytes))
        .map<dropGet3>((json) => dropGet3.fromJSON(json))
        .toList();
    setState(() {
      _dropItem3.clear();
      _dropItem3.addAll(parsedGet3);
      _selectedValue3 = _dropItem3[0].li;
    });
  }


  void _dropGets4() async {
    var get = await http.get(
        'http://ec2-15-164-213-200.ap-northeast-2.compute.amazonaws.com:8000/api/posts/dropdown?kinds=%EC%83%81%ED%83%9C');
    final List<dropGet3> parsedGet4 = jsonDecode(utf8.decode(get.bodyBytes))
        .map<dropGet3>((json) => dropGet3.fromJSON(json))
        .toList();
    setState(() {
      _dropItem4.clear();
      _dropItem4.addAll(parsedGet4);
      _selectedValue4 = _dropItem4[0].li;
    });
  }


  void initState() {
    super.initState();
    _listNoti = new StreamController<List<Noti>>();
    loadData();
    _dropGets(); //시
    _dropGets2(); //구
    _dropGets3(); //모집대상
    _dropGets4(); //모집상태
  }

  void loadData() async {
    _fetchGets().then((res) async {
      _listNoti.add(res);
      return res;
    });
  }
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  showSnack() {
    return scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('New content loaded'),
      ),
    );
  }

  Future <List<Noti>> refresh() async{
    page_size++;
    _fetchGets().then((res) async{
      _listNoti.add(res);
      showSnack();
      return res;

    });
  }

  Widget build(BuildContext context) {
    final _searchData_T = TextEditingController(text: '');
    final _screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      key: scaffoldKey,
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
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('모집 공고',
                    style:Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              Container(

                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            new DropdownButton(
                              value: _selectedValue1,
                              items: _dropItem.map((item) {
                                return new DropdownMenuItem<String>(
                                  value: item.city,
                                  child: new Text(
                                    item.city,
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 17),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedValue1 = newValue;
                                  _dropItem2_1.clear();
                                  for (int i = 0; i < _dropItem2.length; i++) {
                                    if (_selectedValue1 == _dropItem2[i].city) {
                                      _dropItem2_1.add(_dropItem2[i]);
                                      _selectedValue2 = _dropItem2_1[0].gu;
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              DropdownButton(
                                value: _selectedValue2,
                                items: _dropItem2_1.map((item) {
                                  return new DropdownMenuItem<String>(
                                    value: item.gu,
                                    child: Text(item.gu,
                                      style: TextStyle(color: Colors.black,
                                          fontSize: 17),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedValue2 = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            DropdownButton(
                              value: _selectedValue3,
                              items: _dropItem3.map((item) {
                                return new DropdownMenuItem<String>(
                                  value: item.li,
                                  child: Text(item.li,
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 17),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedValue3 = newValue;
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            DropdownButton(
                              value: _selectedValue4,
                              items: _dropItem4.map((item) {
                                return DropdownMenuItem(
                                  value: item.li,
                                  child: Text(item.li,
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 17),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedValue4 = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: _screenSize.width * 0.7,
                          child: TextFormField(
                            decoration: new InputDecoration.collapsed(
                            ),
                            controller: _searchData_T,
                            style: TextStyle(
                              color:Colors.white,
                              fontSize: 18
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            address_city = _selectedValue1;
                            address_gu = _selectedValue2;
                            if (_selectedValue3 == '성인') {
                              adultStatus = 'true';
                            }
                            else if (_selectedValue3 == '청소년') {
                              adultStatus = 'false';
                            }
                            else {
                              adultStatus = '';
                            }
                            if (_selectedValue4 == '모집중') {
                              recruitStatus = 'true';
                            }
                            else if (_selectedValue4 == '모집완료') {
                              recruitStatus = 'false';
                            }
                            else {
                              adultStatus = '';
                            }
                            if (_searchData_T.text != '') {
                              searchData = _searchData_T.text.toString();
                            } else {
                              searchData = '';
                            }
                            page_size=1;
                            _fetchGets();
                            loadData();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    )),

                child: new StreamBuilder<List<Noti>>(
                  stream: _listNoti.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return new Center(
                        child: new CircularProgressIndicator(),
                      );
                    }
                    else if (snapshot.hasError) {
                      return new Text('Error : ${snapshot.error}');
                    }
                    else {      //snapshot.hasData
                      return new Scrollbar(
                        child: new RefreshIndicator(
                          onRefresh: refresh,
                          child: Stack(
                            children: <Widget>[
                             Container(
                              width: _screenSize.width,
                              height: _screenSize.height*0.6,
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    Divider(
                                      color: Colors.black,
                                    ),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  var items = snapshot.data[index];
                                  return ListTile(
                                          title: Text(items.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: new TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(items.address_city),
                                        onTap: () {
                                          return Navigator.of(context).pushNamed(
                                              '/sub', arguments: items);
                                        },
                                  );
                                },
                              ),
                            ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Spacer(),

            ],
          ),
        ),
    );
  }
}