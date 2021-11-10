import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pexel_wall/provider/image_provider.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CuratedImageProvider>(
        builder: (context, provider, _) => OrientationBuilder(
          builder: (context, orientation) {
            final crossAxisItemCount =
                orientation == Orientation.portrait ? 2 : 3;
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
                  SliverAppBar(
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('Explore'),
                    ),
                    expandedHeight: 150,
                  ),
                  if (provider.images.isEmpty && !provider.isLoading)
                    const SliverPadding(
                      padding: EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: Text("No image found"),
                        ),
                      ),
                    ),
                  if (provider.images.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverStaggeredGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final image = provider.images[index];
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: image.src["original"]!,
                                placeholder: (_, __) => Container(
                                  color: image.averageColor,
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color: Colors.grey[400],
                                  child: const Center(
                                    child: Icon(Icons.broken_image),
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          childCount: provider.images.length,
                        ),
                        gridDelegate:
                            SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisItemCount,
                          staggeredTileCount: provider.images.length,
                          staggeredTileBuilder: (index) {
                            final image = provider.images[index];
                            final aspectRatio = image.height.toDouble() /
                                image.width.toDouble();
                            final screenWidth = MediaQuery.of(context).size;
                            final mainAxisExtent = screenWidth.width *
                                aspectRatio /
                                crossAxisItemCount;
                            return StaggeredTile.extent(
                              1,
                              mainAxisExtent,
                            );
                          },
                        ),
                      ),
                    ),
                  if (provider.isLoading)
                    const SliverPadding(
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
