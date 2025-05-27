import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hala_desktop/presentation/screens/auth/login_screen.dart';
import 'package:hala_desktop/presentation/screens/auth/register_screen.dart';
import 'package:hala_desktop/presentation/screens/home/home_screen.dart';
import 'package:hala_desktop/presentation/screens/splash_screen.dart';
import 'infrastructure/services/token_storage_service.dart';
import 'application/services/auth_service.dart';
import 'presentation/blocs/auth_bloc.dart';

void main() {
  final tokenStorage = TokenStorageService();
  final authService = AuthService(tokenStorage);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TokenStorageService>.value(value: tokenStorage),
        RepositoryProvider<AuthService>.value(value: authService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authService)),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hala Desktop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
