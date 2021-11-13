import 'package:flutter/material.dart';
import 'package:pexel_wall/pages/liked_page.dart';
import 'package:pexel_wall/pages/search_page.dart';
import 'package:pexel_wall/provider/image_provider.dart';
import 'package:pexel_wall/widgets/appbar.dart';
import 'package:pexel_wall/widgets/image_gridview.dart';
import 'package:pexel_wall/widgets/loading_indicator.dart';
import 'package:pexel_wall/widgets/no_image_ui.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CuratedImageProvider>(
        builder: (context, provider, _) => OrientationBuilder(
          builder: (context, orientation) =>
              NotificationListener<ScrollNotification>(
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
                buildAppBar("Explore", actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SearchPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    tooltip: "Liked Images",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LikedPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.favorite),
                  )
                ]),
                if (provider.images.isEmpty && !provider.isLoading)
                  buildNoImageUI(),
                if (provider.images.isNotEmpty)
                  buildImageGridView(context, orientation, provider),
                if (provider.isLoading) buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
