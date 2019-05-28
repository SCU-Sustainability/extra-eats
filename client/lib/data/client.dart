import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'dart:async';
import 'dart:convert'; 

class Client {
  static final Client _client = new Client._internal();
  static final String _localhost = 'http://localhost:8080/api/';
  static final String _local = 'http://10.0.2.2:8080/api/';
  static final String _external = 'https://taste-the-waste.herokuapp.com/api/';
  static final String _url = _local;

  static Client get() {
    return _client;
  }

  Client._internal();
  Future<Response> ping() async {
    var response = await Dio().get(_url);
    return response;
  }

  Future<Response> login(String email, String password) async {
    var response = await Dio().postUri(Uri.parse(_url + 'login'),
        data: {'email': email, 'password': password});
    return response;
  }

  Future<Response> register(
      String name, String password, String email, bool provider) async {
    var response = await Dio().postUri(Uri.parse(_url + 'users'), data: {
      'email': email,
      'password': password,
      'name': name,
      'provider': provider
    });
    return response;
  }

  Future<Response> post(String token, String name, String description,
      File imgFile, String location, DateTime postDate, DateTime expiryDate, List tags, bool isScheduled) async {

    FormData formData = new FormData.from({
      'name': name,
      'description': description,
      'image': new UploadFileInfo(imgFile, DateTime.now().toIso8601String()),
      'location': location,
      'postDate': postDate.toUtc().toIso8601String(),
      'expiryDate': expiryDate.toUtc().toIso8601String(),
      'tags': tags,
      'isScheduled': isScheduled
    });
    var response = await Dio().post(_url + 'posts',
        data: formData, options: Options(headers: {'x-access-token': token}));
    return response;
  }

  Future<Response> getPosts(String token) async {
    var response = await Dio().get(_url + 'posts',
        options: Options(headers: {'x-access-token': token}));
    print(response);
    return response;
  }

  Future<Response> deletePost(String token, String postId) async {
    var response = await Dio().delete(_url + 'posts',
        options: Options(headers: {'x-access-token': token, 'id': postId}));
    return response;
  }
}
