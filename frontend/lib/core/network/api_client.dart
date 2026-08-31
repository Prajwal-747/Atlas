import 'package:dio/dio.dart';
import 'api_config.dart';
import 'token_storage.dart';

class ApiClient {
  late final Dio dio;
  final TokenStorage tokenStorage;
  ApiClient({TokenStorage? tokenStorage})
    : tokenStorage = tokenStorage ?? TokenStorage() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await this.tokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final path = error.requestOptions.path;
          if (error.response?.statusCode != 401 ||
              path == '/auth/token/' ||
              path == '/auth/token/refresh/') {
            handler.next(error);
            return;
          }
          final refreshToken = await this.tokenStorage.getRefreshToken();
          if (refreshToken == null || refreshToken.isEmpty) {
            handler.next(error);
            return;
          }
          try {
            final response = await dio.post(
              '/auth/token/refresh/',
              data: {'refresh': refreshToken},
            );
            final newAccessToken = response.data['access'] as String;
            await this.tokenStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: refreshToken,
            );
            final request = error.requestOptions;
            request.headers['Authorization'] = 'Bearer $newAccessToken';
            final retryResponse = await dio.fetch(request);
            handler.resolve(retryResponse);
          } on DioException {
            await this.tokenStorage.clear();
            handler.next(error);
          }
        },
      ),
    );
  }
}
