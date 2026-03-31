// background_service.dart
import 'package:flutter/material.dart';
import 'package:pillscheduler/services/notification_service.dart';

@pragma('vm:entry-point')
void backgroundNotificationCallback() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initialize();
}