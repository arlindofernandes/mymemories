import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './memories_management_screen.dart';

import '../providers/memorie_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Memories'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () =>
                Navigator.of(context).pushNamed(MemoriesManagementScreen.route),
          )
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<MemorieProvider>(context, listen: false).get(),
          builder: (_, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<MemorieProvider>(
                    builder: (ctx, provider, widget) {
                      return ListView.separated(
                          itemBuilder: (ctx, index) {
                            return Hero(
                              tag: provider.getMemories()[index].id as int,
                              child: Card(
                                elevation: 5,
                                child: ListTile(
                                  onTap: () => Navigator.of(context).pushNamed(
                                      MemoriesManagementScreen.route,
                                      arguments:
                                          provider.getMemories()[index].id),
                                  leading: Image.file(File(
                                      provider.getMemories()[index].image as String)),
                                  title: Text(provider
                                      .getMemories()[index]
                                      .formatedAddress as String),
                                  subtitle: Text(provider
                                      .getMemories()[index]
                                      .description as String),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, int sb) => const Divider(),
                          itemCount: provider.getMemories().length);
                    },
                  );
          }),
    );
  }
}
