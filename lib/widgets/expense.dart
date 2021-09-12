import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Expense extends StatelessWidget {
  final List<Transactions> _finalTransactions;
  final Function _deleteTx;

  Expense(this._finalTransactions,this._deleteTx);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx,constraints){
      return _finalTransactions.length == 0
          ? Column(
              children: [
                Text(
                  'No Transaction added yet',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover)),
              ],
            )
          : ListView.builder(
              //Works as a Column with Scrollable but a height has to metioned for it.
              // Alternate is using SingleChildScrollView above a column to make it srollable. It does not require a height to be mentioned
              itemBuilder: (ctx, idx) {
                return Card(
                  elevation: 4,                                
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text('\$${_finalTransactions[idx].amount}')),
                      ),
                    ),
                    title: Text(
                      _finalTransactions[idx].title,
                      style: Theme.of(context).textTheme.title
                    ),
                    subtitle: Text(DateFormat.yMMMd().format(_finalTransactions[idx].date)),
                    trailing: MediaQuery.of(context).size.width > 460 ? 
                    FlatButton.icon(
                      icon: Icon(Icons.delete),
                      label: Text('Delete'),
                      textColor: Theme.of(context).errorColor,
                      onPressed: () => _deleteTx(_finalTransactions[idx].id),
                    )
                    : IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => _deleteTx(_finalTransactions[idx].id),
                    ),
                  ),
                );
              },
              itemCount: _finalTransactions.length,
              // children: [
              //   ..._finalTransactions.map((tx) {
              //     return
              // ],
            );
    });
  }
}


//Another Way to Display the list
//Card(
            //     child: Row(
            //       children: [
            //         Container(
            //           margin: EdgeInsets.symmetric(
            //             vertical: 10,
            //             horizontal: 15,
            //           ),
            //           decoration: BoxDecoration(
            //             border: Border.all(
            //             color: Theme.of(context).primaryColor,
            //             width: 2,
            //           ),),
            //           child: Text(
            //             '\$${_finalTransactions[idx].amount}',
            //               style: TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 20,
            //                 color: Theme.of(context).primaryColor,
            //               )
            //           ),
            //           padding: EdgeInsets.all(10),

            //         ),
            //         Column(
            //           children: [
            //             Text(
            //               _finalTransactions[idx].title,
            //               style: Theme.of(context).textTheme.title,
            //             ),
            //             Text(
            //               DateFormat.yMMMd().format(
            //                 _finalTransactions[idx].date),
            //                 style: TextStyle(
            //                   color: Colors.grey,
            //                   fontSize: 13,
            //                 )
            //               ),
            //           ],
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //         ),
            //       ],
            //     ),
            //     elevation: 5,
            //   );
