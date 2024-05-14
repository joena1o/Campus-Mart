import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const categories = [
  "Accommodation",
  "Gadgets",
  "Clothing",
  "Vouchers",
  "Utensils",
  "Tutor",
  "Services"
];

// const categoriesAll = [
//   "All",
//   "Accommodation",
//   "Gadgets",
//   "Clothing",
//   "Tickets/Vouchers",
//   "Utensils/Tools",
//   "Tutor",
//   "Services"
// ];

var icons = [
  FontAwesomeIcons.houseChimney,
  FontAwesomeIcons.laptopCode,
  FontAwesomeIcons.shirt,
  FontAwesomeIcons.ticket,
  FontAwesomeIcons.kitchenSet,
  FontAwesomeIcons.personChalkboard,
  FontAwesomeIcons.toolbox
];

// var iconsAll = [
//   FontAwesomeIcons.columns,
//   FontAwesomeIcons.houseChimney,
//   FontAwesomeIcons.laptopCode,
//   FontAwesomeIcons.shirt,
//   FontAwesomeIcons.ticket,
//   FontAwesomeIcons.kitchenSet,
//   FontAwesomeIcons.personChalkboard,
//   FontAwesomeIcons.toolbox
// ];


String removeSpecialCharactersAndSpaces(String input) {
  // Define a regular expression pattern to match special characters and spaces
  RegExp specialCharAndSpacePattern = RegExp(r'[^\w\s]');
  // Replace matched characters with an empty string
  String result = input.replaceAll(specialCharAndSpacePattern, '');
  return result.trim();
}