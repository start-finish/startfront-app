class ApiResponse<T> {
  final String? msgId;
  final String? errorCode;
  final String? errorMessage;
  final T? data;

  ApiResponse({
    this.msgId,
    this.errorCode,
    this.errorMessage,
    this.data,
  });

  bool get isSuccess => errorCode == null || errorCode == '0' || errorCode == 'SUCCESS';

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      msgId: json['msgId'] as String?,
      errorCode: json['errorCode']?.toString(),
      errorMessage: json['errorMessage'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(msgId: $msgId, errorCode: $errorCode, errorMessage: $errorMessage, data: $data)';
  }
}
