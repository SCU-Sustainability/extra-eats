import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import 'dart:io';

class Client {
  static final Client _client = new Client._internal();
  static final String _url = 'http://10.0.2.2:8080/api/';

  static Client get() {
    return _client;
  }

  static String url() {
    return _url;
  }

  Client._internal();

  Future<Response> ping() async {
    try {
      var response = await Dio().get(Client._url);
      return response;
    } catch (e) {
      print(e);
    }
  }

  Future<Response> login(String email, String password) async {

    try {
      var response = await Dio().postUri(Uri.parse(Client._url + 'login'), data: {
        'email': email,
        'password': password
      });
      return response;
    } catch (e) {
      print(e);
    }
  }

   Future<Response> register(String name, String password, String email) async {

    try {
      var response = await Dio().postUri(Uri.parse(Client._url + 'users'), data: {
        'email': email,
        'password': password,
        'name': name
      });
      return response;
    } catch (e) {
      print(e);
    }
  }

  Future<Response> post(String token, String name, String description, File imgFile) async {
    
    FormData formData = new FormData.from({
      'name': name,
      'description': description,
      'post-image': new UploadFileInfo(imgFile, name)
    });
    try {

      var response = await Dio().post(_url + 'posts', data: formData, options: Options(
        headers: {
          'x-access-token': token
        }
      ));
      return response;
    } catch (e) {
      print(e);
    }
  }
}