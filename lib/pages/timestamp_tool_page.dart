import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimestampToolPage extends StatefulWidget {
  const TimestampToolPage({super.key});

  @override
  State<TimestampToolPage> createState() => _TimestampToolPageState();
}

class _TimestampToolPageState extends State<TimestampToolPage> {
  final TextEditingController _controller = TextEditingController();

  String _result = '';
  String _error = '';

  void _getCurrentTimestamp() {
    final now = DateTime.now();
    final milliseconds = now.millisecondsSinceEpoch;
    final seconds = milliseconds ~/ 1000;

    setState(() {
      _error = '';
      _result = 'Seconds: $seconds\nMilliseconds: $milliseconds';
    });
  }

  void _timestampToDate() {
    final input = _controller.text.trim();

    if (input.isEmpty) {
      setState(() {
        _result = '';
        _error = 'Please input a timestamp';
      });
      return;
    }

    final timestamp = int.tryParse(input);

    if (timestamp == null) {
      setState(() {
        _result = '';
        _error = 'Invalid timestamp';
      });
      return;
    }

    int milliseconds;

    // 10位一般是秒级时间戳，13位一般是毫秒级时间戳
    if (input.length <= 10) {
      milliseconds = timestamp * 1000;
    } else {
      milliseconds = timestamp;
    }

    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    setState(() {
      _error = '';
      _result =
          'Local time: ${_formatDateTime(dateTime)}\nUTC time: ${dateTime.toUtc().toIso8601String()}';
    });
  }

  void _dateToTimestamp() {
    final now = DateTime.now();

    setState(() {
      _error = '';
      _result =
          'Current local time: ${_formatDateTime(now)}\nSeconds: ${now.millisecondsSinceEpoch ~/ 1000}\nMilliseconds: ${now.millisecondsSinceEpoch}';
    });
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _result = '';
      _error = '';
    });
  }

  String _formatDateTime(DateTime dateTime) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    final year = dateTime.year;
    final month = twoDigits(dateTime.month);
    final day = twoDigits(dateTime.day);
    final hour = twoDigits(dateTime.hour);
    final minute = twoDigits(dateTime.minute);
    final second = twoDigits(dateTime.second);

    return '$year-$month-$day $hour:$minute:$second';
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
        title: const Text('Timestamp Tool'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Input timestamp',
              hintText: 'Example: 1724670000 or 1724670000000',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: _timestampToDate,
            child: const Text('Timestamp to Date'),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: _getCurrentTimestamp,
            child: const Text('Get Current Timestamp'),
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: _dateToTimestamp,
            child: const Text('Current Date to Timestamp'),
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