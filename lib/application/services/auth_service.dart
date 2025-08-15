import 'package:dio/dio.dart';
import 'package:hala_desktop/infrastructure/services/token_storage_service.dart';
import '../../core/constants/app_constants.dart';
import 'package:hala_desktop/domain/entities/user.dart'; // Make sure this path is correct

class AuthService {
  final Dio _dio;
  final TokenStorageService _tokenStorage;

  AuthService(TokenStorageService tokenStorage)
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConstants.apiBaseUrl,
          headers: {"Accept": "application/json"},
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      ),
      _tokenStorage = tokenStorage;

  Future<String?> getAuthToken() async {
    return await _tokenStorage.getToken();
  }

  Future<bool> login(Map<String, dynamic> data) async {
    final response = await _dio.post('/login', data: data);

    if (response.statusCode == 200 && response.data.containsKey('token')) {
      final token = response.data['token'];
      await _tokenStorage.saveToken(token);
      return true;
    }

    return false;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    data['password_confirmation'] = data['password'];
    final response = await _dio.post('/register', data: data);

    if (response.statusCode == 201) {
      // Registration succeeded, now login to get token + user
      final loginSuccess = await login({
        'email': data['email'],
        'password': data['password'],
      });

      if (loginSuccess) {
        final token = await _tokenStorage.getToken();
        final user = await getUser();
        return {'token': token, 'user': user};
      } else {
        throw Exception('Login failed after registration');
      }
    } else {
      print('❌ Registration failed: ${response.data}');
      throw Exception('Registration failed');
    }
  }

  Future<User> getUser() async {
    final token = await _tokenStorage.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await _dio.get(
      '/user',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 && response.data is Map) {
      final userMap = Map<String, dynamic>.from(response.data);

      return User(
        id: userMap['id'].toString(),
        name: userMap['name'],
        email: userMap['email'],
        token: token,  
      );
    } else {
      throw Exception("Failed to fetch user data: ${response.statusCode}");
    }
  }

  Future<void> logout() async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      await _dio.post(
        '/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    }

    await _tokenStorage.deleteToken();
    
  }

  Dio get dio => _dio;
}
