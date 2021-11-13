import 'package:flutter/material.dart';

Widget buildNoImageUI() => const SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverFillRemaining(
        child: Center(
          child: Text("No image found"),
        ),
      ),
    );
