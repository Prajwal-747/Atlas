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

  Future<UserProfile> updateProfile({
    String? email,
    String? currentPassword,
    String? newPassword,
  }) async {
    final data = <String, dynamic>{};
    if (email != null) {
      data['email'] = email;
    }
    if (currentPassword != null && currentPassword.isNotEmpty) {
      data['current_password'] = currentPassword;
    }
    if (newPassword != null && newPassword.isNotEmpty) {
      data['new_password'] = newPassword;
    }
    final response = await apiClient.dio.patch('/auth/me/', data: data);
    return _fromJson(response.data as Map<String, dynamic>);
  }
}
