import 'package:bai1/province_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Province', () {
    test('Should create Province object fromMap', () {
      final mapData = {
        'id': '1',
        'name': 'Hanoi',
        'level': 'City',
      };

      final province = Province.fromMap(mapData);

      expect(province.id, '1');
      expect(province.name, 'Hanoi');
      expect(province.level, 'City');
    });

    test('Should convert Province object to Map', () {
      final province = Province(id: '2', name: 'HCMC', level: 'City');

      final mapData = province.toMap();

      expect(mapData['id'], '2');
      expect(mapData['name'], 'HCMC');
      expect(mapData['level'], 'City');
    });

    test('Should check equality of Province objects', () {
      final province1 = Province(id: '3', name: 'Danang', level: 'City');
      final province2 = Province(id: '3', name: 'Danang', level: 'City');
      final province3 = Province(id: '4', name: 'Hue', level: 'City');

      expect(province1, equals(province2));
      expect(province1, isNot(equals(province3)));
    });

    test('Should convert Province object to JSON', () {
      final province = Province(id: '5', name: 'Can Tho', level: 'City');

      final jsonData = province.toJson();

      expect(jsonData, '{"id":"5","name":"Can Tho","level":"City"}');
    });

    test('Should create Province object from JSON', () {
      final jsonData = '{"id":"6","name":"Nha Trang","level":"City"}';

      final province = Province.fromJson(jsonData);

      expect(province.id, '6');
      expect(province.name, 'Nha Trang');
      expect(province.level, 'City');
    });
  });
}
