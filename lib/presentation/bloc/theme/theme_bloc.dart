import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  
  ThemeBloc() : super(ThemeMode.dark) {
    on<ThemeToggled>((event, emit) {
      emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    });
  }
}