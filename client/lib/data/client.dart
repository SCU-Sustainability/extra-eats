import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'dart:io';

class Client {
  static final Client _client = new Client._internal();

  static Client get() {
    return _client;
  }

  Client._internal();

  Future<http.Response> ping() async {
    return http.get('https://taste-the-waste.herokuapp.com/api/', headers: {
      'Accept': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/x-www-form-urlencoded'
    }).then((res) {
      return res;
    });
  }

  Future<http.Response> login(String email, String password) async {
    return http.post('https://taste-the-waste.herokuapp.com/api/login', body: {
      'email': email,
      'password': password
    }, headers: {
      'Accept': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/x-www-form-urlencoded'
    }).then((res) {
        return res;
     
    });
  }

   Future<http.Response> register(String name, String password, String email) async {
    return http.post('https://taste-the-waste.herokuapp.com/api/users', body: {
      'email': email,
      'password': password,
      'name': name,
    }, headers: {
      'Accept': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/x-www-form-urlencoded'
    }).then((res) {
        return res;
    });
  }

  Future<http.StreamedResponse> post(String token, String name, String description, File image) async {
    const url = 'https://taste-the-waste.herokuapp.com/api/posts';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    var imgBytes = await image.readAsBytes();
    request.fields['name'] = name;
    request.fields['description'] = description;

    request.files.add(new http.MultipartFile.fromBytes(
      'image',
      imgBytes,
      contentType: new MediaType('image', 'jpeg')
    ));
    return request.send();
  }
}