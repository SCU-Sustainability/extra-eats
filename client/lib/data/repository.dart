import './client.dart';

class Repository {
  static final Repository _repo = new Repository._internal();
  Client client;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    client = Client.get();
  }
}