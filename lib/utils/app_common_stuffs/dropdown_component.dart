import 'package:flutter/material.dart';
import 'package:iso_net/model/dropdown_model.dart';
import 'package:iso_net/model/dropdown_models/loan_preferences_models.dart';
import 'package:iso_net/model/dropdown_models/userdetail_dropdown_model.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/ui/style/textfield_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';

class DropdownComponent {
  static commonDropdown<T>({required BuildContext context, String? hint, required List<dynamic> items, T? value, final onChanged}) {
    List<DropdownMenuItem<T>> finalItem = [];
    if (T == String) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(e.toString()),
        );
      }).toList();
    } else if (T == DropDownModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            //e['companyName'] ?? "",
            e.companyName ?? "",
            //style: black100Medium22TextStyle(context),
          ),
        );
      }).toList();
    } else if (T == StatesDropDown) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: FittedBox(
            child: Text(
              //e['companyName'] ?? "",
              e.stateName ?? "",
              //style: black100Medium22TextStyle(context),
            ),
          ),
        );
      }).toList();
    } else if (T == ExperienceDropDownModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: FittedBox(
            child: Text(
              //e['companyName'] ?? "",
              e.expType == 'MO'
                  ? e.expValue > 1
                      ? '${e.expValue ?? 0} Months'
                      : '${e.expValue ?? 0} Month'
                  : e.expValue > 1
                      ? e.expValue == 10
                          ? '${e.expValue ?? 0} Years+'
                          : '${e.expValue ?? 0} Years'
                      : '${e.expValue ?? 0} Year',
              //style: black100Medium22TextStyle(context),
            ),
          ),
        );
      }).toList();
    } else if (T == CreditRequirementModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            //e['companyName'] ?? "",
            '${e.reqScore ?? ''}+',
            //style: black100Medium22TextStyle(context),
          ),
        );
      }).toList();
    } else if (T == MinimumTimeListModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            //e['companyName'] ?? "",
            e.bussinessTime ?? '',
            //CommonUtils.removeDecimal(e.bussinessTime ?? 0.0),
            //style: black100Medium22TextStyle(context),
          ),
        );
      }).toList();
    } else if (T == MinimumMonthRevenueListModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            //e['companyName'] ?? "",
            '\$${e.revenue ?? ''}',
            //style: black100Medium22TextStyle(context),
          ),
        );
      }).toList();
    } else if (T == MinimumNSFListModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            //e['companyName'] ?? "",
            '${e.nsfCount ?? 0}',
            //style: black100Medium22TextStyle(context),
          ),
        );
      }).toList();
    } else if (T == MaxFundingAmountListModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            //e['companyName'] ?? "",
            '\$${e.fundingAmount ?? ''}',
            //style: black100Medium22TextStyle(context),
          ),
        );
      }).toList();
    } else if (T == MaxTermLengthListModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            //e['companyName'] ?? "",

            e.type == 'MO'
                ? e.maxTerm > 1
                    ? '${e.maxTerm ?? 0} Months'
                    : '${e.maxTerm ?? 0} Month'
                : e.maxTerm > 1
                    ? '${e.maxTerm ?? 0} Years'
                    : '${e.maxTerm ?? 0} Year',
            //style: black100Medium22TextStyle(context),
          ),
        );
      }).toList();
    } else if (T == StartingBuyRatesListModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            //e['companyName'] ?? "",
            '${e.maxBuyRates ?? ''}',
            //style: black100Medium22TextStyle(context),
          ),
        );
      }).toList();
    } else if (T == MaxUpSellPointsListModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            //e['companyName'] ?? "",
            '${e.sellPoints ?? ''}',
            //style: black100Medium22TextStyle(context),
          ),
        );
      }).toList();
    } else if (T == GetAllIndustryListModel) {
      finalItem = items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            //e['companyName'] ?? "",
            e.industryName ?? "",
            //style: black100Medium22TextStyle(context),
          ),
        );
      }).toList();
    }

    // return Container(
    //   padding: const EdgeInsets.only(left: 10),
    //   decoration: BoxDecoration(
    //     border: Border.all(
    //       color: AppColors.blackColor,
    //     ),
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   child: DropdownButtonHideUnderline(
    //     child: DropdownButton<T>(
    //       isExpanded: true,
    //       items: finalItem,
    //       onChanged: onChanged,
    //       hint: hint,
    //       value: value,
    //       icon: Padding(
    //         padding: EdgeInsets.all(8.w),
    //         child: const Icon(Icons.keyboard_arrow_down_outlined),
    //       ),
    //     ),
    //   ),
    // );

    return DropdownButtonFormField(
      isExpanded: true,
      enableFeedback: false,
      value: value,
      dropdownColor: AppColors.whiteColor,
      menuMaxHeight: MediaQuery.of(context).size.height / 2,
      icon: ImageComponent.loadLocalImage(imageName: AppImages.downArrow),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 16, bottom: 16, left: 18, right: 18),
        hintText: hint,

        hintStyle: ISOTextStyles.hintTextStyle(),
        enabledBorder: TextFieldComponents(context: context).setEnabledBorder(),
        disabledBorder: TextFieldComponents(context: context).setDisableBorder(),
        focusedBorder: TextFieldComponents(context: context).setFocusedBorder(),
      ),
      style: ISOTextStyles.textFieldTextStyle(),
      items: finalItem,
      onChanged: onChanged,
    );
  }
}
