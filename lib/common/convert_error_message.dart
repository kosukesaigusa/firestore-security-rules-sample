String convertErrorMessage(e) {
  try {
    switch (e.code) {
      case 'user-not-found':
        return 'User not found.';
      case 'user-disabled':
        return 'User is invalid.';
      case 'wrong-password':
        return 'The password is incorrect.';
      case 'too-many-requests':
        return 'Please wait a while and try again.';
      case 'invalid-email':
        return 'Please enter your email address in the correct format.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'requires-recent-login':
        return 'Please log out and try again.';
      case 'network-request-failed':
        return 'Please check your network and try again.';
      default:
        return 'An error occurred.';
    }
  } catch (e) {
    return 'An error occurred.';
  }
}
