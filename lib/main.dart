import 'package:flutter/material.dart';
import 'package:pexel_wall/pages/explore_page.dart';
import 'package:pexel_wall/provider/image_provider.dart';
import 'package:pexel_wall/provider/internet_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => InternetProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider(
            create: (_) => CuratedImageProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider(
            create: (_) => LikedImageProvider(),
            lazy: true,
          ),
        ],
      child: const MaterialApp(
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: ExplorePage(),
      ),
    );
  }
}
