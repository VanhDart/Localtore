import 'package:bai1/ward_view.dart';
import 'package:flutter_test/flutter_test.dart';//

void main() {
  group('Ward', () {
    test('Create Ward object from map', () {
      // Tạo một đối tượng Map đại diện cho dữ liệu đầu vào
      final Map<String, dynamic> wardMap = {
        'id': '1',
        'name': 'Ward X',
        'level': 'Level 1',
        'provinceId': '100',
        'districtId': '200',
      };

      // Tạo đối tượng Ward từ Map
      final ward = Ward.fromMap(wardMap);

      // Kiểm tra xem đối tượng đã được tạo thành công hay không
      expect(ward, isNotNull);

      // Kiểm tra tính đúng đắn của các trường dữ liệu
      expect(ward.id, '1');
      expect(ward.name, 'Ward X');
      expect(ward.level, 'Level 1');
      expect(ward.provinceId, '100');
      expect(ward.districtId, '200');
    });

    test('Convert Ward object to Map', () {
      // Tạo một đối tượng Ward
      final ward = Ward(
        id: '2',
        name: 'Ward Y',
        level: 'Level 2',
        provinceId: '300',
        districtId: '400',
      );

      // Chuyển đổi đối tượng Ward thành Map
      final wardMap = ward.toMap();

      // Kiểm tra xem Map đã được tạo thành công và chứa đúng các giá trị hay không
      expect(wardMap, isNotNull);
      expect(wardMap['id'], '2');
      expect(wardMap['name'], 'Ward Y');
      expect(wardMap['level'], 'Level 2');
      expect(wardMap['provinceId'], '300');
      expect(wardMap['districtId'], '400');
    });
  });
}

