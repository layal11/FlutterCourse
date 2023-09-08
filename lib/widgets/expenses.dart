import 'package:first_flutter_app/widgets/expenses_list/expenses_list.dart';
import 'package:first_flutter_app/models/expense.dart';
import 'package:first_flutter_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final String appBarText = 'Flutter - Expense Tracker';
  final List<Expense> _registeredExpenses = [
    Expense.named(
        title: 'Fast food',
        amount: 10.5,
        date: DateTime.now(),
        category: Categories.food),
    Expense.named(
        title: 'Flutter course',
        amount: 20,
        date: DateTime.now(),
        category: Categories.work),
  ];

  void addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: const Text('Expense deleted'),
        backgroundColor: Colors.blueAccent,
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color.fromARGB(255, 250, 143, 136),
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          const Text('The Chart...'),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
