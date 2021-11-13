import 'package:flutter/material.dart';

Widget buildLoadingIndicator() => const SliverPadding(
      sliver: SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      padding: EdgeInsets.all(16),
    );
