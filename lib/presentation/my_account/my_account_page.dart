import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_rules_sample/common/loading_indicator.dart';
import 'package:security_rules_sample/presentation/email_edit/email_edit_page.dart';
import 'package:security_rules_sample/presentation/home/home_page.dart';
import 'package:security_rules_sample/presentation/my_account/my_account_model.dart';
import 'package:security_rules_sample/presentation/sign_in/sign_in_page.dart';

class MyAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('マイアカウントページ'),
      ),
      body: ChangeNotifierProvider<MyAccountModel>(
        create: (_) => MyAccountModel(),
        child: Consumer<MyAccountModel>(
          builder: (context, model, child) {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${model.auth.email}'),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmailEditPage(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    FlatButton(
                      onPressed: () async {
                        await model.signOut();
                        await Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ),
                          (_) => false,
                        );
                      },
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('ログアウト'),
                            Icon(Icons.exit_to_app),
                          ],
                        ),
                      ),
                    ),
                  ],
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
