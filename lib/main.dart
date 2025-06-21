import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'onboarding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://qavpysiceejtwyfqtcpv.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFhdnB5c2ljZWVqdHd5ZnF0Y3B2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYxNTYxODcsImV4cCI6MjA2MTczMjE4N30.bqOR4x6-DUAkwfg1npojCdPYzf0Hz5sY51xqUKBXvcU",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'todo app',
      home:
          const OnboardingPage(), // selalu tampilkan onboarding page terlebih dahulu
    );
  }
}
