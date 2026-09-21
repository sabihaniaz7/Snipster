import 'package:flutter/material.dart';

import '../models/snippet.dart';
import '../services/api_service.dart';
import '../widgets/snippet_card.dart';
import 'snippet_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiService();
  final _searchController = TextEditingController();
  List<Snippet> _snippets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({String? search}) async {
    setState(() => _loading = true);
    final data = await _api.getSnippets(search: search);
    setState(() {
      _snippets = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Snipster',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SnippetEditorScreen()),
          );
          if (created == true) _load();
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              onSubmitted: (v) => _load(search: v),
              decoration: InputDecoration(
                hintText: 'Search snippets...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _snippets.isEmpty
                  ? const Center(child: Text('No snippets yet'))
                  : ListView.builder(
                      itemCount: _snippets.length,
                      itemBuilder: (context, i) => SnippetCard(
                        snippet: _snippets[i],
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SnippetEditorScreen(snippet: _snippets[i]),
                            ),
                          );
                          if (updated == true) _load();
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
