import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futtler_tdd_course/core/network/network_info.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker dataConnectionChecker;

  setUp(() {
    dataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(dataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      final testHasConnectionFuture = Future.value(true);
      when(dataConnectionChecker.hasConnection)
          .thenAnswer((_) => testHasConnectionFuture);

      final result = networkInfo.isConnected;

      verify(dataConnectionChecker.hasConnection);
      expect(result, testHasConnectionFuture);
    });
  });
}
