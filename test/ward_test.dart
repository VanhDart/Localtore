import 'package:bai1/ward_view.dart';
import 'package:flutter_test/flutter_test.dart';//

void main() {
  group('Ward', () {
    test('Create Ward object from map', () {
      final Map<String, dynamic> wardMap = {
        'id': '1',
        'name': 'Ward X',
        'level': 'Level 1',
        'provinceId': '100',
        'districtId': '200',
      };
      final ward = Ward.fromMap(wardMap);

      expect(ward, isNotNull);

 
      expect(ward.id, '1');
      expect(ward.name, 'Ward X');
      expect(ward.level, 'Level 1');
      expect(ward.provinceId, '100');
      expect(ward.districtId, '200');
    });

    test('Convert Ward object to Map', () {

      final ward = Ward(
        id: '2',
        name: 'Ward Y',
        level: 'Level 2',
        provinceId: '300',
        districtId: '400',
      );


      final wardMap = ward.toMap();

   
      expect(wardMap, isNotNull);
      expect(wardMap['id'], '2');
      expect(wardMap['name'], 'Ward Y');
      expect(wardMap['level'], 'Level 2');
      expect(wardMap['provinceId'], '300');
      expect(wardMap['districtId'], '400');
    });
  });
}

