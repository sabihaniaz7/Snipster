import 'package:flutter/material.dart';

import '../models/snippet.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class SnippetEditorScreen extends StatefulWidget {
  final Snippet? snippet;
  const SnippetEditorScreen({super.key, this.snippet});

  @override
  State<SnippetEditorScreen> createState() => _SnippetEditorScreenState();
}

class _SnippetEditorScreenState extends State<SnippetEditorScreen> {
  final _api = ApiService();
  late final _title = TextEditingController(text: widget.snippet?.title);
  late final _content = TextEditingController(text: widget.snippet?.content);
  late final _category = TextEditingController(text: widget.snippet?.category);
  late final _language = TextEditingController(text: widget.snippet?.language);

  Future<void> _save() async {
    final snippet = Snippet(
      title: _title.text,
      content: _content.text,
      category: _category.text,
      language: _language.text,
    );
    if (widget.snippet == null) {
      await _api.createSnippet(snippet);
    } else {
      await _api.updateSnippet(widget.snippet!.id!, snippet);
    }
    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _delete() async {
    await _api.deleteSnippet(widget.snippet!.id!);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snippet == null ? 'New Snippet' : 'Edit Snippet'),
        actions: [
          if (widget.snippet != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _language,
              decoration: const InputDecoration(labelText: 'Language'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _category,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _content,
              maxLines: 10,
              style: const TextStyle(fontFamily: 'monospace'),
              decoration: const InputDecoration(
                labelText: 'Content',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _save,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
