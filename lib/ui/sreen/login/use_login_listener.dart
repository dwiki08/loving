import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/model/error_result.dart';
import 'package:loving/model/login_model.dart';
import 'package:loving/model/server_list.dart';
import 'package:loving/ui/sreen/dashboard/dashboard_screen.dart';
import 'package:loving/ui/sreen/login/login_notifier.dart';

void useLoginListener(
  WidgetRef ref, {
  required ServerList selectedServer,
  required BuildContext context,
}) {
  ref.listen<AsyncValue<LoginModel?>>(loginProvider, (prev, next) {
    next.whenOrNull(
      data: (data) {
        if (data != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => DashboardScreen(
                server: selectedServer.value,
                loginModel: data,
              ),
            ),
          );
        }
      },
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((e as ErrorResult).message.toString())),
        );
      },
    );
  });
}
