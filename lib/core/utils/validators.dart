class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    if (value.length > 320) {
      return 'Email must be less than 320 characters';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (value.length > 72) {
      return 'Password must be less than 72 characters';
    }

    // Check for ASCII characters only
    final asciiRegex = RegExp(r'^[\x00-\x7F]*$');
    if (!asciiRegex.hasMatch(value)) {
      return 'Password must contain only ASCII characters';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }

    if (value.length > 100) {
      return 'Name must be less than 100 characters';
    }

    // Check for ASCII characters only
    final asciiRegex = RegExp(r'^[\x00-\x7F]*$');
    if (!asciiRegex.hasMatch(value)) {
      return 'Name must contain only ASCII characters';
    }

    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    // Assuming OTP is 6 digits
    if (value.length != 6 || !RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter a valid 6-digit OTP';
    }

    return null;
  }
}
