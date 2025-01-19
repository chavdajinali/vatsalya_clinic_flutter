class ValidationUtils {
  // Validate email
  String? validateEmail(String? email) {
    // Email validation
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (email == null || email.trim().isEmpty) {
      return 'Email is required.';
    } else if (!emailRegex.hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? password) {
    // Password validation: at least 8 characters, 1 punctuation, 1 capital letter, 1 number
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~])(?=.*[0-9]).{8,}$');
    if (!passwordRegex.hasMatch(password!)) {
      return 'Password must be at least 8 characters long, include 1 capital letter, 1 number, and 1 punctuation mark.';
    }

    return null;
  }

  String? validateConfirmPassword(String? password,String? confirmPassword) {
    // Password validation: at least 8 characters, 1 punctuation, 1 capital letter, 1 number
    final passwordRegex =
    RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~])(?=.*[0-9]).{8,}$');
    if (!passwordRegex.hasMatch(password!)) {
      return 'Password must be at least 8 characters long, include 1 capital letter, 1 number, and 1 punctuation mark.';
    }
    if (password != confirmPassword) {
      return 'Password and confirm password must be same.';
    }

    return null;
  }

}
