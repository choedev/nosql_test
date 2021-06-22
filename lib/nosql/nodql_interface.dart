class NoSqlInterface {
  /// 스토어 이름
  static String storeName = '';

  String getStoreName() {
    return storeName;
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

  /// Map을 모델로 변환
  static dynamic toModel() {
    return null;
  }
}

