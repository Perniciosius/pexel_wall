import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pexel_wall/pages/explore_page.dart';
import 'package:pexel_wall/provider/image_provider.dart';
import 'package:pexel_wall/provider/internet_provider.dart';
import 'package:provider/provider.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
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
      child: MaterialApp(
        theme: ThemeData.light()
          ..textTheme.apply(
            fontFamily: GoogleFonts.varelaRound().fontFamily,
          ),
        darkTheme: ThemeData.dark()
          ..textTheme.apply(
            fontFamily: GoogleFonts.varelaRound().fontFamily,
          ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const ExplorePage(),
      ),
    );
  }
}
