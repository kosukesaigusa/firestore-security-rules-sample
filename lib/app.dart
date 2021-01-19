import 'package:flutter/material.dart';
import 'package:security_rules_sample/app_model.dart';
import 'package:security_rules_sample/domain/user_state.dart';
import 'package:security_rules_sample/presentation/home/home_page.dart';
import 'package:security_rules_sample/presentation/sign_in/sign_in_page.dart';
import 'package:security_rules_sample/presentation/splash/splash_page.dart';

class App extends StatelessWidget {
  final AppModel model = AppModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Security Rules sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      home: StreamBuilder(
        stream: model.userState,
        initialData: UserState.signedOut,
        builder: (context, AsyncSnapshot<UserState> snapshot) {
          final UserState state =
              snapshot.connectionState == ConnectionState.waiting
                  ? UserState.waiting
                  : snapshot.data;
          print("App(): userState = $state");
          return _convertPage(context, state);
        },
      ),
    );
  }

  // UserState => page
  Widget _convertPage(context, UserState state) {
    switch (state) {
      case UserState.waiting:
        return SplashPage();
      case UserState.signedOut:
        return SignInPage();
      case UserState.signedIn:
        return HomePage();
      default:
        return SignInPage();
    }
  }
}
