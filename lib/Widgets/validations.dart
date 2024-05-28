
class Validation{
  static String? nameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill this field.";
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return "Name should contain only alphabetic characters and spaces.";
    } else if (value.trim().length <= 3) {
      return "Name should contain at least 4 characters.";
    }
    return null;
  }


  static String? aadharValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill this field.";
    } else if (value.length != 12) {
      return "Aadhaar should be 12 digits long.";
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Aadhaar should contain only numbers.";
    }
    return null;
  }

  static String? phoneValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill this field.";
    } else if (value.length != 10) {
      return "Phone Number should be 10 digits long.";
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Phone Number should contain only numbers.";
    }
    return null;
  }
  static String? emailAddressValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill this field.";
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return "Please enter a valid email address.";
    }
    return null;
  }

}