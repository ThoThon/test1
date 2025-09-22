class BaseResponseList<T> {
  final bool success;
  final String message;
  final List<T> data;

  BaseResponseList({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BaseResponseList.fromJson(
    Map<String, dynamic> json, {
    required T Function(dynamic x) func,
  }) {
    List<T> items = [];

    if (json['data'] != null && json['data'] is List) {
      items = (json['data'] as List).map((item) => func(item)).toList();
    }

    return BaseResponseList<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: items,
    );
  }

  bool hasMoreData(int pageSize) {
    return data.length >= pageSize;
  }
}
