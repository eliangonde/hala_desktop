import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hala_desktop/presentation/blocs/auth_bloc.dart';
import 'package:hala_desktop/presentation/blocs/auth_event.dart';

void logout(BuildContext context) {
  context.read<AuthBloc>().add(LogoutRequested());
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/',
    (Route<dynamic> route) => false,
  );
}
