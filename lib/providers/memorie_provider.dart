import 'package:flutter/material.dart';

import '../models/memorie.dart';

import '../utils/db_utils.dart';

class MemorieProvider with ChangeNotifier {
  static const String table = 'memorie';
  DbUtils dbUtils = DbUtils();
  List<Memorie> _memories = [];

  List<Memorie> getMemories() {
    return _memories;
  }

  Future<void> save(Memorie memorie) async {
    try {
      await dbUtils.save(table, memorie.toMap());
      await get();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> get() async {
    _memories = [];
    List<Map<String, Object?>> memories = await dbUtils.get(table);

    for (var item in memories) {
      Memorie memorieToAdd = Memorie(
        item['id'] as int,
        item['description'] as String,
        item['formatedAddress'] as String,
        item['image'] as String,
        item['latitude'] as double,
        item['longitude'] as double,
      );
      _memories.add(memorieToAdd);
    }

    notifyListeners();
  }

  Memorie getById(int id) {
    return _memories.firstWhere((element) => element.id == id);
  }
}
