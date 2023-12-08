import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sweetpet/controller/login_controller/login_controller.dart';

void main() {
  testWidgets('Login Page Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: LoginController(),
      ),
    );

    // Verify that the initial state is as expected.
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Join Us'), findsNothing);

    // Tap the "New User? Register Now!" button and trigger a frame.
    await tester.tap(find.text('New User? Register Now!'));
    await tester.pumpAndSettle();

    // Verify that the state is updated after tapping the button.
    expect(find.text('Welcome'), findsNothing);
    expect(find.text('Join Us'), findsOneWidget);

    // Test for validating email and password inputs.
    await tester.enterText(
        find.byKey(const Key('emailTextField')), 'invalid-email');
    await tester.enterText(find.byKey(const Key('passwordTextField')), 'short');
    await tester
        .tap(find.text('Log In')); // Try to log in with invalid credentials.
    await tester.pump();

    expect(find.text('Please enter a valid email address'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters long'),
        findsOneWidget);

    // Test the successful registration flow.
    await tester.tap(find.text('New User? Register Now!'));
    await tester.enterText(
        find.byKey(const Key('emailTextField')), 'test@example.com');
    await tester.enterText(
        find.byKey(const Key('passwordTextField')), 'password123');
    await tester.enterText(
        find.byKey(const Key('usernameTextField')), 'testuser');
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle(); // Wait for animations to complete.

    // You might want to check for widgets that should be present after a successful registration.
    expect(find.text('Welcome'), findsNothing);
    expect(find.text('Join Us'), findsNothing);

    // Test error handling for authentication failure.
    // This assumes you have an invalid login scenario in your app.
    await tester.tap(find.text('I Already Have An Account'));
    await tester.enterText(
        find.byKey(const Key('emailTextField')), 'invalid@example.com');
    await tester.enterText(
        find.byKey(const Key('passwordTextField')), 'wrongpassword');
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle(); // Wait for animations to complete.

    // Check if the error message is displayed.
    expect(find.text('Authentication failed'), findsOneWidget);
  });
}
