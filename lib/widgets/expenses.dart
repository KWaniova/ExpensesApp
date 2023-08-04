import 'package:dices_app/widgets/chart/chart.dart';
import 'package:flutter/material.dart';

import 'package:dices_app/models/expense.dart';
import 'package:dices_app/widgets/expenses_list/expenses_list.dart';

import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Food',
        amount: 100,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Transportation',
        amount: 50,
        date: DateTime.now(),
        category: Category.transportation),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
        duration: const Duration(seconds: 3),
        content: const Text('Expense removed')));
  }

  void _openAddExpenseModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(_addExpense);
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses yet'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseModal, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          const SizedBox(
            height: 16,
          ),
          Expanded(child: mainContent)
        ],
      ),
    );
  }
}
