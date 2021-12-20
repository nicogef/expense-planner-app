import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  final Function deleteTransaction;

  const TransactionList(
      {Key? key, required this.transactions, required this.deleteTransaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No transactions',
                    style: themeData.textTheme.subtitle1),
                SizedBox(
                  height: constraints.maxHeight * 0.15,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.7,
                  child: Image.asset('assets/images/waiting.png',
                      fit: BoxFit.cover),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text(
                          '\$ ${transactions[index].amount}',
                        ),
                      ),
                    ),
                  ),
                  title: Text(transactions[index].title,
                      style: themeData.textTheme.subtitle1),
                  subtitle: Text(
                      DateFormat.yMMMd().format(transactions[index].date),
                      style: TextStyle(
                          fontSize: 14,
                          color: themeData.primaryColorDark)),
                  trailing:
                    TextButton.icon(
                          style: TextButton.styleFrom(primary: themeData.errorColor),
                          icon: Icon(
                            Icons.delete,
                            color: themeData.errorColor,
                          ),
                          onPressed: () => deleteTransaction(index),
                          label: MediaQuery.of(context).size.width > 500 ? const Text('Delete Transaction') : const Text(''),
                        )
                ),
              );
            },
          );
  }
}
