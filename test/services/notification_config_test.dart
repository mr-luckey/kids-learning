import 'package:flutter_test/flutter_test.dart';
import 'package:kids/core/config/notification_config.dart';

void main() {
  test('NotificationMessage parses JSON maps', () {
    final NotificationMessage message = NotificationMessage.fromJson(
      <String, dynamic>{
        'id': 'daily_001',
        'title': 'Hello',
        'body': 'World',
      },
    );
    expect(message.id, 'daily_001');
    expect(message.title, 'Hello');
    expect(message.body, 'World');
  });

  test('default schedule alternates 17:00 and 21:00', () {
    const NotificationConfig config = NotificationConfig(
      testMode: false,
    );
    expect(config.scheduleTimes, <String>['17:00', '21:00']);
    expect(config.rotationMode, NotificationRotationMode.alternate);
    expect(config.daysToSchedule, 14);
    expect(config.testMode, isFalse);
    expect(config.testIntervalSeconds, 10);
  });

  test('testMode defaults follow kNotificationTestMode', () {
    const NotificationConfig config = NotificationConfig();
    expect(config.testMode, kNotificationTestMode);
    expect(config.testIntervalSeconds, 10);
    expect(config.testNotificationCount, 4);
  });
}
