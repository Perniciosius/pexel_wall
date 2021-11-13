import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pexel_wall/models/pexel_image.dart';
import 'package:pexel_wall/provider/image_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageViewPage extends StatelessWidget {
  const ImageViewPage({Key? key, required this.image}) : super(key: key);

  final PexelImage image;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: image.id,
            child: ExtendedImage.network(
              image.src["original"]!,
              mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (_) => GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
                initialAlignment: InitialAlignment.center,
              ),
              fit: BoxFit.contain,
              height: size.height,
            ),
          ),
          Positioned(
            left: 0.03 * size.width,
            top: 0.05 * size.height,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            right: 0.03 * size.width,
            top: 0.05 * size.height,
            child: Row(
              children: [
                Builder(builder: (context) {
                  return IconButton(
                    onPressed: () {
                      showBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => BottomSheet(
                          backgroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          elevation: 10,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: Table(
                              children: [
                                TableRow(
                                  children: [
                                    ListTile(
                                      title: Text('${image.height} px'),
                                      subtitle: const Text("Height"),
                                    ),
                                    ListTile(
                                      title: Text('${image.width} px'),
                                      subtitle: const Text("Width"),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    ListTile(
                                      title:
                                          Text(image.photographer ?? "Unknown"),
                                      subtitle: const Text("Photographer Name"),
                                    ),
                                    ListTile(
                                      title: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.link),
                                      ),
                                      subtitle: const Text(
                                          "Photographer Profile Link"),
                                      onTap: () async {
                                        if (image.photographerUrl != null) {
                                          await canLaunch(
                                                  image.photographerUrl!)
                                              ? await launch(
                                                  image.photographerUrl!)
                                              : throw "Could not launch ${image.photographerUrl}";
                                        }
                                      },
                                    )
                                  ],
                                ),
                                TableRow(children: [
                                  ListTile(
                                    title: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(Icons.link),
                                    ),
                                    subtitle: const Text("Image Link"),
                                    onTap: () async {
                                      await canLaunch(image.url)
                                          ? await launch(image.url)
                                          : throw 'Could not launch ${image.url}';
                                    },
                                  ),
                                  const ListTile(),
                                ])
                              ],
                            ),
                          ),
                          onClosing: () {},
                        ),
                      );
                    },
                    icon: const Icon(Icons.info),
                  );
                }),
                Consumer<LikedImageProvider>(
                  builder: (context, provider, _) {
                    return IconButton(
                      onPressed: () {
                        if (provider.images.contains(image)) {
                          provider.unlikeImage(image.id);
                        } else {
                          provider.likeImage(image);
                        }
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: !provider.isLoading &&
                                provider.images.contains(image)
                            ? Colors.red
                            : Colors.white,
                      ),
                    );
                  },
                ),
                if (Platform.isAndroid) ...{
                  IconButton(
                    onPressed: () {
                      downloadImage(context);
                    },
                    icon: const Icon(Icons.download),
                  )
                }
              ],
            ),
          )
        ],
      ),
    );
  }

  void downloadImage(BuildContext context) async {
    if (!await Permission.storage.isGranted) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to save file. Permission denied."),
          ),
        );
        return;
      }
    }
    final snackBar = ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Downloading Image...."),
        duration: Duration(days: 1),
      ),
    );
    final fileName = Uri.parse(image.src['original']!).pathSegments.last;
    final filePath = '/storage/emulated/0/Download/$fileName';
    final imageFile =
        await DefaultCacheManager().getSingleFile(image.src['original']!);
    await imageFile.copy(filePath);
    snackBar.close();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Image downloaded in Downloads directory."),
      ),
    );
  }
}
