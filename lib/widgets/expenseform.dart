import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  // String textInput = '';
  // String amountInput = '';
  final Function addTransaction;

  ExpenseForm(this.addTransaction);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _textController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _expenseDate;

  void submitForm() {
    if(_amountController.text.isEmpty){
      return;
    }
    
    String enteredTitle = _textController.text;
    double enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.length == 0 || enteredAmount <= 0 || _expenseDate == null) {
      return;
    }

    widget.addTransaction(
      enteredTitle,
      enteredAmount,
      _expenseDate,
    );

    Navigator.of(context).pop();
  }

  void _datePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((res) {
      if (res == null) {
        return;
      }
      setState(() {
        _expenseDate = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                // onChanged: (val) {
                //   textInput = val;
                // },
                controller: _textController,
                onSubmitted: (_) => submitForm,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                // onChanged: (val) {
                //   amountInput = val;
                // },
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitForm,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_expenseDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMMMd().format(_expenseDate)}'
                      )
                    ),
                    FlatButton(
                      onPressed: _datePicker,
                      textColor: Theme.of(context).primaryColor,
                      child: Text('Choose Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: submitForm,
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
        ),
        elevation: 5,
      ),
    );
  }
}
