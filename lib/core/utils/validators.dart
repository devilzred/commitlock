// lib/src/utils/validators.dart

class Validators {
  // Validate empty fields
  static String? emptyValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  // Validate only positive integers (no 0, no decimals)
  static String? integerValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    // Check if it's a valid integer
    final intValue = int.tryParse(value);
    if (intValue == null) {
      return 'Please enter a valid integer';
    }
    if (intValue <= 0) {
      return 'Value must be greater than 0';
    }
    return null;
  }

    static String? doubleValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    // Check if it's a valid double
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return 'Please enter a valid number';
    }
    if (doubleValue <= 0) {
      return 'Value must be greater than 0';
    }
    return null;
  }


  // Validate password with minimum 6 characters
  static String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Validate email format
  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
