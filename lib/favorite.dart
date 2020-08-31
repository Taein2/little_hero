import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_hero/db.dart';
import 'package:http/http.dart' as http;
import 'package:little_hero/noti.dart';

class favorite extends StatefulWidget {
  _MyFavorite createState() => _MyFavorite();
}


class _MyFavorite extends State<favorite> {

  List<Noti> _listGet = [];
  List<Noti> _listFinal = [];

  void _fetchGets() async {
    var get = await http.get('http://54.180.31.78:8000/api/posts/all?');

    final List<Noti> parsedGet1 = jsonDecode(utf8.decode(get.bodyBytes))
        .map<Noti>((json) => Noti.fromJSON(json))
        .toList();
    setState(() {
      _listGet.clear();
      _listGet.addAll(parsedGet1);
    });
  }

  void initState() {
    _fetchGets();
    super.initState();
  }

  Widget build(BuildContext context) {
    Noti();
    final _screenSize = MediaQuery.of(context).size;

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
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '즐겨 찾기',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: _screenSize.width,
              height: _screenSize.height * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  )),
              child: FutureBuilder(
                  future: DBHelper().getAllDogs(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Favorite>> snapshot) {
                    for (int i = 0; i < snapshot.data.length; i++) {
                      for(int j = 0; j < _listGet.length; j++)
                      if (snapshot.data[i].regist_no == _listGet[j].regist_no) {
                        _listFinal.add(_listGet[j]);
                      }
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: _listFinal.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(_listFinal[index].title),
                            onTap: () {
                              return Navigator.of(context).pushNamed('/sub',
                                  arguments: _listFinal[index]);
                            },
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('데이터가 없습니다.'),
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
