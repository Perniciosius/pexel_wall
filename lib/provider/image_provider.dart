import 'package:flutter/material.dart';
import 'package:pexel_wall/api/pexel_api.dart';
import 'package:pexel_wall/models/pexel_image.dart';

class CuratedImageProvider with ChangeNotifier {
  final List<PexelImage> images;
  final PexelApi _pexelApi;
  bool _isLoading;
  bool get isLoading => _isLoading;

  CuratedImageProvider()
      : _pexelApi = PexelApi(),
        images = [],
        _isLoading = true {
    getImages();
  }

  void getImages({int page = 1, int perPage = 20}) async {
    _isLoading = true;
    notifyListeners();
    final images = await _pexelApi.getCuratedImages(
      page: page,
      perPage: perPage,
    );
    this.images.addAll(images);
    _isLoading = false;
    notifyListeners();
  }

  void loadImageById(int id) async {
    _isLoading = true;
    notifyListeners();
    final image = await _pexelApi.getImageById(id);
    images.add(image);
    _isLoading = false;
    notifyListeners();
  }
}

class SearchImageProvider with ChangeNotifier {
  final List<PexelImage> images;
  final PexelApi _pexelApi;
  bool _isLoading;
  bool get isLoading => _isLoading;

  SearchImageProvider(String tags)
      : _pexelApi = PexelApi(),
        images = [],
        _isLoading = true {
    searchImages(tags);
  }

  void searchImages(String tags, {int page = 1, int perPage = 20}) async {
    _isLoading = true;
    notifyListeners();
    final images = await _pexelApi.getImagesByTag(
      tags: tags,
      page: page,
      perPage: perPage,
    );
    _isLoading = false;
    this.images.addAll(images);
    notifyListeners();
  }
}

class LikedImageProvider with ChangeNotifier {
  final List<PexelImage> images;
  final PexelApi _pexelApi;
  bool _isLoading;
  bool get isLoading => _isLoading;
  final List<int> _likedImageIds;

  LikedImageProvider()
      : _pexelApi = PexelApi(),
        images = [],
        _isLoading = true,
        _likedImageIds = [] {
    getLikedImages();
  }

  void getLikedImages() async {
    _isLoading = true;
    notifyListeners();
    for (final id in _likedImageIds) {
      final image = await _pexelApi.getImageById(id);
      images.add(image);
    }
    _isLoading = false;
    notifyListeners();
  }

  void likeImage(PexelImage image) {
    _likedImageIds.add(image.id);
    images.add(image);
    notifyListeners();
  }

  void unlikeImage(int id) {
    _likedImageIds.removeWhere((element) => element == id);
    images.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
