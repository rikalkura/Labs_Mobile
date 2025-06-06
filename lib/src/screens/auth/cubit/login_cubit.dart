import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/repo/implementation/user_repository_local.dart';
import 'package:untitled/src/services/connectivity_service.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final SharedPrefsUserStorage storage;
  final ConnectivityService connectivity;

  LoginCubit({
    required this.storage,
    required this.connectivity,
  }) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    final isOnline = await connectivity.isConnected();
    if (!isOnline) {
      emit(LoginFailure("No internet connection"));
      return;
    }

    final savedUser = await storage.getUser();
    if (savedUser == null) {
      emit(LoginFailure("User not found. Please register."));
      return;
    }

    if (savedUser['email'] != email || savedUser['password'] != password) {
      emit(LoginFailure("Incorrect email or password"));
      return;
    }

    emit(LoginSuccess());
  }
}
