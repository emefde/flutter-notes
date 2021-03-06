import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/login/bloc/login_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(builder: (_) => LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocProvider(
          create: (context) => LoginBloc(
              authenticationRepostiory:
                  context.read<AuthenticationRepostiory>()),
          child: LoginForm(),
        ),
      ),
    );
  }
}
