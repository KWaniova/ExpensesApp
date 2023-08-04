import 'package:dices_app/widgets/expenses_list/expense_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/expense.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, idx) => Dismissible(
          background: Container(
              alignment: Alignment.centerRight,
              color: Theme.of(context).colorScheme.error,
              margin: EdgeInsets.symmetric(
                  horizontal: Theme.of(context).cardTheme.margin!.horizontal),
              child: const Icon(Icons.delete, color: Colors.white)),
          key: ValueKey(expenses[idx].id),
          onDismissed: (direction) {
            onRemoveExpense(expenses[idx]);
          },
          child: ExpenseItem(expense: expenses[idx])),
      itemCount: expenses.length,
    );
  }
}
