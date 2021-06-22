class NoSqlInterface<T> {

  /// 맵으로 초기화
  NoSqlInterface(Map<String, dynamic> map) {}

  /// 데이터베이스 이름
  String getStoreName() {
    return '';
  }

  /// 특정키를 사용할 경우 키 반환.
  /// 예: firestore id
  dynamic getKey() {
    return null;
  }

  /// 맵을 반환
  Map<String, dynamic> getMap() {
    return {};
  }
}

