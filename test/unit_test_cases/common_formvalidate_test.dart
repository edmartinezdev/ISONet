import 'package:flutter_test/flutter_test.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/validation/validation.dart';

void firstNameValidation({required String firstName}){
  group("firstNameTestCase", () {

    test('First Name Empty Test', () {
      var result = Validation().validateFirstName('');
      expect(result.item2, AppStrings.blankFirstName);
    });
    test('First Name Invalid Test', () {
      var result = Validation().validateFirstName('t');
      expect(result.item2, AppStrings.validateFirstName);
    });
    test('First Name Valid Test', () {
      var result = Validation().validateFirstName(firstName);
      expect(result.item2, '');
    });
  });

}

void lastNameValidation(){
  group("lastNameTestCase", () {

    test('Last Name Empty Test', () {
      var result = Validation().validateLastName('');
      expect(result.item2, AppStrings.blankLastName);
    });
    test('Last Name Invalid Test', () {
      var result = Validation().validateLastName('t');
      expect(result.item2, AppStrings.validateLastName);
    });
    test('Last Name Valid Test', () {
      var result = Validation().validateLastName('Zen');
      expect(result.item2, '');
    });
  });
}


void loginFormValidation({required String email,required String password}){

}