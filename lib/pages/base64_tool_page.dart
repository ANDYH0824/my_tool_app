import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Base64ToolPage extends StatefulWidget {
  const Base64ToolPage({super.key});

  @override
  State<Base64ToolPage> createState() => _Base64ToolPageState();
}

class _Base64ToolPageState extends State<Base64ToolPage> {
  final TextEditingController _controller = TextEditingController();

  String _result = '';
  String _error = '';

  void _encode() {
    final input = _controller.text;

    setState(() {
      _error = '';
      _result = base64Encode(utf8.encode(input));
    });
  }

  void _decode() {
    final input = _controller.text.trim();

    try {
      final decodedBytes = base64Decode(input);

      setState(() {
        _error = '';
        _result = utf8.decode(decodedBytes);
      });
    } catch (e) {
      setState(() {
        _result = '';
        _error = 'Invalid Base64 text';
      });
    }
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _result = '';
      _error = '';
    });
  }

  Future<void> _copyResult() async {
    if (_result.isEmpty) {
      return;
    }

    await Clipboard.setData(
      ClipboardData(text: _result),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Result copied'),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasResult = _result.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Base64 Tool'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Input text',
              hintText: 'Type text or Base64 here...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _encode,
                  child: const Text('Encode'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _decode,
                  child: const Text('Decode'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: _clear,
            child: const Text('Clear'),
          ),

          const SizedBox(height: 24),

          Text(
            'Result',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: _error.isEmpty ? Colors.grey.shade300 : Colors.red,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _error.isNotEmpty
                  ? _error
                  : hasResult
                      ? _result
                      : 'No result yet.',
              style: TextStyle(
                color: _error.isEmpty ? null : Colors.red,
              ),
            ),
          ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: hasResult ? _copyResult : null,
            icon: const Icon(Icons.copy),
            label: const Text('Copy Result'),
          ),
        ],
      ),
    );
  }
}