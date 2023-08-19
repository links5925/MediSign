import 'package:flutter/material.dart';

class All_Alarm extends StatefulWidget {
  const All_Alarm({super.key});

  @override
  State<All_Alarm> createState() => _All_AlarmState();
}

class _All_AlarmState extends State<All_Alarm> {
  bool focus = true;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(
          minHeight: screenHeight,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff627BFD), Color(0xffE3EBFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left_sharp,
                          color: Colors.white,
                          size: 30,
                        )),
                    SizedBox(width: screenWidth * 0.29),
                    Text(
                      '알림',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          style: ButtonStyle(),
                          child: Column(children: [
                            Text(
                              '공지사항',
                              style: TextStyle(color: Colors.white),
                            ),
                            Divider(
                              thickness: 1,
                              color: focus ? Colors.grey[700] : Colors.grey,
                            ),
                          ]),
                          onPressed: () {
                            setState(() {
                              focus = true;
                            });
                          }),
                    ),
                    Expanded(
                        child: TextButton(
                            child: Column(children: [
                              Text(
                                '약 상호관계',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: focus ? Colors.grey : Colors.grey[700],
                              ),
                            ]),
                            onPressed: () {
                              setState(() {
                                focus = false;
                              });
                            }))
                  ],
                ),
                focus
                    ? Center(
                        child: Text('공지사항', style: TextStyle(fontSize: 50)),
                      )
                    : Center(
                        child: Text('약 상호', style: TextStyle(fontSize: 50)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
