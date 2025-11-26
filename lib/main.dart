import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/book_detail.dart';
import 'screens/pdf_reader.dart';
import 'services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(BookoraApp());
}

class BookoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Bookora',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF4FC3F7),
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (_) => LoginScreen(),
          '/home': (_) => HomeScreen(),
          '/admin': (_) => AdminDashboard(),
          '/reader': (_) => PDFReader(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/book') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_) => BookDetail(bookId: args['id']));
          }
          return null;
        },
      ),
    );
  }
}
