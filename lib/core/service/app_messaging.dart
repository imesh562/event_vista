import 'dart:convert';

class FcmPush {
  FcmPush({
    required this.notification,
    required this.data,
    required this.priority,
    required this.to,
    this.isTopic = false,
  });

  FCMNotification notification;
  FCMData data;
  String priority;
  String to;
  bool isTopic;

  factory FcmPush.fromRawJson(String str) => FcmPush.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FcmPush.fromJson(Map<String, dynamic> json) => FcmPush(
        notification: FCMNotification.fromJson(json["notification"]),
        data: FCMData.fromJson(json["data"]),
        priority: json["priority"],
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "notification": notification.toJson(),
        "data": data,
        "priority": priority,
        "to": isTopic ? '/topics/$to' : to,
      };
}

class FCMData {
  String postId;
  String connectionId;
  String type;

  factory FCMData.fromRawJson(String str) => FCMData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FCMData.fromJson(Map<String, dynamic> json) => FCMData(
        postId: json["postId"] ?? '',
        connectionId: json["connectionId"] ?? '',
        type: json["type"] ?? '',
        // customerName: AppEncrypt().decryptText(json["customer_name"] ?? ''),
        // tradyName: AppEncrypt().decryptText(json["trady_name"] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "connectionId": connectionId,
        "type": type,
      };

  FCMData({
    required this.postId,
    required this.connectionId,
    required this.type,
  });
}

class FCMNotification {
  FCMNotification({
    this.sound,
    required this.title,
    required this.body,
  });

  String? sound;
  String title;
  String body;

  factory FCMNotification.fromRawJson(String str) =>
      FCMNotification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FCMNotification.fromJson(Map<String, dynamic> json) =>
      FCMNotification(
        // sound: json["sound"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        // "sound": sound ?? '',
        "title": title,
        "body": body,
      };
}
