import 'dart:math';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/model/game/item.dart';
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

  Future<Either<ErrorResult, List<Item>>> getBankItems(
    String charId,
    String token,
  ) async {
    try {
      final random = Random();
      final rand =
          BigInt.from(10).pow(16) +
          BigInt.from(
            (random.nextDouble() * (pow(10, 17) - pow(10, 16))).toInt(),
          );
      final randomV = "0.$rand";
      final response = await dio.post(
        'https://game.aq.com/game/api/char/bank?v=$randomV',
        data: {
          "layout": {"cat": "all"},
        },
        options: Options(
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36',
            'Content-Type': 'application/x-www-form-urlencoded',
            'ccid': charId,
            'token': token,
            'artixmode': 'launcher',
            'X-Requested-With': 'ShockwaveFlash/32.0.0.371',
          },
        ),
      );
      if (response.statusCode == 200) {
        final items =
            (response.data as List<dynamic>)
                .map(
                  (itemData) => Item.fromJson(itemData as Map<String, dynamic>),
                )
                .toList();
        return Right(items);
      }
      throw Exception('Failed to load bank: ${response.statusCode}');
    } catch (e) {
      return Left(ErrorResult.createResult(e));
    }
  }
}
