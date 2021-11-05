# pexel_wall

Wallpaper app

# Getting Curated list of images from pexel

```
Consumer<CuratedImageProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {         // Widget to show while getting list of curated images
            return const CircularProgressIndicator();
          }

            // Use provider.images to get the list of images

          return ListView.builder(
            itemCount: provider.images.length,
            itemBuilder: (context, index) => CachedNetworkImage(
              imageUrl: provider.images[index].src["original"]!,    // Image url
              placeholder: (_, __) => Container(color: provider.images[index].averageColor)   // Widget to show in place of image while image is loading
            ),
          );
        },
      ),
```
### Possible keys for src: <br>
![image](https://user-images.githubusercontent.com/45752299/140512615-fae37ad6-4a8c-48df-a74a-54d3b290a633.png)


### Initially 20 images will be loaded. To load more images, call ```provider.loadMore()```.


# Getting list of liked images

```
Consumer<LikedImageProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {         // Widget to show while getting list of images
            return const CircularProgressIndicator();
          }

            // Use provider.images to get the list of images

          return ListView.builder(
            itemCount: provider.images.length,
            itemBuilder: (context, index) => CachedNetworkImage(
              imageUrl: provider.images[index].src["original"]!,    // Image url
              placeholder: (_, __) => Container(color: provider.images[index].averageColor)   // Widget to show in place of image while image is loading
            ),
          );
        },
      ),
```
