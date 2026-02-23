import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/model/server_list.dart';
import 'package:loving/ui/theme.dart';

import '../../../database/app_database.dart';
import '../../../services/account_manager.dart';
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
    final isRememberMe = useState(false);
    final savedAccounts = useState<List<Account>>([]);

    useEffect(() {
      ref.read(accountManagerProvider).getAccounts().then((accounts) {
        savedAccounts.value = accounts;
      });
      return null;
    }, []);

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
                if (savedAccounts.value.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Account>(
                        isExpanded: true,
                        hint: const Text('Select Saved Account'),
                        items: savedAccounts.value.map((account) {
                          return DropdownMenuItem(
                            value: account,
                            child: Text(account.username),
                          );
                        }).toList(),
                        onChanged: (account) {
                          if (account != null) {
                            usernameTextController.text = account.username;
                            passwordTextController.text = account.password;
                          }
                        },
                      ),
                    ),
                  ),
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
                Row(
                  children: [
                    Checkbox(
                      value: isRememberMe.value,
                      onChanged: (value) {
                        isRememberMe.value = value ?? false;
                      },
                    ),
                    const Text('Remember Me'),
                  ],
                ),
                loginState.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isRememberMe.value) {
                              ref
                                  .read(accountManagerProvider)
                                  .saveAccount(
                                    usernameTextController.text,
                                    passwordTextController.text,
                                  );
                            }
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
