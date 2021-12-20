import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _onPressed;

  const NewTransaction({Key? key, required onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _commit() {
    if (_amountController.text.isEmpty) return;
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);
    final date = _selectedDate ?? DateTime.now();
    if (title.isEmpty || amount <= 0) return;
    widget._onPressed(title, amount, date);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) return;
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _commit(),
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: _presentDatePicker,
                        child: Text(
                            DateFormat.yMd()
                                .format(_selectedDate ?? DateTime.now()),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                    onPressed: _commit,
                    child: const Text('Add Transaction',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14))),
              ],
            ),
          )),
    );
  }
}
