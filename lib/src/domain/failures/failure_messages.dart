// ignore_for_file: constant_identifier_names

enum FAILURE {
  GENERAL(message: 'Something went wrong. Please try again later.'),
  UNKNOWN(message: 'Unknown Failure. Please try again later.'),
  NETWORK(
      message:
          'We can\'t connect to the server. Please check your internet connection.'),
  ASSET(message: 'We can\'t fetch assets right now. Please try again later.'),
  COMPONENT(
      message: 'We can\'t fetch components right now. Please try again later.'),
  LOCATION(
      message: 'We can\'t fetch locations right now. Please try again later.'),
  COMPANY(
      message: 'We can\'t fetch companies right now. Please try again later.'),
  ;

  const FAILURE({
    required this.message,
  });

  final String message;
}
