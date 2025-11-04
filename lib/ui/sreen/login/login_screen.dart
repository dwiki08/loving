import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/model/server_list.dart';
import 'package:loving/ui/theme.dart';

import 'login_form_state.dart';
import 'login_notifier.dart';
import 'use_login_listener.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameTextController = useTextEditingController(
      text: dotenv.env['USERNAME'],
    );
    final passwordTextController = useTextEditingController(
      text: dotenv.env['PASS'],
    );

    final loginFormState = ref.watch(loginFormProvider);

    useLoginListener(
      ref,
      selectedServer: loginFormState.selectedServer,
      context: context,
    );

    final loginState = ref.watch(loginProvider);
    final isTextFieldFocused = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Loving'), backgroundColor: appBarColor),
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (!isTextFieldFocused)
            const Image(
              image: AssetImage('assets/astolfo_r.jpg'),
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              spacing: defaultPadding,
              children: [
                TextField(
                  enabled: !loginState.isLoading,
                  controller: usernameTextController,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldDecoration(
                    context: context,
                    icon: const Icon(Icons.person),
                    label: 'Username',
                  ),
                ),
                TextField(
                  enabled: !loginState.isLoading,
                  controller: passwordTextController,
                  textInputAction: TextInputAction.next,
                  obscureText: !loginFormState.isPasswordVisible,
                  decoration: textFieldDecoration(
                    context: context,
                    icon: const Icon(Icons.password),
                    label: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginFormState.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        ref
                            .read(loginFormProvider.notifier)
                            .togglePasswordVisibility();
                      },
                    ),
                  ),
                ),
                DropdownButtonFormField<ServerList>(
                  enableFeedback: !loginState.isLoading,
                  value: loginFormState.selectedServer,
                  decoration: textFieldDecoration(
                    context: context,
                    icon: const Icon(Icons.list_alt),
                    label: 'Server',
                  ),
                  items: ServerList.values
                      .map(
                        (server) => DropdownMenuItem(
                          value: server,
                          child: Text(server.value),
                        ),
                      )
                      .toList(),
                  onChanged: loginState.isLoading
                      ? null
                      : (value) {
                          if (value != null) {
                            ref
                                .read(loginFormProvider.notifier)
                                .setSelectedServer(value);
                          }
                        },
                ),
                loginState.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(loginProvider.notifier)
                                .login(
                                  username: usernameTextController.text,
                                  password: passwordTextController.text,
                                  server: loginFormState.selectedServer.value,
                                );
                          },
                          child: const Text('Login'),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
