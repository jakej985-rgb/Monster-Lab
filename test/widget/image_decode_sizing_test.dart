import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/shared/widgets/component_image_view.dart';

void main() {
  testWidgets('ComponentImageView decodes thumbnails at display size × DPR',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(devicePixelRatio: 2.0),
          child: ComponentImageView(
            imagePath: 'assets/images/components/comp_uno.webp',
            width: 56,
            height: 56,
          ),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image;
    expect(provider, isA<ResizeImage>());
    final resized = provider as ResizeImage;
    expect(resized.width, equals(112));
    expect(resized.height, equals(112));
  });

  testWidgets('ComponentImageView avoids cache sizing when dimensions are open',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ComponentImageView(
          imagePath: 'assets/images/components/comp_uno.webp',
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isNot(isA<ResizeImage>()));
  });
}
