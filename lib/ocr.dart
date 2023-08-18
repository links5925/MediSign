import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OCR extends StatefulWidget {
  @override
  _OCRState createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  late String id;
  String parsedtext = '';
  late List<String> parselist;
  var year = DateTime.now().year;
  var month = DateTime.now().month;
  var day = DateTime.now().day;
  Future<void> _loadid() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    id = user_info.getString('id') ?? '';
  }

  Future<void> _getFromGallery() async {
    // 갤러리에서 이미지를 선택
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    // 선택한 이미지 파일을 바이트로 읽고 base64로 인코딩
    var bytes = File(pickedFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    // OCR API 호출을 위한 URL, 페이로드, 헤더 설정
    var url = 'https://api.ocr.space/parse/image';
    var payload = {
      "base64Image": "data:image/jpg;base64,${img64.toString()}",
      "language": "kor"
    };
    var header = {"apikey": "K84546995588957"};

    // OCR API 호출 및 응답 받아오기
    var post = await http.post(Uri.parse(url), body: payload, headers: header);
    var result = jsonDecode(post.body);

    // 인식된 텍스트를 파싱하여 저장
    setState(() {
      parsedtext = result['ParsedResults'][0]['ParsedText'];
      List<String> lines = parsedtext.split('\n'); // 줄바꿈으로 문자열 나누기
      List<String> parselist = lines.map((input) {
        int firstClosingBracketIndex = input.indexOf(')');
        if (firstClosingBracketIndex != -1) {
          String substring = input.substring(firstClosingBracketIndex + 1);
          int firstOpeningBracketIndex = substring.indexOf('(');
          if (firstOpeningBracketIndex != -1) {
            substring = substring.substring(0, firstOpeningBracketIndex);
          }
          return substring;
        }
        return input;
      }).toList();
      parsedtext = parselist.join('\n'); // 리스트 요소들을 줄바꿈으로 구분하여 하나의 문자열로 합침
      // print(parsedtext);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Test'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _getFromGallery();
              }, // 갤러리에서 이미지 선택하는 함수 호출
              child: Text('갤러리에서 이미지 선택'),
            ),
            SizedBox(height: 16), // 버튼 아래 여백 조절
            Text(parsedtext), // 인식된 텍스트 출력
            ElevatedButton(
                onPressed: () async {
                  if (parselist == false || parselist == []) {
                  } else {
                    _loadid();
                    String url =
                        'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list'
                        '$id';
                    var data = {
                      'user': id,
                      "prescription_date": DateTime.now(),
                      "duration": 3,
                      "medicine": parselist,
                      "hospital": "병원",
                    };
                    var body = jsonEncode(data);
                    var response = await http.post(Uri.parse(url), body: body);
                    if (response.statusCode == 200) {
                      Navigator.pushNamed(context, '/');
                    }
                  }
                },
                child: Text('확인'))
          ],
        ),
      ),
    );
  }
}
