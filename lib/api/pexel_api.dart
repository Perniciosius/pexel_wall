import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pexel_wall/api/http_exception.dart';
import 'package:pexel_wall/models/pexel_image.dart';

class PexelApi {
  final _httpClient = http.Client();

  Future<List<PexelImage>> getCuratedImages({
    required int page,
    required int perPage,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'api.pexels.com',
      path: '/v1/curated/',
      queryParameters: {
        "page": page,
        "per_page": perPage,
      },
    );

    final res = await _httpClient.get(uri);
    if (res.statusCode != 200) {
      throw HTTPException(
        code: res.statusCode,
        message: 'Unable to fetch image from Pexels API.',
      );
    }

    final json = jsonDecode(res.body);
    return PexelImage.getImageListFromJson(json);
  }

  Future<List<PexelImage>> getImagesByTag({
    required String tags,
    required int page,
    required int perPage,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'api.pexels.com',
      path: '/v1/search/',
      queryParameters: {
        "page": page,
        "per_page": perPage,
        "query": tags,
      },
    );

    final res = await _httpClient.get(uri);
    if (res.statusCode != 200) {
      throw HTTPException(
        code: res.statusCode,
        message: 'Unable to fetch image from Pexels API.',
      );
    }

    final json = jsonDecode(res.body);
    return PexelImage.getImageListFromJson(json);
  }

  Future<PexelImage> getImageById(int id) async {
    final uri = Uri(
      scheme: 'https',
      host: 'api.pexels.com',
      path: '/v1/search/$id',
    );

    final res = await _httpClient.get(uri);
    if (res.statusCode != 200) {
      throw HTTPException(
        code: res.statusCode,
        message: 'Unable to fetch image from Pexels API.',
      );
    }

    final json = jsonDecode(res.body);
    return PexelImage.fromJson(json);
  }
}
