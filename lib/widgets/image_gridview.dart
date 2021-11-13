import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pexel_wall/pages/imageview_page.dart';

Widget buildImageGridView(
  BuildContext context,
  Orientation orientation,
  dynamic provider,
) {
  final crossAxisItemCount = orientation == Orientation.portrait ? 2 : 3;
  return SliverPadding(
    padding: const EdgeInsets.all(16),
    sliver: SliverStaggeredGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final image = provider.images[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImageViewPage(image: image),
                ),
              );
            },
            child: Hero(
              tag: image.id,
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: image.src["medium"]!,
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
              ),
            ),
          );
        },
        childCount: provider.images.length,
      ),
      gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisItemCount,
        staggeredTileCount: provider.images.length,
        staggeredTileBuilder: (index) {
          final image = provider.images[index];
          final aspectRatio = image.height.toDouble() / image.width.toDouble();
          final screenWidth = MediaQuery.of(context).size.width;
          final mainAxisExtent = screenWidth * aspectRatio / crossAxisItemCount;
          return StaggeredTile.extent(
            1,
            mainAxisExtent,
          );
        },
      ),
    ),
  );
}
