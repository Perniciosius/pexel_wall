import 'package:flutter/material.dart';

class PexelImage {
  int id;
  int width;
  int height;
  int? photographerId;

  String url;
  String? photographer;
  String? photographerUrl;

  Color averageColor;

  Map<String, String> src;

  PexelImage({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    this.photographer,
    this.photographerId,
    this.photographerUrl,
    required this.averageColor,
    required this.src,
  });

  factory PexelImage.fromJson(Map<String, dynamic> json) => PexelImage(
        id: json["id"] as int,
        width: json["width"] as int,
        height: json["height"] as int,
        url: json["url"] as String,
        photographer: json["photographer"] as String,
        photographerId: json["photographer_id"] as int,
        photographerUrl: json["photographer_url"] as String,
        averageColor: Color(
          int.parse(
            (json["avg_color"] as String).replaceFirst('#', 'FF'),
            radix: 16,
          ),
        ),
        src: {
          "original": json["src"]["original"],
          "large2x": json["src"]["large2x"],
          "large": json["src"]["large"],
          "medium": json["src"]["medium"],
          "small": json["src"]["small"],
          "portrait": json["src"]["portrait"],
          "landscape": json["src"]["tiny"],
          "tiny": json["src"]["tiny"],
        },
      );

  static List<PexelImage> getImageListFromJson(Map<String, dynamic> json) {
    List<PexelImage> images = [];
    for (final item in json["photos"]) {
      images.add(PexelImage.fromJson(item));
    }
    return images;
  }
}
