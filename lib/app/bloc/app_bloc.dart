import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(AuthenticationRepository bauthenticationRepository)
      : authenticationRepository = bauthenticationRepository,
        super(const AppState.unauthenticated()) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogOutRequest>(_onLogOutRequested);
    _userSubscription = authenticationRepository.user.listen((user) {
      add(AppUserChanged(user));
    });
  }
  final AuthenticationRepository authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(event, emit) {
    debugPrint('at the cubit');
    emit(AppState.authenticated(event.user));
  }

  void _onLogOutRequested(event, emit) {
    unawaited(authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
