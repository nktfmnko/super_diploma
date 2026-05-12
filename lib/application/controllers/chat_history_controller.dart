import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:super_diploma/infrastructure/datasources/daos/users_dao.dart';
import 'package:super_diploma/infrastructure/datasources/database.dart';

class ChatHistoryController extends ChangeNotifier {
  bool isLoading = false;
  final _userDao = GetIt.I<UsersDao>();

  List<User> _users = [];

  List<User> get users => _users;

  Future<void> getUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      _users = await _userDao.getAllUsers();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
