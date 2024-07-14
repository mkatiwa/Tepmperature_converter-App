import 'package:flutter/material.dart';

void main() {
  runApp(const TempConverterApp());
}

class TempConverterApp extends StatelessWidget {
  const TempConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const TempConverterHomePage(),
    );
  }
}

class TempConverterHomePage extends StatefulWidget {
  const TempConverterHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TempConverterHomePageState createState() => _TempConverterHomePageState();
}

class _TempConverterHomePageState extends State<TempConverterHomePage> {
  String _conversionType = 'F to C';
  final TextEditingController _controller = TextEditingController();
  double? _convertedValue;
  final List<String> _history = [];

  void _convert() {``
    final input = double.tryParse(_controller.text);
    if (input == null) return;

    setState(() {
      if (_conversionType == 'F to C') {
        _convertedValue = (input - 32) * 5 / 9;
      } else {
        _convertedValue = input * 9 / 5 + 32;
      }
      _history.add(
          '$_conversionType: ${input.toStringAsFixed(1)} => ${_convertedValue!.toStringAsFixed(1)}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 4,
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: _conversionType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _conversionType = newValue!;
                        });
                      },
                      items: <String>['F to C', 'C to F']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter Temperature',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _convert,
                      child: const Text('Convert'),
                    ),
                  ],
                ),
              ),
            ),
            if (_convertedValue != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Converted Value: ${_convertedValue!.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_history[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}