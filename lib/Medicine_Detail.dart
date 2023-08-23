import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Medicine_detail extends StatefulWidget {
  const Medicine_detail({super.key});
  @override
  State<Medicine_detail> createState() => _Medicine_detailState();
}

class _Medicine_detailState extends State<Medicine_detail> {
  late var Medicine;
  String? name;
  bool fold_1 = false;
  bool fold_2 = true;
  @override
  void initState() {
    super.initState();
    get_medicines();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    String loadname = user_info.getString('post_name') ?? '';
    setState(() {
      name = loadname;
    });
  }

  Future<void> get_medicines() async {
    final response = await http.get(Uri.parse(
        'https://medisign-hackthon-95c791df694a.herokuapp.com/medicines/medicine_list'));
    if (response.statusCode == 200) {
      // API 응답을 JSON으로 변환하여 파싱
      List<Map<String, dynamic>> responseData = json.decode(response.body);
      for (var medicine in responseData) {
        if (name == medicine['name']) {
          setState(() {
            Medicine = responseData;
          });
        }
      }
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            width: screenWidth * 0.9,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    if (fold_1 == true) {
                      setState(() {
                        fold_1 = false;
                      });
                    } else {
                      setState(() {
                        fold_1 = true;
                      });
                    }
                  },
                  child: Row(
                    children: [Icon(Icons.arrow_right_sharp), Text('약 정보')],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          //Medicine['image'] ??
                          'https://picsum.photos/200/200',
                          height: 160,
                          width: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 8),
                        Text('약품명'),
                        Text(Medicine['name']),
                        Text('성분'),
                        Text('성분설명')
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
