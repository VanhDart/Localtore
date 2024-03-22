import 'package:flutter_test/flutter_test.dart';
import 'package:bai1/address_info.dart';
import 'package:bai1/user_info.dart';

void main() {
  group('UserInfo', () {
    test('fromJson', () {
      final userInfoMap = {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phoneNumber': '123456789',
        'birthDate': '1990-01-01',
        'address': {
          'province': {'name': 'Province A'},
          'district': {'name': 'District X'},
          'ward': {'name': 'Ward Y'},
          'street': '123 Street Name'
        },
      };

      final userInfo = UserInfo.fromMap(userInfoMap);

      expect(userInfo.name, 'John Doe');
      expect(userInfo.email, 'john.doe@example.com');
      expect(userInfo.phoneNumber, '123456789');
      expect(userInfo.birthDate, DateTime(1990, 01, 01));
      expect(userInfo.address, isNotNull);
      expect(userInfo.address!.province!.name, 'Province A');
      expect(userInfo.address!.district!.name, 'District X');
      expect(userInfo.address!.ward!.name, 'Ward Y');
      expect(userInfo.address!.street, '123 Street Name');
    });
  });

  group('AddressInfo', () {
    test('fromJson', () {
      final addressInfoMap = {
        'province': {'name': 'Province A'},
        'district': {'name': 'District X'},
        'ward': {'name': 'Ward Y'},
        'street': '123 Street Name',
      };

      final addressInfo = AddressInfo.fromMap(addressInfoMap);

      expect(addressInfo.province!.name, 'Province A');
      expect(addressInfo.district!.name, 'District X');
      expect(addressInfo.ward!.name, 'Ward Y');
      expect(addressInfo.street, '123 Street Name');
    });
  });
}
