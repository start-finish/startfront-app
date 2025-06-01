import 'package:either_dart/either.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dynamic_service.dart';

class DynamicFetchData {
  final DynamicService dynamicService;

  DynamicFetchData({required this.dynamicService});

  Future<Either<String, T>> dynamicFetchData<T>({
    required String name,
    T Function(Map<String, dynamic>)? fromModel,
    required Object? reqBody,
    String? subEndpoint,
    bool? isDynamicRSA,
    bool isLoading = false,
  }) async {
    try {
      // NOTE: Show loading before starting the fetch
      if (isLoading) EasyLoading.show(status: 'loading...');

      final fetchFuture = dynamicService.fetchDynamicData(
        name: name,
        fromModel:
            fromModel != null ? (json) => fromModel(json) : (json) => json as T,
        reqBody: reqBody,
        subEndpoint: subEndpoint,
        isDynamicRSA: isDynamicRSA ?? true,
      );

      final delayFuture = Future.delayed(Duration(seconds: isLoading ? 2 : 0));

      // Wait for both to complete
      final result = await Future.wait([fetchFuture, delayFuture])
          .then((values) => values[0] as Either<String, T>);

      EasyLoading.dismiss();

      return result.fold(
        (error) => Left(error),
        (data) {
          if (data is Map<String, dynamic>) {
            if (data['code'] != "0") {
              return Left(
                  data['message']?.toString() ?? 'Something went wrong!');
            }
          }
          return Right(data);
        },
      );
    } catch (e) {
      // NOTE: Dismiss loading if error occurs
      EasyLoading.dismiss();
      return Left(e.toString());
    }
  }
}
