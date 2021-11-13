import 'package:flutter/material.dart';
import 'package:pexel_wall/provider/image_provider.dart';
import 'package:pexel_wall/widgets/appbar.dart';
import 'package:pexel_wall/widgets/image_gridview.dart';
import 'package:pexel_wall/widgets/loading_indicator.dart';
import 'package:pexel_wall/widgets/no_image_ui.dart';
import 'package:provider/provider.dart';

class LikedPage extends StatelessWidget {
  const LikedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LikedImageProvider>(
        builder: (context, provider, _) {
          return OrientationBuilder(
            builder: (context, orientation) => CustomScrollView(
              slivers: [
                buildAppBar("Liked Images"),
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
    );
  }
}
