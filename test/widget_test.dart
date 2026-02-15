import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:technical_assesment/core/services/auth_storage_service_impl.dart';
import 'package:technical_assesment/main.dart';

void main() {
  testWidgets('App builds and shows login', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final authStorage = AuthStorageServiceImpl(prefs);
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(BankApp(authStorage: authStorage, navigatorKey: navigatorKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
