import 'package:flutter/material.dart';

import 'pages/text_tool_page.dart';
import 'pages/base64_tool_page.dart';
import 'pages/timestamp_tool_page.dart';

void main() {
  runApp(const MyToolApp());
}

class MyToolApp extends StatelessWidget {
  const MyToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tool App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title coming soon'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tools = [
      _ToolItem(
        title: 'Text Tool',
        subtitle: 'Convert text to uppercase, lowercase, or reverse text',
        icon: Icons.text_fields,
        page: const TextToolPage(),
      ),
      _ToolItem(
        title: 'Base64 Tool',
        subtitle: 'Encode and decode Base64 text',
        icon: Icons.lock_outline,
        page: const Base64ToolPage(),
      ),
      _ToolItem(
        title: 'Timestamp Tool',
        subtitle: 'Convert timestamp and date',
        icon: Icons.access_time,
        page: const TimestampToolPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tool App'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];

          return Card(
            child: ListTile(
              leading: Icon(tool.icon),
              title: Text(tool.title),
              subtitle: Text(tool.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (tool.page != null) {
                  _openPage(context, tool.page!);
                } else {
                  _showComingSoon(context, tool.title);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class _ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? page;

  const _ToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.page,
  });
}