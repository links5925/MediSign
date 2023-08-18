import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final picker = ImagePicker();
  var ocr_result;
  @override
  void initState() {
    getImage();
    super.initState();
  }

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage() async {
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      Navigator.pop(context);
    } else {
      var bytes = File(image.path.toString()).readAsBytesSync();
      String img64 = base64Encode(bytes);

      // OCR API 호출을 위한 URL, 페이로드, 헤더 설정
      var url = 'https://api.ocr.space/parse/image';
      var payload = {
        "base64Image": "data:image/jpg;base64,${img64.toString()}",
        "language": "kor"
      };
      var header = {"apikey": "K84546995588957"};

      // OCR API 호출 및 응답 받아오기
      var post =
          await http.post(Uri.parse(url), body: payload, headers: header);
      var result = jsonDecode(post.body);
      String parsedtext = result['ParsedResults'][0]['ParsedText'];
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
      setState(() {
        ocr_result = parselist.join('\n');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        backgroundColor: const Color(0xfff4f3f9),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(ocr_result ?? ""), // 인식된 텍스트 출력
              ],
            )
          ],
        ));
  }
}
