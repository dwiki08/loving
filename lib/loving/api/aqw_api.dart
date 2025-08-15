import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/model/login_model.dart';

import '../../di/di_provider.dart';
import '../../model/error_result.dart';
import '../../model/server_model.dart';

final aqwApiProvider = Provider<AqwApi>(
  (ref) => AqwApi(dio: ref.read(dioProvider)),
);

class AqwApi {
  final Dio dio;

  AqwApi({required this.dio});

  Future<Either<ErrorResult, LoginModel>> getLoginInfo({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        'https://game.aq.com/game/api/login/now',
        data: {'user': username, 'pass': password, 'option': 1},
      );
      final json = response.data as Map<String, dynamic>;
      if (json['login']['bSuccess'] == 1) {
        final model = LoginModel(
          username: json['login']['unm'],
          sToken: json['login']['sToken'],
          userid: json['login']['userid'].toString(),
          servers:
              (json['servers'] as List<dynamic>)
                  .map(
                    (data) =>
                        ServerModel.fromJson(data as Map<String, dynamic>),
                  )
                  .toList(),
        );
        return Right(model);
      }
      throw Exception('Login failed');
    } catch (e) {
      return Left(ErrorResult.createResult(e));
    }
  }
}
