import 'package:flutter/material.dart';

SliverAppBar buildAppBar(String title, {List<Widget>? actions}) => SliverAppBar(
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(title),
      ),
      expandedHeight: 150,
      actions: actions,
    );
