import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import 'mock_users_loader.dart';
import 'users_page_model.dart';

class UsersApiService {
  final Dio _dio;
  final MockUsersLoader _mock;

  UsersApiService({Dio? dio, MockUsersLoader? mock})
      : _dio = dio ?? DioClient.dio,
        _mock = mock ?? MockUsersLoader();

  Future<UsersPageModel> fetchUsers({required int page, int perPage = 10}) async {
    try {
      final res = await _dio.get(
        '/users',
        queryParameters: {'page': page, 'per_page': perPage},
        options: Options(
          validateStatus: (s) => s != null,
        ),
      );

      
      if (res.data is String) {
        final body = res.data as String;
        if (body.contains('Just a moment') || body.contains('cloudflare')) {
          return _mock.loadPage(page); 
        }
        throw Exception('Unexpected response format');
      }

      if (res.statusCode != 200) {
        return _mock.loadPage(page);
      }

      return UsersPageModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return _mock.loadPage(page);
      }
      return _mock.loadPage(page);
    } catch (_) {
      return _mock.loadPage(page);
    }
  }
}
