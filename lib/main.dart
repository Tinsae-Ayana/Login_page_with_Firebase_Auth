import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase_bloc/app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  return BlocOverrides.runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final autheticationRepository = AuthenticationRepository();
    await autheticationRepository.user.first;
    runApp(App(
      authenticationRepository: autheticationRepository,
    ));
  });
}
