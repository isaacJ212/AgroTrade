import 'json_helpers.dart';

class BackendResult<T> {
  final int statusCode;
  final String message;
  final bool isSuccess;
  final T? data;

  const BackendResult({
    required this.statusCode,
    required this.message,
    required this.isSuccess,
    required this.data,
  });

  factory BackendResult.fromJson(
    Map<String, dynamic> json, {
    T Function(Object? json)? dataParser,
  }) {
    final dataValue = json['Data'] ?? json['data'];

    return BackendResult<T>(
      statusCode: readInt(json, const ['StatusCode', 'statusCode']) ?? 0,
      message: readString(json, const ['Message', 'message']) ?? '',
      isSuccess: readBool(json, const ['IsSuccess', 'isSuccess']) ?? false,
      data: dataParser == null || dataValue == null ? dataValue as T? : dataParser(dataValue),
    );
  }
}

