import 'package:bai1/district_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('District', () {
    test('Create District object from map', () {
     
      final Map<String, dynamic> districtMap = {
        'id': '001',
        'name': 'Quận Ba Đình',
        'level': 'Quận',
        'provinceId': '01'
      };

      final district = District.fromMap(districtMap);

      expect(district, isNotNull);

      expect(district.id, '001');
      expect(district.name, 'Quận Ba Đình');
      expect(district.level, 'Quận');
      expect(district.provinceId, '01');
    });

    test('Convert District object to Map', () {
      final district = District(
        id: '002',
        name: 'Quận Hoàn Kiếm',
        level: 'Quận',
        provinceId: '01',
      );

      final districtMap = district.toMap();

      expect(districtMap, isNotNull);
      expect(districtMap['id'], '002');
      expect(districtMap['name'], 'Quận Hoàn Kiếm');
      expect(districtMap['level'], 'Quận');
      expect(districtMap['provinceId'], '01');
    });
  });
}
