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
  @override
  Map<String, dynamic> getMap() {
    return {
      "name": "foo",
      "age": 21
    };
  }

  @override
  String getStoreName() {
    return "holo5";
  }

  @override
  getKey() {
    return null;
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
    var foo = FooModel();
    var noSql = OoNoSql();

    var key = await noSql.create(foo);
    expect(key, 1);
  });

  test('put', () async {
    var foo = FooModel();
    var noSql = OoNoSql();

    var result = await noSql.createWithKey(11, foo);
    expect(result, true);
  });

  test('get', () async {
    var foo = FooModel();
    var noSql = OoNoSql();

    var record = await noSql.get(foo.getStoreName(), 1);
    expect(record, isNot(null));
  });

  test('findEqual', () async {
    var foo = FooModel();
    var noSql = OoNoSql();

    var record = await noSql.findEqual(foo.getStoreName(), 'name', 'foo', 'name');
    expect(record.length, 1);
  });

  test('drop', () async {
    var foo = FooModel();
    var noSql = OoNoSql();

    await noSql.drop(foo.getStoreName());
    var record = await noSql.findEqual(foo.getStoreName(), 'name', 'foo', 'name');
    expect(record.length, 0);
  });

  test('delete', () async {
    var foo = FooModel();
    var noSql = OoNoSql();

    await noSql.delete(foo.getStoreName(), 5);
    var record = await noSql.findEqual(foo.getStoreName(), 'name', 'foo', 'name');
    expect(record.length, 0);
  });
}
