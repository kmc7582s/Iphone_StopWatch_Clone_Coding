import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:async";
import 'package:flutter/widgets.dart';

void main() {
  runApp(MaterialApp(
    home: Watch(),
  ));
}

class Watch extends StatefulWidget {
  const Watch({super.key});

  @override
  State<Watch> createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  late Timer _timer;
  final List<String> labs = [];
  final List<int> m_lab = [0];
  final List<int> s_lab = [0];
  final List<int> ms_lab = [0];
  int ms = 0;
  int s = 0;
  int m = 0;

  int a = 0;
  int b = 0;
  int c = 0;
  bool isStart = false;

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        ms ++;
        if (ms == 100) {
          s++;
          ms = 0;
          if (s == 60) {
            m++;
            s = 0;
          }
        }
      });
    });
  }

  String Time() {
    String mStr = m.truncate().toString().padLeft(2, '0');
    String sStr = s.truncate().toString().padLeft(2, '0');
    String msStr = ms.truncate().toString().padLeft(2, '0');
    return "$mStr:$sStr.$msStr";
  }

  String LAB_TIME() {
    String mStr_lab = a.truncate().toString().padLeft(2, '0');
    String sStr_lab = b.truncate().toString().padLeft(2, '0');
    String msStr_lab = c.truncate().toString().padLeft(2, '0');
    return "$mStr_lab:$sStr_lab.$msStr_lab";
  }

  void _stopTimer() {
    setState(() {
      _timer.cancel();
    });
  }

  void _resetTimer() {
    setState(() {
      m=0;
      s=0;
      ms=0;
      a=0;
      b=0;
      c=0;
      m_lab.clear();
      s_lab.clear();
      ms_lab.clear();
      m_lab.add(0);
      s_lab.add(0);
      ms_lab.add(0);
      labs.clear(); //랩 데이터 삭제
    });
  }

  void _labTime() {
    setState(() {
      m_lab.insert(0, m);
      s_lab.insert(0, s);
      ms_lab.insert(0, ms);

      if(m_lab[0]>m_lab[1]) {
        a = m_lab[0]-m_lab[1];
      } else {
        a = m_lab[1]-m_lab[0];
      }

      if(s_lab[0]>s_lab[1]) {
        b = s_lab[0]-s_lab[1];
      } else {
        b = s_lab[1]-s_lab[0];
      }

      if(ms_lab[0]>ms_lab[1]) {
        c = ms_lab[0]-ms_lab[1];
      } else  {
        c = ms_lab[1]-ms_lab[0];
      }

      if(s_lab[0]>s_lab[1] && ms_lab[0]<ms_lab[1]) {
        b = (s_lab[0]-1)-s_lab[1];
        c = (ms_lab[0]+100)-ms_lab[1];
      }

      print(labs);
      print(m_lab);
      print(s_lab);
      print(ms_lab);
      print("랩타임 : $a:$b.$c");

      labs.insert(0, LAB_TIME());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stop Watch",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:70,bottom: 50),
                child: Text(Time(),
                  style: TextStyle(
                    fontSize: 85,
                    color: Colors.white,
                    fontWeight: FontWeight.w200
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: m>0.1||s>0.1||ms>0.1? Colors.grey.shade400.withOpacity(0.4) : Colors.grey.shade800.withOpacity(0.4)
                      ),
                      child: Material(
                        color: Colors.black.withOpacity(0.1),
                        child: InkWell(
                          splashColor: Colors.black.withOpacity(0.2),
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            if (m>0.1||s>0.1||ms>0.1) {
                              if(isStart==false) {
                                setState(() {
                                  _resetTimer();
                                });
                              } else {
                                setState(() {
                                  //랩 타임 실행 코드 작성
                                  _labTime();
                                });
                              }
                            }
                          },
                          child: Center(
                            child: Text((m>0.1||s>0.1||ms>0.1)? (isStart ? "랩" : "재설정") : "랩",
                              style: (m>0.1||s>0.1||ms>0.1)? (isStart ?
                              TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade100,
                              ) :  TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade100,
                              )) : TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade400,),
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: isStart? Colors.redAccent.shade400.withOpacity(0.2) : Colors.greenAccent.shade400.withOpacity(0.2)
                        ),
                        child: Material(
                          color: Colors.black.withOpacity(0.1),
                          child: InkWell(
                            splashColor: Colors.black.withOpacity(0.2),
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              if (isStart) {
                                setState(() {
                                  isStart = false;
                                  _stopTimer();
                                });
                              } else {
                                setState(() {
                                  isStart = true;
                                  _startTimer();
                                });
                              };
                            },
                            child: Center(
                              child: Text(
                                isStart ? "중단" : "시작",
                                style: isStart ? TextStyle(
                                    fontSize: 18,
                                    color: Colors.redAccent.shade200
                                ) : TextStyle(
                                    fontSize: 18,
                                    color: Colors.greenAccent.shade400
                                )
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
              Divider(color: Colors.grey.shade900,height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: labs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _listBuilder(context, index),
                        Divider(color: Colors.grey.shade900,height: 10,),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listBuilder(BuildContext context, int index) {
    return Container(
      height: 30,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("랩 ${labs.length - index}",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
              Text(labs[index],
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}