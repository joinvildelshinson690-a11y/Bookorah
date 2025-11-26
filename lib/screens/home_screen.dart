import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final booksRef = FirebaseFirestore.instance.collection('books').orderBy('title');
    return Scaffold(
      appBar: AppBar(title: Text('Bookora', style: TextStyle(color: Colors.black))),
      body: StreamBuilder<QuerySnapshot>(
        stream: booksRef.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return Center(child: Text('Aucun livre disponible.'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              return ListTile(
                leading: d['coverUrl'] != '' ? Image.network(d['coverUrl'], width: 50, fit: BoxFit.cover) : Icon(Icons.book),
                title: Text(d['title'] ?? ''),
                subtitle: Text(d['author'] ?? ''),
                trailing: Text(d['isPremium'] == true ? '${d['price']} USD' : 'Gratuit'),
                onTap: () => Navigator.pushNamed(context, '/book', arguments: {'id': d.id}),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4FC3F7),
        child: Icon(Icons.admin_panel_settings, color: Colors.white),
        onPressed: () => Navigator.pushNamed(context, '/admin'),
      ),
    );
  }
}￼Enter
