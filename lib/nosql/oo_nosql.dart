

import 'dart:developer';
import 'dart:ffi';

import 'package:nosql_test/nosql/nodql_interface.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class OoNoSql {
  final TAG = 'OoNoSql';

  final _dbPath = 'nosql.db';
  final revision = 1;

  /// 데이터베이스 열기
  Future<Database> _open() async {
    DatabaseFactory factory = databaseFactoryIo;
    Database db = await factory.openDatabase(_dbPath, version: revision);
    return Future.value(db);
  }

  /// 데이터베이스 닫기
  Future<void> _close(Database db) async {
    await db.close();
  }

  /// 단일 데이터 생성, 키값은 1부터 자동으로 증가하면 생성됨.
  /// 키값을 반환함, 생성 실패시 키값은 -1
  Future<int> set(NoSqlInterface model) async {
    try {
      var db = await _open();

      var store = intMapStoreFactory.store(model.getStoreName());
      var key = await store.add(db, model.getMap());
      _close(db);

      return Future.value(key);

    } catch(e) {
      log('$TAG set error: $e');
    }
    return Future.value(-1);
  }

  /// 특정키와 함까 데이터 생성.
  /// 데이터 생성 결과를 true/false로 반환.
  Future<bool> setWithKey(dynamic key, NoSqlInterface model) async {
    try {
      var db = await _open();

      var store = intMapStoreFactory.store(model.getStoreName());
      await store.record(key).put(db, model.getMap());

      _close(db);
      return Future.value(true);

    } catch(e) {
      log('$TAG setWithKey error: $e');
    }

    return Future.value(false);
  }

  /// 키 데이터 업데이트 (리플레이스)
  Future<bool> update(dynamic key, NoSqlInterface model) async {
    try {
      var db = await _open();

      var store = intMapStoreFactory.store(model.getStoreName());
      await store.record(key).update(db, model.getMap());
      _close(db);
      return Future.value(true);

    } catch(e) {
      log('$TAG put error: $e');
    }

    return Future.value(false);
  }

  /// 키값으로 데이터 반환. 이미 키값을 알고 있는 경우에 사용
  /// 데이터가 한개만 저장됨을 보장할 경우 키값으로 1을 사용
  Future<dynamic> get(String storeName, dynamic key) async {
    try {
      var db = await _open();

      var store = intMapStoreFactory.store(storeName);
      var record = await store.record(key).get(db);

      _close(db);

      return Future.value(record);

    } catch(e) {
      log('$TAG get error: $e');
    }
    return Future.value(null);
  }

  /// 필드값이 같은 데이터 찾기. 리스트를 반환함.
  Future<List<dynamic>> findEqual(String storeName, String field, dynamic value, String sortKey) async {
    try {
      var db = await _open();

      var store = intMapStoreFactory.store(storeName);
      var finder = Finder(filter: Filter.equals(field, value), sortOrders: [SortOrder(sortKey)]);
      var records = await store.find(db, finder: finder);

      _close(db);

      return Future.value(records.map((e) => e.value).toList());

    } catch(e) {
      log('$TAG findEqual: $e');
    }

    return Future.value([]);
  }

  /// 쿼리
  Future<List<dynamic>> query(String storeName, Finder finder) async {
    try {
      var db = await _open();

      var store = intMapStoreFactory.store(storeName);
      var records = await store.find(db, finder: finder);

      _close(db);

      return Future.value(records);

    } catch(e) {
      log('$TAG query: $e');
    }

    return Future.value([]);
  }

  /// 데이터 삭제
  Future<void> delete(String storeName, dynamic key) async {
    try {
      var db = await _open();

      var store = intMapStoreFactory.store(storeName);
      await store.record(key).delete(db);

      _close(db);

      return Future.value(Void);

    } catch(e) {
      log('$TAG delete: $e');
    }
    return Future.value(Void);
  }

  /// 테이블 삭제
  Future<void> drop(String storeName) async {
    try {
      var db = await _open();

      var store = intMapStoreFactory.store(storeName);
      await store.drop(db);

      _close(db);

    } catch(e) {
      log('$TAG drop: $e');
    }
  }

  /// 데이터베이스 삭제
  Future<void> deleteDatabase() async {
    try {
      await databaseFactoryIo.deleteDatabase(_dbPath);
    } catch(e) {
      log('$TAG deleteDatabase: $e');
    }
  }
}

