import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/model/error_result.dart';
import 'package:loving/model/login_model.dart';
import 'package:loving/ui/theme.dart';

import '../dashboard/dashboard_screen.dart';
import 'login_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameTextController = TextEditingController(text: '');
  final _passwordTextController = TextEditingController(text: '');
  final _serverTextController = TextEditingController(text: 'Yorumi');

  late final ProviderSubscription _loginSub;
  LoginModel? loginModel;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loginSub = ref.listenManual<AsyncValue<LoginModel?>>(
      loginNotifierProvider,
      (prev, next) {
        next.whenOrNull(
          data: (data) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder:
                    (_) => DashboardScreen(
                      server: _serverTextController.text,
                      loginModel: data as LoginModel,
                    ),
              ),
            );
          },
          error: (e, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text((e as ErrorResult).message.toString())),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _loginSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);
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
                  controller: _usernameTextController,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldDecoration(
                    context: context,
                    icon: const Icon(Icons.person),
                    label: 'Username',
                  ),
                ),
                TextField(
                  enabled: !loginState.isLoading,
                  controller: _passwordTextController,
                  textInputAction: TextInputAction.next,
                  obscureText: !_isPasswordVisible,
                  decoration: textFieldDecoration(
                    context: context,
                    icon: const Icon(Icons.password),
                    label: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                TextField(
                  enabled: !loginState.isLoading,
                  controller: _serverTextController,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldDecoration(
                    context: context,
                    icon: const Icon(Icons.list_alt),
                    label: 'Server',
                  ),
                ),
                loginState.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(loginNotifierProvider.notifier)
                              .login(
                                username: _usernameTextController.text,
                                password: _passwordTextController.text,
                                server: _serverTextController.text,
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
