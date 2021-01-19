import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:security_rules_sample/common/loading_indicator.dart';
import 'package:security_rules_sample/common/will_pop_scope.dart';
import 'package:security_rules_sample/domain/expense.dart';
import 'package:security_rules_sample/presentation/expense_add/expense_add_page.dart';
import 'package:security_rules_sample/presentation/expense_edit/expense_edit_page.dart';
import 'package:security_rules_sample/presentation/home/home_model.dart';
import 'package:security_rules_sample/presentation/my_account/my_account_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('家計簿アプリ'),
          leading: SizedBox(),
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyAccountPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: ChangeNotifierProvider<HomeModel>(
          create: (_) => HomeModel()..fetchExpenses(),
          child: Consumer<HomeModel>(
            builder: (context, model, child) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '支出一覧',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DataTable(
                              showCheckboxColumn: false,
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    '日付',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    '値段',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    '内容',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                              rows: dataRows(context, model.expenseList),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  model.isLoading ? loadingIndicator() : SizedBox(),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseAddPage(),
                fullscreenDialog: true,
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  List<DataRow> dataRows(BuildContext context, List<Expense> expenseList) {
    List<DataRow> _rows = [];
    for (int i = 0; i < expenseList.length; i++) {
      _rows.add(
        DataRow(
          onSelectChanged: (value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseEditPage(expenseList[i]),
                fullscreenDialog: true,
              ),
            );
          },
          cells: <DataCell>[
            DataCell(
              Text(
                expenseList[i].createdAt.toDate().toString().substring(0, 10),
              ),
            ),
            DataCell(
              Text(
                '¥${expenseList[i].price.toString()}'.replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                ),
              ),
            ),
            DataCell(
              Text(
                expenseList[i].content,
              ),
            ),
          ],
        ),
      );
    }
    return _rows;
  }
}
