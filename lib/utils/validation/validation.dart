import 'package:get/get_utils/get_utils.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';
import 'package:tuple/tuple.dart';

import '../app_common_stuffs/app_logger.dart';
import '../app_common_stuffs/strings_constants.dart';

enum ValidationType {
  firstName,
  lastName,
  email,
  password,
  signUpPassword,
  confirmPassword,
  phoneNumber,
  inviteCode,
  termsAndConditions,
  otp,
  city,
  state,
  birthdate,
  dropDownCompany,
  company,
  position,
  experience,
  bio,
  address,
  zipCode,
  description,
  website,
  companyName,
  creditRequirement,
  creditRequirementManual,
  minTimeInBus,
  minMonthlyRev,
  resIndustries,
  maxNsf,
  maxNsfManual,
  resState,
  prefIndustries,
  maxFund,
  maxTerms,
  startBuyRates,
  startBuyRateManual,
  maxUpSells,
  maxUpSellsManual,
  feedCategory,
  feedContent,
  feedImageVideo,
  findFunderState,
  findFunderIndustry,
  loanAmount,
  loanIndustry,
  addTagScoreBoard,
  addIndustries,
  funderBrokerName,
  groupName,
  none
}

class Validation {
  factory Validation() {
    return _singleton;
  }

  static final Validation _singleton = Validation._internal();

  Validation._internal() {
    Logger().v("Instance created Validation");
  }

  Tuple2<bool, String> validateFirstName(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankFirstName;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validateFirstName;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateLastName(String value) {
    String errorMessage = '';

    if (value.isEmpty) {
      errorMessage = AppStrings.blankLastName;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validateLastName;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateEmail(String value) {
    String errorMessage = '';

    if (value.isEmpty) {
      errorMessage = AppStrings.blankEmail;
    } else if (!value.isStringValid() || !value.isEmail) {
      errorMessage = AppStrings.validateEmail;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validatePassword(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankPassword;
    } else if (!value.isStringValid(minLength: 6, maxLength: 16)) {
      errorMessage = AppStrings.validatePassword;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateSignUpPassword(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankPassword;
    } else if (!value.isStringValid(minLength: 6)) {
      errorMessage = AppStrings.signUpPasswordValidate;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateConfirmPassword(String password, String confirmPassword) {
    String errorMessage = '';

    if (confirmPassword.isEmpty) {
      errorMessage = AppStrings.blankConfirmPassword;
    } else if (password != confirmPassword) {
      errorMessage = AppStrings.validateConfirmPassword;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validatePhoneNumber(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankMobileNo;
    } else if (!value.isStringValid(minLength: 14)) {
      errorMessage = AppStrings.validateMobileNo;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateOtp(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankOtp;
    } else if (!value.isStringValid(minLength: 6)) {
      errorMessage = AppStrings.validateOtp;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateCity(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankCity;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validateCity;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateState(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankState;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validateState;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateBirthDate(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankBirthDate;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateCompanyDropDown(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.dBlankCompanyName;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validateCompanyName;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateCompany(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankCompanyName;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validateCompanyName;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validatePosition(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankPosition;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validatePosition;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateExperience(String value) {
    String errorMessage = '';
    if (value.isEmpty || value == '0') {
      errorMessage = AppStrings.blankExperience;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateBio(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankBio;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validateBio;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateAddress(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankAddress;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validateAddress;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateZipCode(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankZipCode;
    } else if (!value.isStringValid(minLength: 5)) {
      errorMessage = AppStrings.validateZipCode;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateDescription(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankDescription;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validateDescription;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateWebsite(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankWebsite;
    } else if (!value.isStringValid()) {
      errorMessage = AppStrings.validateWebsite;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateAgreeTermsCondition(String value) {
    String errorMessage = '';
    if (value == 'false') {
      errorMessage = AppStrings.validateTermsCondition;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateCreditReq(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateCreditRequirement;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateCreditReqManual(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateCreditRequirementAdd;
    } else if (int.parse(value) < 500 || int.parse(value) > 1000) {
      errorMessage = AppStrings.validateCreditReq500to1000;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateMinimumMonthlyRevenue(String value) {
    String errorMessage = '';
    if (value.isEmpty || value == '\$ 0.00') {
      errorMessage = AppStrings.validateMonthlyRevenueAmounts;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateMinimumTimeInBusiness(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateMinimumTimeInBusiness;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateRestrictedIndustries(String value) {
    String errorMessage = '';
    if (value == '[]') {
      errorMessage = AppStrings.validateRestrictedIndustries;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateMaximumOfNSFPerMonth(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateMaximumOfNSFPerMonth;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateMaximumOfNSFPerMonthManual(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateAddMaximumOfNSFPerMonth;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateRestrictedStates(String value) {
    String errorMessage = '';
    if (value == '[]') {
      errorMessage = AppStrings.validateRestrictedStates;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateFindFunderStates(String value) {
    String errorMessage = '';
    if (value == '[]') {
      errorMessage = AppStrings.validateFindFunderState;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateFindFunderIndustries(String value) {
    String errorMessage = '';
    if (value == '[]') {
      errorMessage = AppStrings.validateFindFunderIndustry;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateSelectPreferredIndustries(String value) {
    String errorMessage = '';
    if (value == '[]') {
      errorMessage = AppStrings.validateSelectPreferredIndustries;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateMaximumFundingAmounts(String value) {
    String errorMessage = '';
    if (value.isEmpty || value == '\$ 0.00') {
      errorMessage = AppStrings.validateMaximumFundingAmounts;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateMaximumTermLength(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateMaximumTermLength;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateStartingBuyRates(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateStartingBuyRates;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateStartingBuyRatesManual(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateAddStartingBuyRates;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateMaxUpsellPoints(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateMaxUpsellPoints;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateMaxUpsellPointsManual(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateAddMaxUpsellPoints;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateFeedCategory(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateCategories;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateContent(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateContent;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateLoanAmount(String value) {
    String errorMessage = '';
    if (value.isEmpty || value == '\$ 0.00') {
      errorMessage = AppStrings.loanAmountValidation;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateLoanIndustry(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.loanIndustryValidation;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateAddTagScoreboard(String value) {
    String errorMessage = '';
    if (value == '[]') {
      errorMessage = AppStrings.validateAddTagScoreboard;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateSelectedIndustries(String value) {
    String errorMessage = '';
    if (value == '[]') {
      errorMessage = AppStrings.validateSelectedIndustries;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateFunderBrokerName(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateFunderBrokerName;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple2<bool, String> validateGroupName(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.validateGroupName;
    }
    return Tuple2(errorMessage.isEmpty, errorMessage);
  }

  Tuple3<bool, String, String> validateEmailTest(String value) {
    String errorMessage = '';

    if (value.isEmpty) {
      errorMessage = AppStrings.blankEmail;
      return Tuple3(false, errorMessage, value);
    } else if (!value.isStringValid() || !value.isEmail) {
      errorMessage = AppStrings.validateEmail;
      return Tuple3(false, errorMessage, value);
    }
    return Tuple3(errorMessage.isEmpty, errorMessage, value);
  }

  Tuple3<bool, String, String> validatePasswordTest(String value) {
    String errorMessage = '';
    if (value.isEmpty) {
      errorMessage = AppStrings.blankPassword;
    } else if (!value.isStringValid(minLength: 6, maxLength: 16)) {
      errorMessage = AppStrings.validatePassword;
    }
    return Tuple3(errorMessage.isEmpty, errorMessage, value);
  }

  Tuple3<bool, String, ValidationType> checkValidationForTextFieldWithType({List<Tuple2<ValidationType, String>>? list}) {
    Tuple3<bool, String, ValidationType> isValid = const Tuple3(true, '', ValidationType.none);

    for (Tuple2<ValidationType, String> textOption in list ?? []) {
      if (textOption.item1 == ValidationType.firstName) {
        final res = validateFirstName(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.firstName);
      } else if (textOption.item1 == ValidationType.lastName) {
        final res = validateLastName(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.lastName);
      } else if (textOption.item1 == ValidationType.email) {
        final res = validateEmail(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.email);
      } else if (textOption.item1 == ValidationType.password) {
        final res = validatePassword(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.password);
      } else if (textOption.item1 == ValidationType.signUpPassword) {
        final res = validateSignUpPassword(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.signUpPassword);
      } else if (textOption.item1 == ValidationType.phoneNumber) {
        final res = validatePhoneNumber(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.phoneNumber);
      } else if (textOption.item1 == ValidationType.termsAndConditions) {
        final res = validateAgreeTermsCondition(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.termsAndConditions);
      } else if (textOption.item1 == ValidationType.otp) {
        final res = validateOtp(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.otp);
      } else if (textOption.item1 == ValidationType.city) {
        final res = validateCity(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.city);
      } else if (textOption.item1 == ValidationType.state) {
        final res = validateState(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.state);
      } else if (textOption.item1 == ValidationType.birthdate) {
        final res = validateBirthDate(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.birthdate);
      } else if (textOption.item1 == ValidationType.company) {
        final res = validateCompany(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.company);
      } else if (textOption.item1 == ValidationType.dropDownCompany) {
        final res = validateCompanyDropDown(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.company);
      } else if (textOption.item1 == ValidationType.position) {
        final res = validatePosition(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.position);
      } else if (textOption.item1 == ValidationType.experience) {
        final res = validateExperience(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.experience);
      } else if (textOption.item1 == ValidationType.bio) {
        final res = validateBio(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.bio);
      } else if (textOption.item1 == ValidationType.address) {
        final res = validateAddress(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.address);
      } else if (textOption.item1 == ValidationType.zipCode) {
        final res = validateZipCode(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.zipCode);
      } else if (textOption.item1 == ValidationType.description) {
        final res = validateDescription(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.description);
      } else if (textOption.item1 == ValidationType.website) {
        final res = validateWebsite(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.website);
      } else if (textOption.item1 == ValidationType.creditRequirement) {
        final res = validateCreditReq(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.creditRequirement);
      } else if (textOption.item1 == ValidationType.creditRequirementManual) {
        final res = validateCreditReqManual(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.creditRequirementManual);
      } else if (textOption.item1 == ValidationType.minTimeInBus) {
        final res = validateMinimumTimeInBusiness(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.minTimeInBus);
      } else if (textOption.item1 == ValidationType.minMonthlyRev) {
        final res = validateMinimumMonthlyRevenue(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.minMonthlyRev);
      } else if (textOption.item1 == ValidationType.resIndustries) {
        final res = validateRestrictedIndustries(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.resIndustries);
      } else if (textOption.item1 == ValidationType.maxNsf) {
        final res = validateMaximumOfNSFPerMonth(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.maxNsf);
      } else if (textOption.item1 == ValidationType.maxNsfManual) {
        final res = validateMaximumOfNSFPerMonthManual(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.maxNsfManual);
      } else if (textOption.item1 == ValidationType.resState) {
        final res = validateRestrictedStates(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.resState);
      } else if (textOption.item1 == ValidationType.prefIndustries) {
        final res = validateSelectPreferredIndustries(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.prefIndustries);
      } else if (textOption.item1 == ValidationType.maxFund) {
        final res = validateMaximumFundingAmounts(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.maxFund);
      } else if (textOption.item1 == ValidationType.maxTerms) {
        final res = validateMaximumTermLength(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.maxTerms);
      } else if (textOption.item1 == ValidationType.startBuyRates) {
        final res = validateStartingBuyRates(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.startBuyRates);
      } else if (textOption.item1 == ValidationType.startBuyRateManual) {
        final res = validateStartingBuyRatesManual(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.startBuyRateManual);
      } else if (textOption.item1 == ValidationType.maxUpSells) {
        final res = validateMaxUpsellPoints(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.maxUpSells);
      } else if (textOption.item1 == ValidationType.maxUpSellsManual) {
        final res = validateMaxUpsellPointsManual(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.maxUpSellsManual);
      } else if (textOption.item1 == ValidationType.feedCategory) {
        final res = validateFeedCategory(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.feedCategory);
      } else if (textOption.item1 == ValidationType.feedContent) {
        final res = validateContent(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.feedContent);
      } else if (textOption.item1 == ValidationType.loanAmount) {
        final res = validateLoanAmount(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.loanAmount);
      } else if (textOption.item1 == ValidationType.loanIndustry) {
        final res = validateLoanIndustry(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.loanIndustry);
      } else if (textOption.item1 == ValidationType.addTagScoreBoard) {
        final res = validateAddTagScoreboard(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.addTagScoreBoard);
      } else if (textOption.item1 == ValidationType.addIndustries) {
        final res = validateSelectedIndustries(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.addIndustries);
      } else if (textOption.item1 == ValidationType.findFunderState) {
        final res = validateFindFunderStates(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.findFunderState);
      } else if (textOption.item1 == ValidationType.findFunderIndustry) {
        final res = validateFindFunderIndustries(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.findFunderIndustry);
      } else if (textOption.item1 == ValidationType.funderBrokerName) {
        final res = validateFunderBrokerName(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.funderBrokerName);
      } else if (textOption.item1 == ValidationType.groupName) {
        final res = validateGroupName(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.groupName);
      }
      if (!isValid.item1) {
        break;
      }
    }
    return isValid;
  }
}
