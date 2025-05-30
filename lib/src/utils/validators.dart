class Validators {
  static String? validateName(String name) {
    if (name.trim().isEmpty) return 'Name is required';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'Name must not contain numbers or special characters';
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (email.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
