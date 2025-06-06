abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, String> userData;
  final bool isEditing;

  ProfileLoaded({required this.userData, required this.isEditing});

  ProfileLoaded copyWith({
    Map<String, String>? userData,
    bool? isEditing,
  }) {
    return ProfileLoaded(
      userData: userData ?? this.userData,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileLoggedOut extends ProfileState {}
