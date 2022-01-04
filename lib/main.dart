import 'package:blood_donation/data/repositories/auth_repository.dart';
import 'package:blood_donation/ui/authentication/authentication.dart';
import 'package:blood_donation/ui/home/home.dart';
import 'package:blood_donation/ui/update_user_info/update_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/blocs/auth_bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository(FirebaseAuth.instance))
            ..add(AppStartedEvent()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is SignedInState) {
            return HomePage();
          }
          if (state is UpdateUserDataState) {
            return UpdateUserDataPage();
          }
          return AuthenticationPage();
        },
      ),
    );
  }
}
