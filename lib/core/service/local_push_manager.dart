import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final String? type;
  final String? messageId;

  LocalNotification(
      {int? id,
      required this.title,
      required this.body,
      this.payload,
      this.messageId,
      this.type})
      : this.id = id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

class LocalPushManager {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final Random _random = Random();
  final Map<String, List<LocalNotification>> _notificationGroups = {};

  static final LocalPushManager _instance = LocalPushManager._internal();

  LocalPushManager._internal();

  factory LocalPushManager(
      {required Function(NotificationResponse) onFetchedNotification}) {
    _instance._init(onFetchedNotification: onFetchedNotification);
    return _instance;
  }

  Future<void> _init(
      {required Function(NotificationResponse) onFetchedNotification}) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (id, title, body, payload) async {
              LocalNotification notification = LocalNotification(
                title: title ?? '',
                body: body ?? '',
                payload: payload,
              );
              showNotification(notification);
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (notification) {
      onFetchedNotification(notification);
    });
  }

  int _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000) +
        _random.nextInt(100000);
  }

  Future<void> showNotification(LocalNotification localNotification) async {
    if (localNotification.type == null) return;

    final String groupKey = '${localNotification.type}';
    final notificationId = localNotification.id ?? _generateUniqueId();

    // Add notification to group
    _notificationGroups.putIfAbsent(localNotification.type!, () => []);
    _notificationGroups[localNotification.type]!.add(localNotification);

    // Show the individual notification
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      localNotification.type!, // channel id
      localNotification.type!, // channel name
      channelDescription: 'Message notifications',
      importance: Importance.max,
      priority: Priority.high,
      groupKey: groupKey,
      setAsGroupSummary: false,
      autoCancel: true,
      icon: '@mipmap/launcher_icon',
      channelShowBadge: true,
      category: AndroidNotificationCategory.message,
    );

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      localNotification.title,
      localNotification.body,
      NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails(
          threadIdentifier: localNotification.type,
        ),
      ),
    );

    // Show the group summary notification
    final List<String> lines = _notificationGroups[localNotification.type]!
        .map((msg) => msg.body)
        .toList();

    final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
      lines,
      contentTitle: '${lines.length} new messages',
      summaryText:
          '${convertToNormalText(localNotification.type ?? '')} Notifications',
    );

    final AndroidNotificationDetails androidPlatformChannelSpecificsGroup =
        AndroidNotificationDetails(
      localNotification.type!, // channel id
      'Messages', // channel name
      channelDescription: 'Message notifications',
      importance: Importance.max,
      priority: Priority.high,
      groupKey: groupKey,
      setAsGroupSummary: true,
      autoCancel: true,
      icon: '@mipmap/launcher_icon',
      styleInformation: inboxStyleInformation,
      channelShowBadge: true,
      category: AndroidNotificationCategory.message,
    );

    await _flutterLocalNotificationsPlugin.show(
      getGroupId(localNotification.type!),
      '${lines.length} new messages',
      '${localNotification.type}',
      NotificationDetails(
        android: androidPlatformChannelSpecificsGroup,
        iOS: DarwinNotificationDetails(
          threadIdentifier: localNotification.type,
        ),
      ),
    );
  }

  int getGroupId(String type) {
    return (type.hashCode.abs() % 1000) +
        1000; // Ensure positive and unique group ID
  }

  Future<void> cancelNotificationsByType(String type) async {
    if (_notificationGroups.containsKey(type)) {
      for (var notification in _notificationGroups[type]!) {
        await _flutterLocalNotificationsPlugin.cancel(notification.id);
      }
      await _flutterLocalNotificationsPlugin.cancel(getGroupId(type));
      _notificationGroups.remove(type);
    }
  }

  Future<void> cancelNotificationByID(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    for (var type in _notificationGroups.keys) {
      _notificationGroups[type]
          ?.removeWhere((notification) => notification.id == id);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    _notificationGroups.clear();
  }
}

String convertToNormalText(String input) {
  return input
      .split('_')
      .map((word) => word.toLowerCase().capitalize())
      .join(' ');
}

extension StringExtension on String {
  String capitalize() =>
      isNotEmpty ? this[0].toUpperCase() + substring(1).toLowerCase() : '';
}
