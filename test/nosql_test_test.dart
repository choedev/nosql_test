import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nosql_test/nosql/nodql_interface.dart';
import 'package:nosql_test/nosql/oo_nosql.dart';
import 'package:nosql_test/nosql_test.dart';


var testData = {
  "name": "foo",
  "age": 20
};

class FooModel implements NoSqlInterface {
  static String storeName = 'myStore';

  String name;
  int age;

  FooModel(this.name, this.age);

  @override
  Map<String, dynamic> getMap() {
    return {
      "name": name,
      "age": age
    };
  }

  @override
  getKey() {
    return null;
  }

  static dynamic toModel(Map<String, dynamic> map) {
    return FooModel(
        map['name'] ?? '',
        map['age'] ?? 0,
    );
  }

  @override
  String getStoreName() {
    return storeName;
  }
}

void main() {
  const MethodChannel channel = MethodChannel('nosql_test');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await NosqlTest.platformVersion, '42');
  });

  test('create', () async {
    var foo = FooModel('foo', 18);
    var noSql = OoNoSql();

    var key = await noSql.create(foo);
    expect(key, 1);
  });

  test('put', () async {
    var foo = FooModel('foo', 18);
    var noSql = OoNoSql();

    var result = await noSql.createWithKey(11, foo);
    expect(result, true);
  });

  test('get', () async {
    var noSql = OoNoSql();

    var record = await noSql.get(FooModel.storeName, 1);
    expect(record, isNot(null));

    var model = FooModel.toModel(record) as FooModel;
    expect(model.name, 'foo');
  });

  test('findEqual', () async {
    var noSql = OoNoSql();
    var record = await noSql.findEqual(FooModel.storeName, 'name', 'foo', 'name');
    var models = record.map((e) => FooModel.toModel(e) as FooModel).toList();
    expect(models.length, 1);

    var first = models.first;
    expect(first.name, 'foo');
  });

  test('drop', () async {
    var noSql = OoNoSql();

    await noSql.drop(FooModel.storeName);
    var record = await noSql.findEqual(FooModel.storeName, 'name', 'foo', 'name');
    expect(record.length, 0);
  });

  test('delete', () async {
    var noSql = OoNoSql();

    await noSql.delete(FooModel.storeName, 1);
    var record = await noSql.findEqual(FooModel.storeName, 'name', 'foo', 'name');
    expect(record.length, 0);
  });
}
