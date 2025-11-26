import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pwd = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    if (auth.user != null) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            SizedBox(height: 40),
            Text('Bookora', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0288D1))),
            SizedBox(height: 24),
            TextField(controller: _email, decoration: InputDecoration(labelText: 'E-mail')),
            SizedBox(height: 12),
            TextField(controller: _pwd, decoration: InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : () async {
                setState(() => loading = true);
                try {
                  await auth.signInWithEmail(_email.text.trim(), _pwd.text.trim());
                } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
                setState(() => loading = false);
              },
              child: loading ? CircularProgressIndicator(color: Colors.white) : Text('Se connecter'),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4FC3F7)),
            ),
            TextButton(onPressed: () async {
              setState(() => loading = true);
              try {
                await auth.registerWithEmail(_email.text.trim(), _pwd.text.trim());
              } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
              setState(() => loading = false);
            }, child: Text('Créer un compte')),
            SizedBox(height: 12),
            Divider(),
            TextButton.icon(onPressed: () async {
              setState(() => loading = true);
              try { await auth.signInWithGoogle(); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google failed'))); }
              setState(() => loading = false);
            }, icon: Icon(Icons.login), label: Text('Se connecter avec Google')),
          ]),
        ),
      ),
    );
  }
}￼Enter
