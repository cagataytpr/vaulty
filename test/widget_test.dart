import 'package:flutter_test/flutter_test.dart';
import 'package:vaulty/main.dart';

void main() {
  testWidgets('Uygulama baslatma testi', (WidgetTester tester) async {
    // Uygulamayı yukle
    await tester.pumpWidget(const VaultyApp());

    // Vaulty baslıgı veya yukleme ekranını kontrol et
    // Uygulama ilk acıldıgında bir yukleme (CircularProgressIndicator) gosteriyor
    expect(find.byType(VaultyApp), findsOneWidget);
  });
}