import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Planner',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Quicksand',
          // errorColor: Colors.red,
          textTheme: ThemeData.light().textTheme.copyWith(
                subtitle1: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: Colors.blue)),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(primary: Colors.blue),
          ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
      darkTheme: ThemeData(primarySwatch: Colors.grey),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  bool _showChart = false;

  final List<Transaction> _userTransactions = [
    Transaction(
        id: 'T1',
        title: 'Shoes',
        amount: 5,
        date: DateTime.now().subtract(const Duration(days: 6, hours: 7))),
    Transaction(
        id: 'T2',
        title: 'Bread',
        amount: 20.0,
        date: DateTime.now().subtract(const Duration(days: 6))),
    Transaction(
        id: 'T3',
        title: 'Pants',
        amount: 100,
        date: DateTime.now().subtract(const Duration(days: 5))),
    Transaction(
        id: 'T4',
        title: 'dsfsdf',
        amount: 50,
        date: DateTime.now().subtract(const Duration(days: 4))),
    Transaction(
        id: 'T5',
        title: 'fsfdfs',
        amount: 25,
        date: DateTime.now().subtract(const Duration(days: 2))),
    Transaction(
        id: 'T6',
        title: 'fsfdsdf',
        amount: 0,
        date: DateTime.now().subtract(const Duration(days: 1))),
  ];

  List<Transaction> get _recentTransactions {
    final date = DateTime.now().subtract(const Duration(days: 7));
    return _userTransactions.where((t) {
      return t.date.isAfter(date);
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final tx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: date);
    setState(() {
      _userTransactions.insert(0, tx);
    });
  }

  void _deleteTransaction(index) {
    setState(() {
      _userTransactions.removeAt(index);
    });
  }

  void _openNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(onPressed: _addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

//  NewTransaction(onPressed:  _addNewTransaction),
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final bool _isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text(
        'Expense Planner',
      ),
      actions: [
        IconButton(
            onPressed: () => _openNewTransaction(context),
            icon: const Icon(Icons.add))
      ],
    );
    Widget _buildListWidget(height) {
      return SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            height,
        child: TransactionList(
            transactions: _userTransactions,
            deleteTransaction: _deleteTransaction),
      );
    }

    Widget _buildChartWidget(height) {
      return SizedBox(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              height,
          child: Card(
            child: Chart(recentTransactions: _recentTransactions),
            elevation: 5,
          ));
    }

    return Platform.isIOS
        ? CupertinoPageScaffold(child: Container())
        : Scaffold(
            appBar: appBar,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openNewTransaction(context),
                    child: const Icon(Icons.add)),
            body: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_isLandscape)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Items'),
                      Switch.adaptive(
                          activeColor: Theme.of(context).colorScheme.secondary,
                          value: _showChart,
                          onChanged: (bool value) =>
                              setState(() => _showChart = value)),
                      const Text('Chart'),
                    ]),
                  if (_isLandscape)
                    _showChart ? _buildChartWidget(0.7) : _buildListWidget(0.7),
                  if (!_isLandscape) _buildChartWidget(0.3),
                  if (!_isLandscape) _buildListWidget(0.7),
                ],
              )),
            ),
          );
  }
}
