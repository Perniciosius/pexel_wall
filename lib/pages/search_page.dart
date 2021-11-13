import 'package:flutter/material.dart';
import 'package:pexel_wall/provider/image_provider.dart';
import 'package:pexel_wall/widgets/image_gridview.dart';
import 'package:pexel_wall/widgets/loading_indicator.dart';
import 'package:pexel_wall/widgets/no_image_ui.dart';
import 'package:provider/provider.dart';

class SearchedImageGridView extends StatelessWidget {
  const SearchedImageGridView({Key? key, required this.tags}) : super(key: key);

  final String tags;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider0(
      create: (context) => SearchImageProvider(tags),
      update: (context, _) => SearchImageProvider(tags),
      lazy: false,
      child: Consumer<SearchImageProvider>(
        builder: (context, provider, _) => OrientationBuilder(
          builder: (context, orientation) {
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent &&
                    provider.images.isNotEmpty) {
                  provider.loadMore();
                }
                return true;
              },
              child: CustomScrollView(
                slivers: [
                  if (provider.images.isEmpty && !provider.isLoading)
                    buildNoImageUI(),
                  if (provider.images.isNotEmpty)
                    buildImageGridView(context, orientation, provider),
                  if (provider.isLoading) buildLoadingIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String tags = "";
  late TextEditingController _controller;
  bool _showClearButton = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: ListTile(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Search...",
            ),
            onChanged: (value) {
              setState(() {
                _showClearButton = value.isNotEmpty;
              });
            },
            onSubmitted: (value) {
              setState(() {
                tags = value;
              });
            },
          ),
          trailing: _showClearButton
              ? IconButton(
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      tags = "";
                    });
                  },
                  icon: const Icon(Icons.close),
                )
              : null,
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: tags == "" ? Container() : SearchedImageGridView(tags: tags),
      ),
    );
  }
}
