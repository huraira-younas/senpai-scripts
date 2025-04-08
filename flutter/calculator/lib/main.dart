import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operand = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "";
        _num1 = 0;
        _num2 = 0;
        _operand = "";
      } else if (buttonText == "⌫") {
        _currentInput =
            _currentInput.isNotEmpty
                ? _currentInput.substring(0, _currentInput.length - 1)
                : "";
        _output = _currentInput.isNotEmpty ? _currentInput : "0";
      } else if (buttonText == "=") {
        _num2 = double.parse(_currentInput);
        switch (_operand) {
          case "+":
            _output = (_num1 + _num2).toString();
            break;
          case "-":
            _output = (_num1 - _num2).toString();
            break;
          case "×":
            _output = (_num1 * _num2).toString();
            break;
          case "÷":
            _output = (_num2 != 0 ? (_num1 / _num2).toString() : "Error");
            break;
        }
        _num1 = 0;
        _num2 = 0;
        _operand = "";
        _currentInput = _output;
      } else if (["+", "-", "×", "÷"].contains(buttonText)) {
        _num1 = double.parse(_currentInput);
        _operand = buttonText;
        _currentInput = "";
      } else {
        _currentInput += buttonText;
        _output = _currentInput;
      }
    });
  }

  Widget _buildButton(String text, {Color? color, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(text),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 28),
            backgroundColor: color ?? Colors.grey.shade800,
            foregroundColor: Colors.white,
            elevation: 6,
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculator")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 58,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.2,
              ),
              children:
                  [
                        "C",
                        "⌫",
                        "÷",
                        "×",
                        "7",
                        "8",
                        "9",
                        "-",
                        "4",
                        "5",
                        "6",
                        "+",
                        "1",
                        "2",
                        "3",
                        "0",
                        ".",
                        "=",
                      ]
                      .map(
                        (e) => _buildButton(
                          e,
                          color:
                              e == "C"
                                  ? Colors.red
                                  : (e == "=" ? Colors.green : null),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
