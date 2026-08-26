import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextToolPage extends StatefulWidget {
  const TextToolPage({super.key});

  @override
  State<TextToolPage> createState() => _TextToolPageState();
}

class _TextToolPageState extends State<TextToolPage> {
  final TextEditingController _controller = TextEditingController();

  String _result = '';

  void _toUpperCase() {
    setState(() {
      _result = _controller.text.toUpperCase();
    });
  }

  void _toLowerCase() {
    setState(() {
      _result = _controller.text.toLowerCase();
    });
  }

  void _reverseText() {
    setState(() {
      _result = _controller.text.split('').reversed.join();
    });
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _result = '';
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
    final inputText = _controller.text;
    final characterCount = inputText.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Tool'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            maxLines: 6,
            onChanged: (_) {
              setState(() {});
            },
            decoration: const InputDecoration(
              labelText: 'Input text',
              hintText: 'Type something here...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Characters: $characterCount',
            style: Theme.of(context).textTheme.bodySmall,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _toUpperCase,
                  child: const Text('UPPERCASE'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _toLowerCase,
                  child: const Text('lowercase'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _reverseText,
                  child: const Text('Reverse'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _clear,
                  child: const Text('Clear'),
                ),
              ),
            ],
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
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _result.isEmpty ? 'No result yet.' : _result,
            ),
          ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: _result.isEmpty ? null : _copyResult,
            icon: const Icon(Icons.copy),
            label: const Text('Copy Result'),
          ),
        ],
      ),
    );
  }
}