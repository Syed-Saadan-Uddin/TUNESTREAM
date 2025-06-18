import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:app_dev_proj/presentation/bloc/theme/theme_bloc.dart';

void main() {
  group('ThemeBloc Tests', () {
    
    test('initial state is ThemeMode.dark', () {
      expect(ThemeBloc().state, ThemeMode.dark);
    });

        blocTest<ThemeBloc, ThemeMode>(
      'emits [ThemeMode.light] when ThemeToggled is added and current state is dark',
      
      build: () => ThemeBloc(),
      
      act: (bloc) => bloc.add(ThemeToggled()),
      
      expect: () => [ThemeMode.light],
    );

    blocTest<ThemeBloc, ThemeMode>(
      'emits [ThemeMode.dark] when ThemeToggled is added and current state is light',
      
      build: () => ThemeBloc(),
      
      seed: () => ThemeMode.light,
      
      act: (bloc) => bloc.add(ThemeToggled()),
      
      expect: () => [ThemeMode.dark],
    );
  });
}