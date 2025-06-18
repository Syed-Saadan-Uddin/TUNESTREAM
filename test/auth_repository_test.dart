import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:app_dev_proj/data/repositories/auth_repository.dart';


import 'mocks/mocks.mocks.dart';

void main() {
 
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late AuthRepository authRepository;

  
  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    authRepository = AuthRepository(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  
  group('AuthRepository Unit Tests', () {

    test('signUpWithEmailAndPassword should call Firebase method once', () async {
      
      final mockUserCredential = MockUserCredential();
      
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      
      await authRepository.signUpWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('signInWithEmailAndPassword should call Firebase method once', () async {
      
      final mockUserCredential = MockUserCredential();
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      
      await authRepository.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('signOut should call signOut on both FirebaseAuth and GoogleSignIn', () async {
      
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async {});

      // Act
      await authRepository.signOut();

      // Assert
      verify(mockFirebaseAuth.signOut()).called(1);
      verify(mockGoogleSignIn.signOut()).called(1);
    });
  });
}