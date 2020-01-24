import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _controller;
  bool _click = false;
  double sheetHeight = 330; //bottomsheet height
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _click = false;
      });
    } else
      _controller.position.isScrollingNotifier.addListener(_stopScrolling);
  }

  _stopScrolling() {
    if (_controller.offset > 0 &&
        _controller.offset <= sheetHeight &&
        !_controller.position.isScrollingNotifier.value &&
        !_controller.position.outOfRange) {
      Timer(
          Duration(milliseconds: 10), //delay for animation
          () => _controller.animateTo(
                sheetHeight,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 300),
              ));
    } else if (_controller.offset <= 0) {
      setState(() {
        _click = false;
      });
    }
  }

  _onTapToClose() {
    {
      Timer(
          Duration(milliseconds: 10), //delay for animation
          () => (_controller.animateTo(
                0,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 300),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("fullscreen bottomsheet"),
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (_click) {
              _onTapToClose();
            } else
              Navigator.of(context).pop();
            return false;
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: new Stack(
                children: <Widget>[
                  new Center(
                      child: new InkWell(
                    child: new Text("show bottomsheet"),
                    onTap: () {
                      setState(() {
                        _click = true;
                      });
                      Timer(
                          Duration(milliseconds: 100),
                          () => _controller.animateTo(
                                sheetHeight,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 500),
                              ));
                    },
                  )),
                  _click
                      ? new Container(
                          // set background
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.black38, //background color
                          child: new SingleChildScrollView(
                            controller: _controller,
                            child: new Column(
                              children: <Widget>[
                                new GestureDetector(
                                  child: new Container(
                                    color: Colors.transparent,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height -
                                        80, // 80 => small space for close bottomsheed smoothly
                                    child: null,
                                  ),
                                  onTap: () {
                                    _onTapToClose();
                                  },
                                ),
                                new Container(
                                    // set bottomsheed items
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        )),
                                    child: bottomSheetItems())
                              ],
                            ),
                          ))
                      : new Container()
                ],
              )),
        ));
  }

  Widget bottomSheetItems() {
    return new Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        new Container(
          height: 17,
          child: new Text(
            "my items",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff2D2D2D)),
          ),
        ),
        SizedBox(
          height: 14,
        ),
        new Container(
          decoration: new BoxDecoration(
              border: new Border(
            bottom: BorderSide(
              color: Color(0xff101010).withOpacity(.11),
              width: 1.0,
            ),
          )),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              height: 100,
              width: double.infinity,
              color: index % 2 == 0 ? Colors.yellow : Colors.greenAccent,
            );
          },
        ),
      ],
    );
  }
}
