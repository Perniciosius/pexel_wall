import 'package:flutter/material.dart';
import 'package:pexel_wall/api/pexel_api.dart';
import 'package:pexel_wall/models/pexel_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuratedImageProvider with ChangeNotifier {
  final List<PexelImage> _images;
  List<PexelImage> get images => _images;
  final PexelApi _pexelApi;
  bool _isLoading;
  bool get isLoading => _isLoading;
  int _page;

  CuratedImageProvider()
      : _pexelApi = PexelApi(),
        _images = [],
        _isLoading = true,
        _page = 1 {
    _getImages();
  }

  void _getImages({int page = 1, int perPage = 20}) async {
    _isLoading = true;
    notifyListeners();
    final images = await _pexelApi.getCuratedImages(
      page: page,
      perPage: perPage,
    );
    _images.addAll(images);
    _isLoading = false;
    notifyListeners();
  }

  void loadMore() {
    _getImages(page: ++_page);
  }
}

class SearchImageProvider with ChangeNotifier {
  final List<PexelImage> _images;
  List<PexelImage> get images => _images;
  final PexelApi _pexelApi;
  bool _isLoading;
  bool get isLoading => _isLoading;
  int _page;
  final String _tags;

  SearchImageProvider(String tags)
      : _pexelApi = PexelApi(),
        _images = [],
        _isLoading = true,
        _page = 1,
        _tags = tags {
    _searchImages(tags);
  }

  void _searchImages(String tags, {int page = 1, int perPage = 20}) async {
    _isLoading = true;
    notifyListeners();
    final images = await _pexelApi.getImagesByTag(
      tags: tags,
      page: page,
      perPage: perPage,
    );
    _isLoading = false;
    _images.addAll(images);
    notifyListeners();
  }

  void loadMore() {
    _searchImages(_tags, page: ++_page);
  }
}

class LikedImageProvider with ChangeNotifier {
  final List<PexelImage> _images;
  List<PexelImage> get images => _images;
  final PexelApi _pexelApi;
  bool _isLoading;
  bool get isLoading => _isLoading;
  final List<int> _likedImageIds;

  LikedImageProvider()
      : _pexelApi = PexelApi(),
        _images = [],
        _isLoading = true,
        _likedImageIds = [] {
    init();
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    _likedImageIds.addAll(prefs
            .getStringList("LIKED_IMAGES")
            ?.map((e) => int.parse(e))
            .toList() ??
        []);
    _getLikedImages();
  }

  void _updateSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      "LIKED_IMAGES",
      _likedImageIds.map((e) => e.toString()).toList(),
    );
  }

  void _getLikedImages() async {
    _isLoading = true;
    notifyListeners();
    for (final id in _likedImageIds) {
      final image = await _pexelApi.getImageById(id);
      _images.add(image);
    }
    _isLoading = false;
    notifyListeners();
  }

  void likeImage(PexelImage image) {
    _likedImageIds.add(image.id);
    _images.add(image);
    notifyListeners();
    _updateSharedPreference();
  }

  void unlikeImage(int id) {
    _likedImageIds.removeWhere((element) => element == id);
    _images.removeWhere((element) => element.id == id);
    notifyListeners();
    _updateSharedPreference();
  }
}
