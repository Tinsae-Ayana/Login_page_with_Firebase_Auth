import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_firebase_bloc/app/bloc/app_bloc.dart';
import 'package:login_firebase_bloc/signup/cubit/signup_cubit.dart';
import 'package:login_firebase_bloc/signup/screen/signup_form.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocProvider<SignupCubit>(
              create: (_) {
                return SignupCubit(
                    context.read<AppBloc>().authenticationRepository);
              },
              child: const SignupForm())),
    );
  }
}
