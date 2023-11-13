import 'package:sun_be_gone/models/api_response.dart' show ApiResponse;
import 'package:sun_be_gone/utils/logger.dart';

enum ErrorType {
  networkConnection,
  serverDown,
  badRequest,
  otherServerError,
  apiError,
  appError,
  other,
}

class Errors {
  final ErrorType type;
  late final String message;
  final Error? error;
  final ApiResponse? apiResponse;

  Errors(
    this.type,
    this.error,
    this.apiResponse,
  ) {
    message = _getMessage(type);

    //log the error
    logger.e('Error', error);
  }

  String _getMessage(ErrorType type) {
    return switch (type) {
      ErrorType.networkConnection => 'Network connection is unavailable. Please check your internet connection and try again.',
      ErrorType.serverDown => 'Server is down. Please try again later.',
      ErrorType.badRequest => 'something went wrong. Please try again later.',
      ErrorType.otherServerError => 'something went wrong. Please try again later.',
      ErrorType.apiError => 'something went wrong. Please try again later.',
      ErrorType.appError => 'something went wrong. Please try again later.',
      ErrorType.other => 'something went wrong. Please try again later.',
    };
  }
}
