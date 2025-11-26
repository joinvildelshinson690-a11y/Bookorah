import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_functions/firebase_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetail extends StatefulWidget {
  final String bookId;
  BookDetail({required this.bookId});
  @override _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  DocumentSnapshot? bookDoc;
  bool loading = true, purchased = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final snap = await FirebaseFirestore.instance.collection('books').doc(widget.bookId).get();
    bookDoc = snap;
    await _checkPurchase();
    setState(() => loading = false);
  }

  Future<void> _checkPurchase() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final q = await FirebaseFirestore.instance.collection('purchases')
      .where('userId', isEqualTo: uid)
      .where('bookId', isEqualTo: widget.bookId).get();
    setState(() => purchased = q.docs.isNotEmpty);
  }

  Future<void> _startStripe() async {
    final callable = FirebaseFunctions.instance.httpsCallable('createCheckoutSession');
    final res = await callable.call({'bookId': widget.bookId});
    final url = res.data['url'];
    if (await canLaunch(url)) await launch(url);
  }

  void _openReader(String url) => Navigator.pushNamed(context, '/reader', arguments: {'file': url});

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));
    final data = bookDoc!.data() as Map<String,dynamic>;
    final title = data['title'] ?? '';
    final author = data['author'] ?? '';
    final price = data['price'] ?? 0.0;
    final isPremium = data['isPremium'] ?? false;
    final downloadUrl = data['downloadUrl'] ?? '';
    return Scaffold(
      appBar: AppBar(title: Text('Détails')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height:6), Text('Par $author'),
          SizedBox(height:12), Text(data['description'] ?? ''),
          Spacer(),
          if (!isPremium) ElevatedButton(onPressed: () => _openReader(downloadUrl), child: Text('Lire gratuitement'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4FC3F7))),
          if (isPremium && !purchased) ElevatedButton(onPressed: _startStripe, child: Text('Acheter $price USD'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4FC3F7))),
          if (isPremium && purchased) ElevatedButton(onPressed: () => _openReader(downloadUrl), child: Text('Télécharger / Lire'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4FC3F7))),
          SizedBox(height:12),
          ElevatedButton(onPressed: () {
            showDialog(context: context, builder: (_) => AlertDialog(
              title: Text('Payer avec MonCash/NatCash'),
              content: Text('Envoyez $price HTG à MonCash: +509 XXXXXX ou NatCash: +509 YYYYYY. Ensuite, allez dans Profil > Mes paiements et uploadez le screenshot. L\'admin vérifiera.'),
              actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text('OK'))],
            ));
          }, child: Text('Payer avec MonCash / NatCash')),
        ]),
      ),
    );
  }
}￼Enter
