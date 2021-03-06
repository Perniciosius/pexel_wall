import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pexel_wall/api/api_key.dart';
import 'package:pexel_wall/api/http_exception.dart';
import 'package:pexel_wall/models/pexel_image.dart';

class PexelApi {
  final _httpClient = http.Client();
  final headers = {"Authorization": API_KEY};

  Future<List<PexelImage>> getCuratedImages({
    required int page,
    required int perPage,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'api.pexels.com',
      path: '/v1/curated/',
      queryParameters: {
        "page": page.toString(),
        "per_page": perPage.toString(),
      },
    );

    final res = await _httpClient.get(uri, headers: headers);
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
        "page": page.toString(),
        "per_page": perPage.toString(),
        "query": tags,
      },
    );

    final res = await _httpClient.get(uri, headers: headers);
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

    final res = await _httpClient.get(uri, headers: headers);
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
