import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hala_desktop/presentation/blocs/auth_bloc.dart';
import 'package:hala_desktop/presentation/blocs/auth_event.dart';
import 'package:hala_desktop/presentation/blocs/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              final user = state.user;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Welcome! You are logged in.'),
                  const SizedBox(height: 12),
                  // Text('ID: ${user['id']}'),
                  // Text('Name: ${user['name']}'),
                  // Text('Email: ${user['email']}'),
                  // Text('Token: ${user['token']}'),
                  Text('ID: ${user.id}'),
                  Text('Name: ${user.name}'),
                  Text('Email: ${user.email}'),
                  Text('Token: ${user.token}'),
                ],
              );
            } else {
              return const Text('Something went wrong. Please log in again.');
            }
          },
        ),
      ),
    );
  }
}
