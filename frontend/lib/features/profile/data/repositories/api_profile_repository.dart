import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/profile/domain/entities/user_profile.dart';

class ApiProfileRepository {
  final ApiClient apiClient;
  ApiProfileRepository({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  UserProfile _fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'].toString(),
      email: json['email'] as String,
      username: json['username'] as String,
    );
  }

  Future<UserProfile> getProfile() async {
    final response = await apiClient.dio.get('/auth/me/');
    return _fromJson(response.data as Map<String, dynamic>);
  }
}
