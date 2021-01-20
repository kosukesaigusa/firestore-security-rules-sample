import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:security_rules_sample/common/form_done_button.dart';
import 'package:security_rules_sample/common/loading_indicator.dart';
import 'package:security_rules_sample/common/text_dialog.dart';
import 'package:security_rules_sample/presentation/home/home_page.dart';
import 'package:security_rules_sample/presentation/sign_in/sign_in_page.dart';
import 'package:security_rules_sample/presentation/sign_up/sign_up_model.dart';

class SignUpPage extends StatelessWidget {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[700],
      nextFocus: false,
      actions: [
        _keyboardActionItems(_focusNodeEmail),
        _keyboardActionItems(_focusNodePassword),
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
        title: Text('新規登録ページ'),
        leading: Container(),
      ),
      body: ChangeNotifierProvider<SignUpModel>(
        create: (_) => SignUpModel(),
        child: Consumer<SignUpModel>(
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
                            focusNode: this._focusNodeEmail,
                            textInputAction: TextInputAction.done,
                            initialValue: model.email,
                            minLines: 1,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              border: OutlineInputBorder(),
                              errorText:
                                  model.showEmailError ? '正しく入力して下さい。' : null,
                            ),
                            onChanged: (text) {
                              model.changeEmail(text);
                            },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            focusNode: this._focusNodePassword,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            initialValue: model.password,
                            minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(
                              labelText: 'パスワード',
                              border: OutlineInputBorder(),
                              errorText: model.showPasswordError
                                  ? '8文字以上20文字以内で入力してください。'
                                  : null,
                            ),
                            onChanged: (text) {
                              model.changePassword(text);
                            },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: RaisedButton(
                              child: Text('新規登録'),
                              onPressed: model.isFormValid
                                  ? () async {
                                      model.startLoading();
                                      try {
                                        await model.signUp();
                                        model.endLoading();
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
                          SizedBox(
                            height: 16.0,
                          ),
                          Center(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInPage(),
                                  ),
                                );
                              },
                              child: Text('ログインページへ'),
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
