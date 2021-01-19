import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:security_rules_sample/common/form_done_button.dart';
import 'package:security_rules_sample/common/loading_indicator.dart';
import 'package:security_rules_sample/common/text_dialog.dart';
import 'package:security_rules_sample/presentation/expense_add/expense_add_model.dart';
import 'package:security_rules_sample/presentation/home/home_page.dart';

class ExpenseAddPage extends StatelessWidget {
  final FocusNode _focusNodeContent = FocusNode();
  final FocusNode _focusNodePrice = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[700],
      nextFocus: false,
      actions: [
        _keyboardActionItems(_focusNodeContent),
        _keyboardActionItems(_focusNodePrice),
      ],
    );
  }

  _keyboardActionItems(_focusNode) {
    return KeyboardActionsItem(
      focusNode: _focusNode,
      toolbarButtons: [
        (node) {
          return customDoneButton(_focusNode);
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('支出の登録'),
      ),
      body: ChangeNotifierProvider<ExpenseAddModel>(
        create: (_) => ExpenseAddModel(),
        child: Consumer<ExpenseAddModel>(
          builder: (context, model, child) {
            return Stack(
              children: [
                KeyboardActions(
                  config: _buildConfig(context),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            focusNode: this._focusNodeContent,
                            textInputAction: TextInputAction.done,
                            initialValue: model.content,
                            minLines: 1,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: '支出の内容',
                              border: OutlineInputBorder(),
                              errorText: model.showContentError
                                  ? '正しい内容を入力して下さい。'
                                  : null,
                            ),
                            onChanged: (text) {
                              model.changeContent(text);
                            },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            focusNode: this._focusNodePrice,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            initialValue: model.price == null
                                ? ''
                                : model.price.toString(),
                            minLines: 1,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: '価格',
                              border: OutlineInputBorder(),
                              errorText: model.showPriceError
                                  ? '正しい価格を入力して下さい。'
                                  : null,
                            ),
                            onChanged: (text) {
                              model.changePrice(text);
                            },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: RaisedButton(
                              child: Text('支出の追加'),
                              onPressed: model.isFormValid
                                  ? () async {
                                      model.startLoading();
                                      try {
                                        await model.submit();
                                        model.endLoading();
                                        await showTextDialog(
                                            context, '支出を登録しました。');
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                      } catch (e) {
                                        model.endLoading();
                                        showTextDialog(context, e.toString());
                                      }
                                    }
                                  : null,
                            ),
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
    );
  }
}
