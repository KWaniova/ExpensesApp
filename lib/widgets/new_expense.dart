import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense(this.onAddExpense, {super.key});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate = DateTime.now();
  Category _selectedCategory = Category.other;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid data'),
          content: const Text('Please make sure data are valid'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'))
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
    print(_titleController.text);
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 1),
        lastDate: now);
    print(pickedDate);
    if (pickedDate == null) {
      return;
    }
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 50,
      ),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_selectedDate == null
                          ? 'Selected Date: '
                          : formatter.format(_selectedDate!)),
                      IconButton(
                          onPressed: _showDatePicker,
                          icon: const Icon(Icons.calendar_today_outlined))
                    ],
                  )),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                    category.name.toString().toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      }),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitData,
                    child: const Text('Add Expense'),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses =>
      expenses.fold(0, (sum, expense) => sum + expense.amount);
}
