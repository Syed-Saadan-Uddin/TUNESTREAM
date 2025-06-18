import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:lottie/lottie.dart';
import 'package:app_dev_proj/presentation/views/login_screen.dart';
import 'package:app_dev_proj/presentation/bloc/auth/auth_bloc.dart';
import 'package:app_dev_proj/core/theme.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<AuthBloc>.value(
      value: mockAuthBloc,
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        
        home: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget & Golden Tests', () {
    testWidgets('Renders all major UI components without overflow', (WidgetTester tester) async {
      
      whenListen(
        mockAuthBloc,
        Stream.fromIterable([const AuthState.unauthenticated()]),
        initialState: const AuthState.unauthenticated(),
      );

      
      await tester.binding.setSurfaceSize(const Size(1080, 2340));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); 

      // Assert
      expect(find.text('TuneStream'), findsOneWidget);
      expect(find.text('Listen as a Guest'), findsOneWidget);
    });

    testWidgets('Golden test matches the master image', (WidgetTester tester) async {
      // Arrange
      whenListen(
        mockAuthBloc,
        Stream.fromIterable([const AuthState.unauthenticated()]),
        initialState: const AuthState.unauthenticated(),
      );

      // Disable animations for the golden test to be stable
      await tester.pumpWidget(
        TickerMode(
          enabled: false,
          child: createWidgetUnderTest(),
        ),
      );
      await tester.pump();

      // Assert
      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_screen.png'),
      );
    });
  });
}