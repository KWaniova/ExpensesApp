import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

enum Category {
  food,
  transportation,
  entertainment,
  clothing,
  health,
  education,
  gifts,
  other,
}

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.transportation: Icons.directions_bus,
  Category.entertainment: Icons.movie,
  Category.clothing: Icons.shopping_bag,
  Category.health: Icons.medical_services,
  Category.education: Icons.school,
  Category.gifts: Icons.card_giftcard,
  Category.other: Icons.money,
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();

  String get dateFormatted {
    return formatter.format(date);
  }
}
