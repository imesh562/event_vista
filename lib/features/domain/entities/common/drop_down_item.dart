import 'dart:ui';

class DropDownItem {
  final String id;
   String fieldText;
  final String? image;
  final String? fieldText2;
  final String? colorCode;
  final Color? iconColor;

  DropDownItem({
    required this.id,
    required this.fieldText,
    this.image,
    this.fieldText2,
    this.colorCode,
    this.iconColor,
  });

  factory DropDownItem.fromJson(Map<String, dynamic> json) => DropDownItem(
        id: json["id"],
        fieldText: json["fieldText"],
        image: json["image"],
        fieldText2: json["fieldText2"],
        colorCode: json["colorCode"],
        iconColor: json["iconColor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fieldText": fieldText,
        "image": image,
        "fieldText2": fieldText2,
        "colorCode": colorCode,
        "iconColor": iconColor,
      };
}
