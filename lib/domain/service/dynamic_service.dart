import 'package:either_dart/either.dart';

import '../../../../config.dart';
import 'auth_storage.dart';
import 'base_service.dart';

class DynamicService extends BaseService {
  final String _baseUrl = ConfigEnvironments.getEnvironments()['url']!;
  final AuthStorage _authStorage = AuthStorage();

  // Example: Fetch dynamic data from API with a generic model
  Future<Either<String, T>> fetchDynamicData<T>({
    required String name,
    T Function(Map<String, dynamic>)? fromModel,
    String? subEndpoint,
    Object? reqBody,
    bool isDynamicRSA = true,
  }) async {
    String endpoint = '$_baseUrl/api/$subEndpoint';

    await loadAuthHeader();

    final userInfo = await _authStorage.getUserInfo();

    final responseEither = await trySecureEitherPost<Map<String, dynamic>>(
      endpoint,
      isDynamicRSA,
      reqBody: reqBody,
      name: name,
    );

    return responseEither.fold(
      (error) => Left(error),
      (data) {
        try {
          // Now, we just use the data returned directly.
          if (fromModel != null) {
            final model = fromModel(data);
            return Right(model);
          }

          // If fromModel is not provided, return the raw Map data.
          if (fromModel == null) {
            return Right(data as T);
          }

          print('>>>>> Response Someting Wrong! <<<<<');
          return Left('Something Wrong');
        } catch (error) {
          print('>>>>> Response Error! <<<<<');
          print('Error: $error');
          return const Left('Invalid response format');
        }
      },
    );
  }
}
