import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/repo/implementation/user_repository_local.dart';
import 'package:untitled/src/utils/validators.dart';

import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final SharedPrefsUserStorage storage;

  RegisterCubit({required this.storage}) : super(RegisterInitial());

  Future<void> register({
    required String name,
    required String dob,
    required String address,
    required String email,
    required String password,
  }) async {
    final nameError = Validators.validateName(name);
    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validatePassword(password);

    if (nameError != null) {
      emit(RegisterFailure(nameError));
      return;
    }
    if (emailError != null) {
      emit(RegisterFailure(emailError));
      return;
    }
    if (passwordError != null) {
      emit(RegisterFailure(passwordError));
      return;
    }

    emit(RegisterLoading());

    await storage.saveUser({
      'name': name,
      'dob': dob,
      'address': address,
      'email': email,
      'password': password,
    });

    emit(RegisterSuccess());
  }
}
