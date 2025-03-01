import 'dart:convert';

List<ImageSliderResponse> imageSliderResponseFromJson(String str) =>
    List<ImageSliderResponse>.from(
        json.decode(str).map((x) => ImageSliderResponse.fromJson(x)));

String imageSliderResponseToJson(List<ImageSliderResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageSliderResponse {
  final int? albumId;
  final int? id;
  final String? title;
  final String? url;
  final String? thumbnailUrl;

  ImageSliderResponse({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  factory ImageSliderResponse.fromJson(Map<String, dynamic> json) =>
      ImageSliderResponse(
        albumId: json["albumId"],
        id: json["id"],
        title: json["title"],
        url: json["url"],
        thumbnailUrl: json["thumbnailUrl"],
      );

  Map<String, dynamic> toJson() => {
        "albumId": albumId,
        "id": id,
        "title": title,
        "url": url,
        "thumbnailUrl": thumbnailUrl,
      };
}
