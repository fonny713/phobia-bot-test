import 'package:flutter/material.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _entries = [];

  void _saveEntry() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _entries.insert(0, _controller.text.trim());
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dziennik emocji')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Jak się teraz czujesz?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveEntry,
              child: Text('Zapisz wpis'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _entries.isEmpty
                  ? Center(child: Text('Brak zapisów.'))
                  : ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(_entries[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
