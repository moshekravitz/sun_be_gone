
class ApiResponse<T> {
  final int statusCode;
  final T? data;
  final String? error;

  ApiResponse({required this.statusCode,required this.data, this.error});
  ApiResponse.bad({required this.statusCode, this.data,required this.error});
}
