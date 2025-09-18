import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XM Utility App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UtilityHomePage(),
    );
  }
}

class UtilityHomePage extends StatefulWidget {
  const UtilityHomePage({super.key});

  @override
  State<UtilityHomePage> createState() => _UtilityHomePageState();
}

class _UtilityHomePageState extends State<UtilityHomePage> {
  // 计算器相关状态
  String _calculatorDisplay = '0';
  double _firstOperand = 0;
  String _operation = '';
  bool _shouldResetScreen = false;

  // 日期相关状态
  String _currentDateTime = '';

  // 天气相关状态
  String _weatherCondition = '晴朗';
  String _temperature = '25°C';
  String _location = '北京市';

  // 备忘录相关状态
  TextEditingController _noteController = TextEditingController();
  String _savedNote = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    // 设置定时器每分钟更新一次日期时间
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        _updateDateTime();
      }
    });
  }

  void _updateDateTime() {
    setState(() {
      _currentDateTime = DateFormat(
        'yyyy年MM月dd日 HH:mm:ss',
      ).format(DateTime.now());
    });
  }

  // 计算器功能
  void _calculatorButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _calculatorDisplay = '0';
        _firstOperand = 0;
        _operation = '';
        _shouldResetScreen = false;
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '×' ||
          buttonText == '÷') {
        _firstOperand = double.parse(_calculatorDisplay);
        _operation = buttonText;
        _shouldResetScreen = true;
      } else if (buttonText == '=') {
        double secondOperand = double.parse(_calculatorDisplay);
        double result = 0;

        switch (_operation) {
          case '+':
            result = _firstOperand + secondOperand;
            break;
          case '-':
            result = _firstOperand - secondOperand;
            break;
          case '×':
            result = _firstOperand * secondOperand;
            break;
          case '÷':
            result = _firstOperand / secondOperand;
            break;
        }

        _calculatorDisplay = result.toString();
        if (_calculatorDisplay.endsWith('.0')) {
          _calculatorDisplay = _calculatorDisplay.substring(
            0,
            _calculatorDisplay.length - 2,
          );
        }
        _operation = '';
        _shouldResetScreen = true;
      } else {
        if (_shouldResetScreen) {
          _calculatorDisplay = buttonText;
          _shouldResetScreen = false;
        } else {
          _calculatorDisplay = _calculatorDisplay == '0'
              ? buttonText
              : _calculatorDisplay + buttonText;
        }
      }
    });
  }

  // 备忘录保存功能
  void _saveNote() {
    setState(() {
      _savedNote = _noteController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('XM 工具箱'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // 日期和天气区域（上半部分）
              Row(
                children: [
                  // 日期区块
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '当前日期时间',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentDateTime,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 天气区块
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '天气信息',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _location,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.wb_sunny, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  _weatherCondition,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  _temperature,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 计算器和备忘录区域（下半部分）
              Expanded(
                child: Row(
                  children: [
                    // 计算器区块
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                '计算器',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 60,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    _calculatorDisplay,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // 计算器按钮
                              GridView.count(
                                crossAxisCount: 4,
                                shrinkWrap: true,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                children: [
                                  _buildCalculatorButton('7'),
                                  _buildCalculatorButton('8'),
                                  _buildCalculatorButton('9'),
                                  _buildCalculatorButton('÷'),
                                  _buildCalculatorButton('4'),
                                  _buildCalculatorButton('5'),
                                  _buildCalculatorButton('6'),
                                  _buildCalculatorButton('×'),
                                  _buildCalculatorButton('1'),
                                  _buildCalculatorButton('2'),
                                  _buildCalculatorButton('3'),
                                  _buildCalculatorButton('-'),
                                  _buildCalculatorButton('C'),
                                  _buildCalculatorButton('0'),
                                  _buildCalculatorButton('='),
                                  _buildCalculatorButton('+'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 备忘录区块
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                '本地备忘录',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _noteController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '输入备忘录内容...',
                                ),
                                maxLines: 4,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _saveNote,
                                child: const Text('保存'),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        _savedNote.isEmpty
                                            ? '暂无保存的备忘录'
                                            : _savedNote,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorButton(String buttonText) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsetsGeometry.zero,
        backgroundColor:
            buttonText == 'C' ||
                buttonText == '=' ||
                buttonText == '+' ||
                buttonText == '-' ||
                buttonText == '×' ||
                buttonText == '÷'
            ? Colors.deepPurple
            : Colors.white,
        foregroundColor:
            buttonText == 'C' ||
                buttonText == '=' ||
                buttonText == '+' ||
                buttonText == '-' ||
                buttonText == '×' ||
                buttonText == '÷'
            ? Colors.white
            : Colors.black,
      ),
      onPressed: () => _calculatorButtonPressed(buttonText),
      child: Center(
        child: Text(buttonText, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
