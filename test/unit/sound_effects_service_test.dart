import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/sound_effects_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SoundEffectsService respects the enabled setting',
      (tester) async {
    final played = <Object?>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'SystemSound.play') {
        played.add(call.arguments);
      }
      return null;
    });
    addTearDown(() {
      messenger.setMockMethodCallHandler(SystemChannels.platform, null);
    });

    const disabled = SoundEffectsService(enabled: false);
    disabled.success();
    disabled.error();
    await tester.pump();
    expect(played, isEmpty);

    const enabled = SoundEffectsService(enabled: true);
    enabled.success();
    await tester.pump();
    expect(played, ['SystemSoundType.click']);

    enabled.error();
    await tester.pump();
    expect(played, ['SystemSoundType.click', 'SystemSoundType.alert']);
  });
}
