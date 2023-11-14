
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    await dotenv.load(fileName: '.env');
  });

  test('test env', () async {
    expect(dotenv.env['SERVER_URL'], 'https://gtfsapi-production.up.railway.app');
    expect(dotenv.env['SERVER_URL'].runtimeType, String);
  });
}
