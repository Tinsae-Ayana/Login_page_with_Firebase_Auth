import 'package:authentication_repository/repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_firebase_bloc/app/bloc/app_bloc.dart';
import 'package:login_firebase_bloc/home/screen/home_page.dart';
import 'package:login_firebase_bloc/login/screen/login_page.dart';

class App extends StatelessWidget {
  const App(
      {Key? key, required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (context) => AppBloc(_authenticationRepository),
        child: Builder(builder: (context) {
          return const MaterialApp(
            home: const AppView(),
            debugShowCheckedModeBanner: false,
          );
        }),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlowBuilder<AppStatus>(
      onGeneratePages: (state, page) {
        return [
          const MaterialPage(child: LoginPage()),
          if (state == AppStatus.authenticated)
            const MaterialPage(child: HomePage())
        ];
      },
      state: context.select((AppBloc bloc) => bloc.state.status),
    );
  }
}
