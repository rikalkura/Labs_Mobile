import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/repo/implementation/user_repository_local.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SharedPrefsUserStorage storage;

  ProfileCubit({required this.storage}) : super(ProfileInitial());

  Future<void> loadUser() async {
    emit(ProfileLoading());
    final data = await storage.getUser();
    if (data != null) {
      emit(ProfileLoaded(userData: data, isEditing: false));
    } else {
      emit(ProfileError("User not found"));
    }
  }

  void toggleEditMode() {
    if (state is ProfileLoaded) {
      final s = state as ProfileLoaded;
      emit(s.copyWith(isEditing: !s.isEditing));
    }
  }

  Future<void> saveChanges(Map<String, String> updatedData) async {
    await storage.updateUser(updatedData);
    await loadUser();
  }

  Future<void> logout() async {
    await storage.deleteUser();
    emit(ProfileLoggedOut());
  }
}
