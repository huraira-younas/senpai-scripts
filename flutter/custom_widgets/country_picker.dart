import 'package:glmpse/common_widget/text_field.dart';
import 'package:country_picker/country_picker.dart';
import 'package:glmpse/constants/app_colors.dart';
import 'package:flutter/material.dart';

void buildCountryPicker(BuildContext context, Function(Country) onSelect) {
  showCountryPicker(
    showPhoneCode: true,
    context: context,
    countryListTheme: CountryListThemeData(
      flagSize: 20,
      backgroundColor: AppColors.whiteColor,
      textStyle: const TextStyle(fontSize: 16, color: AppColors.blackColor),
      searchTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
      bottomSheetHeight: 500,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      inputDecoration: customInputDecoration(
        hint: "Search...",
        prefixIcon: const Icon(Icons.search, color: AppColors.blackColor),
      ).copyWith(fillColor: Colors.white.withOpacity(0.2)),
    ),
    onSelect: onSelect,
  );
}
