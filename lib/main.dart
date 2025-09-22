import 'dart:async';

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
      title: '小明工具箱',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // 与网页主题一致的紫色
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFF4F46E5),
          tertiary: const Color(0xFFEC4899),
          background: const Color(0xFFF8FAFC),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: const Color(0xFF1E293B),
          onSurface: const Color(0xFF1E293B),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const UtilHomePage(),
    );
  }
}

class UtilHomePage extends StatelessWidget {
  const UtilHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('小明工具箱'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NoteWidget(),
                const SizedBox(height: 16),
                DateTimeWidget(),
                const SizedBox(height: 16),
                TimerWidget(),
                const SizedBox(height: 16),
                CalculatorWidget(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;
    final currentDay = now.day;

    // 获取当月第一天是星期几
    final firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    final firstDayWeekday = firstDayOfMonth.weekday;

    // 获取当月的总天数
    final lastDayOfMonth = DateTime(currentYear, currentMonth + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // 获取上个月的最后几天
    final lastDayOfPrevMonth = DateTime(currentYear, currentMonth, 0);
    final daysFromPrevMonth = firstDayWeekday - 1;

    // 创建日历网格数据
    final List<Widget> calendarGrid = [];

    // 添加表头（星期）
    const weekdays = ['日', '一', '二', '三', '四', '五', '六'];
    for (var weekday in weekdays) {
      calendarGrid.add(
        Container(
          alignment: Alignment.center,
          child: Text(
            weekday,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // 添加上个月的最后几天
    for (int i = daysFromPrevMonth; i > 0; i--) {
      final day = lastDayOfPrevMonth.day - i + 1;
      calendarGrid.add(
        Container(
          alignment: Alignment.center,
          child: Text(
            day.toString(),
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      );
    }

    // 添加当月的天数
    for (int day = 1; day <= daysInMonth; day++) {
      bool isToday = day == currentDay;
      calendarGrid.add(
        Container(
          alignment: Alignment.center,
          decoration: isToday
              ? BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(20),
                )
              : null,
          child: Text(
            day.toString(),
            style: isToday
                ? const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )
                : null,
          ),
        ),
      );
    }

    // 添加下个月的开始几天以填满网格
    final daysToAdd = 42 - calendarGrid.length; // 6行7列的网格
    for (int day = 1; day <= daysToAdd; day++) {
      calendarGrid.add(
        Container(
          alignment: Alignment.center,
          child: Text(
            day.toString(),
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 300),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$currentYear年$currentMonth月',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          // 日历网格
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: calendarGrid,
          ),
          const SizedBox(height: 16),
          // 当前日期信息
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '今日事项',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '今天是${DateFormat('yyyy年MM月dd日').format(now)}，星期${weekdays[now.weekday]}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '• 下午3点项目会议',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;
  bool _isRepeating = false;
  String _reminderText = '';
  late Timer _timer;
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();

  @override
  void dispose() {
    _timer.cancel();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _reminderController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning && _totalSeconds > 0) {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_totalSeconds > 0) {
            _totalSeconds--;
            _updateDisplayTimes();
          } else {
            _stopTimer();
            // 这里可以添加提醒功能，如显示通知或播放声音
            if (_isRepeating && _hours + _minutes + _seconds > 0) {
              _resetTimerToInitialValues();
              _startTimer();
            }
          }
        });
      });
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      setState(() {
        _isRunning = false;
      });
      _timer.cancel();
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      setState(() {
        _isRunning = false;
      });
      _timer.cancel();
    }
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _totalSeconds = 0;
      _hours = 0;
      _minutes = 0;
      _seconds = 0;
      _hoursController.text = '';
      _minutesController.text = '';
      _secondsController.text = '';
    });
  }

  void _resetTimerToInitialValues() {
    _stopTimer();
    setState(() {
      _totalSeconds = _hours * 3600 + _minutes * 60 + _seconds;
    });
    _startTimer();
  }

  void _updateDisplayTimes() {
    _hours = _totalSeconds ~/ 3600;
    _minutes = (_totalSeconds % 3600) ~/ 60;
    _seconds = _totalSeconds % 60;
  }

  void _setTimerValues() {
    setState(() {
      _hours = int.tryParse(_hoursController.text) ?? 0;
      _minutes = int.tryParse(_minutesController.text) ?? 0;
      _seconds = int.tryParse(_secondsController.text) ?? 0;
      _totalSeconds = _hours * 3600 + _minutes * 60 + _seconds;
      _reminderText = _reminderController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 300),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '定时提醒',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 倒计时显示
          Text(
            '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier',
              color: Color(0xFF6366F1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 控制按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('开始'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _pauseTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8FAFC),
                  foregroundColor: const Color(0xFF1E293B),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('暂停'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _resetTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8FAFC),
                  foregroundColor: const Color(0xFF1E293B),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('重置'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 时间设置
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '设置时间',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _hoursController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _setTimerValues(),
                        decoration: const InputDecoration(
                          hintText: '小时',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _minutesController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _setTimerValues(),
                        decoration: const InputDecoration(
                          hintText: '分钟',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _secondsController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _setTimerValues(),
                        decoration: const InputDecoration(
                          hintText: '秒',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 自定义提醒
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '自定义提醒',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _reminderController,
                  decoration: const InputDecoration(
                    hintText: '提醒内容',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _isRepeating,
                      onChanged: (value) {
                        setState(() {
                          _isRepeating = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF6366F1),
                    ),
                    const Text(
                      '重复提醒',
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key});

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String _display = '0';
  double _firstOperand = 0;
  double _secondOperand = 0;
  String _operator = '';
  bool _waitingForSecondOperand = false;

  void _handleNumber(String number) {
    setState(() {
      if (_waitingForSecondOperand) {
        _display = number;
        _waitingForSecondOperand = false;
      } else {
        _display = _display == '0' ? number : _display + number;
      }
    });
  }

  void _handleOperator(String operator) {
    setState(() {
      if (_operator.isNotEmpty && !_waitingForSecondOperand) {
        _calculate();
      }
      _firstOperand = double.parse(_display);
      _operator = operator;
      _waitingForSecondOperand = true;
    });
  }

  void _calculate() {
    setState(() {
      _secondOperand = double.parse(_display);
      double result = 0;

      switch (_operator) {
        case '+':
          result = _firstOperand + _secondOperand;
          break;
        case '-':
          result = _firstOperand - _secondOperand;
          break;
        case '×':
          result = _firstOperand * _secondOperand;
          break;
        case '÷':
          if (_secondOperand != 0) {
            result = _firstOperand / _secondOperand;
          } else {
            _display = '错误';
            _operator = '';
            _firstOperand = 0;
            _secondOperand = 0;
            _waitingForSecondOperand = false;
            return;
          }
          break;
      }

      // 移除小数点后多余的0
      if (result % 1 == 0) {
        _display = result.toInt().toString();
      } else {
        _display = result.toString();
      }

      _operator = '';
      _firstOperand = result;
      _waitingForSecondOperand = true;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _firstOperand = 0;
      _secondOperand = 0;
      _operator = '';
      _waitingForSecondOperand = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 400),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '智能计算器',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 显示区域
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 按钮网格
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: [
              // 第一行
              CalculatorButton(
                label: '7',
                onPressed: () => _handleNumber('7'),
                isNumber: true,
              ),
              CalculatorButton(
                label: '8',
                onPressed: () => _handleNumber('8'),
                isNumber: true,
              ),
              CalculatorButton(
                label: '9',
                onPressed: () => _handleNumber('9'),
                isNumber: true,
              ),
              CalculatorButton(
                label: '÷',
                onPressed: () => _handleOperator('÷'),
                isOperator: true,
              ),
              // 第二行
              CalculatorButton(
                label: '4',
                onPressed: () => _handleNumber('4'),
                isNumber: true,
              ),
              CalculatorButton(
                label: '5',
                onPressed: () => _handleNumber('5'),
                isNumber: true,
              ),
              CalculatorButton(
                label: '6',
                onPressed: () => _handleNumber('6'),
                isNumber: true,
              ),
              CalculatorButton(
                label: '×',
                onPressed: () => _handleOperator('×'),
                isOperator: true,
              ),
              // 第三行
              CalculatorButton(
                label: '1',
                onPressed: () => _handleNumber('1'),
                isNumber: true,
              ),
              CalculatorButton(
                label: '2',
                onPressed: () => _handleNumber('2'),
                isNumber: true,
              ),
              CalculatorButton(
                label: '3',
                onPressed: () => _handleNumber('3'),
                isNumber: true,
              ),
              CalculatorButton(
                label: '-',
                onPressed: () => _handleOperator('-'),
                isOperator: true,
              ),
              // 第四行
              CalculatorButton(label: 'C', onPressed: _clear, isClear: true),
              CalculatorButton(
                label: '0',
                onPressed: () => _handleNumber('0'),
                isNumber: true,
              ),
              CalculatorButton(
                label: '=',
                onPressed: _calculate,
                isEquals: true,
              ),
              CalculatorButton(
                label: '+',
                onPressed: () => _handleOperator('+'),
                isOperator: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isNumber;
  final bool isOperator;
  final bool isClear;
  final bool isEquals;

  const CalculatorButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isNumber = false,
    this.isOperator = false,
    this.isClear = false,
    this.isEquals = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    Color textColor = Colors.black;

    if (isNumber) {
      backgroundColor = const Color(0xFFE2E8F0);
      textColor = const Color(0xFF1E293B);
    } else if (isOperator) {
      backgroundColor = const Color(0xFF6366F1);
      textColor = Colors.white;
    } else if (isClear) {
      backgroundColor = const Color(0xFFEF4444);
      textColor = Colors.white;
    } else if (isEquals) {
      backgroundColor = const Color(0xFF22C55E);
      textColor = Colors.white;
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 100),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '备忘录',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4),
          Text('今天下午三点开会', style: TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }
}
