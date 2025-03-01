import 'dart:convert';

List<CommentsResponse> commentsResponseFromJson(String str) =>
    List<CommentsResponse>.from(
        json.decode(str).map((x) => CommentsResponse.fromJson(x)));

String commentsResponseToJson(List<CommentsResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentsResponse {
  final int? postId;
  final int? id;
  final String? name;
  final String? email;
  final String? body;

  CommentsResponse({
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  });

  factory CommentsResponse.fromJson(Map<String, dynamic> json) =>
      CommentsResponse(
        postId: json["postId"],
        id: json["id"],
        name: json["name"],
        email: json["email"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "id": id,
        "name": name,
        "email": email,
        "body": body,
      };
}
