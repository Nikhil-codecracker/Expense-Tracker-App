import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import '/widgets/expense.dart';
import '/widgets/expenseform.dart';
import '/models/transaction.dart';
import '/widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext content) {
    // WidgetsFlutterBinding.ensureInitialized();   // Way to restrict it to potrait mode only
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
          primarySwatch: Colors
              .purple, // primarySwatch is the same as primary color but the difference is primarySwatch contains all the shades of the color mentioned and primaryColor just gives the color and not its shades
          accentColor:
              Colors.amber, // Color that will look good with our primary color
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )))),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final List<Transactions> _transactions = [
    // Transactions(
    //   id: DateTime.now().toString(),
    //   title: 'Gta 5',
    //   amount: 1000,
    //   date: DateTime.now(),
    // ),
    // Transactions(
    //   id: DateTime.now().toString(),
    //   title: 'Attack on Titan',
    //   amount: 300,
    //   date: DateTime.now(),
    // ),
  ];

  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    print(state);
  }

  @override
  dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transactions> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addTransactions(String newTitle, double newAmount, DateTime newDate) {
    final newTx = Transactions(
      id: DateTime.now().toString(),
      title: newTitle,
      amount: newAmount,
      date: newDate,
    );

    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  void newTransactionForm(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return ExpenseForm(_addTransactions);
      },
    );
  }

  List<Widget> _buildLanscapeContent(AppBar _appBar, final _txListView) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch.adaptive(
              value: _showChart,
              activeColor: Theme.of(context).accentColor,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      _appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              width: double.infinity,
              child: Chart(_recentTransactions),
            )
          : _txListView
    ];
  }

  List<Widget> _buildPotraitContent(AppBar _appBar, final _txListView) {
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                _appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.3,
        width: double.infinity,
        child: Chart(_recentTransactions),
      ),
      _txListView
    ];
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext content) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final _appBar = AppBar(
      title: Text(
        'Personal Expense',
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            newTransactionForm(content);
          },
        ),
      ],
    );

    final _txListView = Container(
        height: (MediaQuery.of(context).size.height -
                _appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.6,
        child: Expense(_transactions, _deleteTransaction));

    return Scaffold( 
      appBar: _appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape) ..._buildLanscapeContent(_appBar, _txListView),
            if (!isLandscape) ..._buildPotraitContent(_appBar, _txListView),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add), 
              onPressed: () {
                newTransactionForm(content);
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
