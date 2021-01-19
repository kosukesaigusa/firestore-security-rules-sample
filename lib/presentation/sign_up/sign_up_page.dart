import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_rules_sample/presentation/sign_up/sign_up_model.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: ChangeNotifierProvider<SignUpModel>(
        create: (_) => SignUpModel(),
        child: Consumer<SignUpModel>(
          builder: (context, model, child) {
            return Stack(
              children: [],
            );
          },
        ),
      ),
    );
  }
}
