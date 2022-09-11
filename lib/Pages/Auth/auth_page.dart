import 'package:eventora/Pages/Auth/login.dart';
import 'package:eventora/Pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';

// class AuthPage extends StatefulWidget {
//   const AuthPage({Key? key}) : super(key: key);

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   @override
//   Widget build(BuildContext context,WidgetRef ref) {
//       AsyncValue<int> authVal = ref.watch(provider)
//       return
//   }
// }

final authProvider = FutureProvider<int>((ref) async {
  return await AuthController().authUser();
});

final authStateProvider = StateProvider((ref) {});

class AuthPage extends ConsumerWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<int> authVal = ref.watch(authProvider);
    return Scaffold(
        body: authVal.when(
            data: (int val) {
              if (val == 200) {
                return const HomePage();
              }
              return const Login();
            },
            error: (err, stacl) => Text(err.toString()),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive())));
  }
}
