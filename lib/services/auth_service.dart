import 'package:dio/dio.dart';

class AuthService {
  Dio _dio;

  AuthService() : _dio = Dio() {
    _dio = Dio();
  }

  Future<bool> signUp(String email, String password) async {
    try {
      const url = 'https://pizzas.shrp.dev/users';
      final data = {
        'role': 'bad526d9-bc5a-45f1-9f0b-eafadcd4fc15',
        'email': email,
        'password': password,
      };

      final response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
      return false;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      const url = 'https://pizzas.shrp.dev/auth/login';
      final data = {
        'email': email,
        'password': password,
      };

      final response = await _dio.post(url, data: data);

      if (response.statusCode == 200) {
        return response.data['data']['access_token'];
      }

      return null;
    } catch (error) {
      // ignore: avoid_print
      print(error);
      return null;
    }
  }
}
