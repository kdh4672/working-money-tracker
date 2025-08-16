import 'package:flutter/material.dart';

void main() {
  runApp(const IncomeApp());
}

class IncomeApp extends StatelessWidget {
  const IncomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Income Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const IncomeHomePage(),
    );
  }
}

class IncomeHomePage extends StatefulWidget {
  const IncomeHomePage({super.key});

  @override
  State<IncomeHomePage> createState() => _IncomeHomePageState();
}

class _IncomeHomePageState extends State<IncomeHomePage> {
  double totalIncome = 0.0;
  final List<Map<String, dynamic>> incomeList = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addIncome() {
    final amount = double.tryParse(_amountController.text);
    final description = _descriptionController.text;

    if (amount != null && amount > 0 && description.isNotEmpty) {
      setState(() {
        incomeList.add({
          'amount': amount,
          'description': description,
          'date': DateTime.now(),
        });
        totalIncome += amount;
      });
      _amountController.clear();
      _descriptionController.clear();
      Navigator.pop(context);
    }
  }

  void _showAddIncomeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Income'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addIncome,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Income Tracker'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Total Income',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalIncome.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: incomeList.isEmpty
                ? const Center(
                    child: Text(
                      'No income added yet.\nTap + to add your first income!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: incomeList.length,
                    itemBuilder: (context, index) {
                      final income = incomeList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.attach_money, color: Colors.white),
                          ),
                          title: Text(income['description']),
                          subtitle: Text(
                            '${income['date'].day}/${income['date'].month}/${income['date'].year}',
                          ),
                          trailing: Text(
                            '\$${income['amount'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddIncomeDialog,
        tooltip: 'Add Income',
        child: const Icon(Icons.add),
      ),
    );
  }
}
