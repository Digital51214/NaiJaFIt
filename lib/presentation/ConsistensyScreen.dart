import 'package:flutter/material.dart';

class ConsistencyScreen extends StatefulWidget {
  const ConsistencyScreen({super.key});

  @override
  State<ConsistencyScreen> createState() => _ConsistencyScreenState();
}

class _ConsistencyScreenState extends State<ConsistencyScreen> {
  // Current displayed month/year
  DateTime _displayedMonth = DateTime(2023, 9);

  // Selected day (single selectable green circle)
  DateTime _selectedDate = DateTime(2023, 9, 13);

  // Today
  final DateTime _today = DateTime(2023, 9, 13);

  final int _currentStreak = 5;
  final int _personalBest = 14;
  final int _missedDays = 2;
  final double _consistencyRate = 84;

  // Month name helper
  static const _monthNames = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  void _prevMonth() => setState(() {
    _displayedMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month - 1);

    final lastDay =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

    if (_selectedDate.year != _displayedMonth.year ||
        _selectedDate.month != _displayedMonth.month) {
      _selectedDate =
          DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    } else if (_selectedDate.day > lastDay) {
      _selectedDate =
          DateTime(_displayedMonth.year, _displayedMonth.month, lastDay);
    }
  });

  void _nextMonth() => setState(() {
    _displayedMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1);

    final lastDay =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

    if (_selectedDate.year != _displayedMonth.year ||
        _selectedDate.month != _displayedMonth.month) {
      _selectedDate =
          DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    } else if (_selectedDate.day > lastDay) {
      _selectedDate =
          DateTime(_displayedMonth.year, _displayedMonth.month, lastDay);
    }
  });

  // Fixed 5-row calendar
  // Only current month dates
  // No previous/next month extra dates
  List<DateTime?> _buildCalendarDays() {
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final int startOffset = firstDay.weekday - 1; // Mon = 0
    final int lastDay =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

    final List<DateTime?> days = [];

    // Leading empty cells
    for (int i = 0; i < startOffset; i++) {
      days.add(null);
    }

    // Current month days only
    for (int d = 1; d <= lastDay; d++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month, d));
    }

    // Fill remaining cells to always make 5 rows = 35 cells
    while (days.length < 35) {
      days.add(null);
    }

    // Force max 35 cells so 6th row never appears
    return days.take(35).toList();
  }

  bool _isCurrentMonth(DateTime d) =>
      d.month == _displayedMonth.month && d.year == _displayedMonth.year;

  bool _isSelected(DateTime d) =>
      d.year == _selectedDate.year &&
          d.month == _selectedDate.month &&
          d.day == _selectedDate.day;

  bool _isToday(DateTime d) =>
      d.year == _today.year && d.month == _today.month && d.day == _today.day;

  void _onDateTap(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double wp = size.width;
    final double hp = size.height;

    final calDays = _buildCalendarDays();
    const int rowCount = 5;
    final double cellSize = wp * 0.094;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: wp * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: hp * 0.02),

              // ── Top Bar ──
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: wp * 0.13,
                      height: wp * 0.13,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF2D6A2D),
                        size: 26,
                      ),
                    ),
                  ),
                  SizedBox(width: wp * 0.03),
                  Text(
                    'Consistency',
                    style: TextStyle(
                      fontSize: wp * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Image(
                    image: const AssetImage("assets/images/LOGO.png"),
                    height: hp * 0.08,
                    width: wp * 0.18,
                  ),
                ],
              ),

              SizedBox(height: hp * 0.03),

              // ── Habit Card ──
              Container(
                height: size.height * 0.21,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: hp * 0.02,
                  horizontal: wp * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      width: wp * 0.135,
                      height: wp * 0.135,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC8E6C0),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: const Color(0xFF2D7D2D),
                          size: wp * 0.065,
                        ),
                      ),
                    ),
                    SizedBox(height: hp * 0.014),
                    Text(
                      '$_currentStreak Day Habbit',
                      style: TextStyle(
                        fontSize: wp * 0.07,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: hp * 0.002),
                    Text(
                      'Personal best $_personalBest days',
                      style: TextStyle(
                        fontSize: wp * 0.038,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: hp * 0.025),

              // ── Calendar Card ──
              Container(
                width: double.infinity,
                height: 273,
                padding: EdgeInsets.only(top: wp*0.03,bottom: wp*0.03,
                right: wp*0.05,left: wp*0.05),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Month header
                    Row(
                      children: [
                        Text(
                          '${_monthNames[_displayedMonth.month]} ${_displayedMonth.year}',
                          style: TextStyle(
                            fontSize: wp * 0.055,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _prevMonth,
                          child: Icon(
                            Icons.chevron_left,
                            size: wp * 0.065,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(width: wp * 0.02),
                        GestureDetector(
                          onTap: _nextMonth,
                          child: Icon(
                            Icons.chevron_right,
                            size: wp * 0.065,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: hp * 0.02),

                    // Day-of-week headers
                    Row(
                      children: const [
                        Expanded(child: _WeekLabel('MON')),
                        Expanded(child: _WeekLabel('TUE')),
                        Expanded(child: _WeekLabel('WED')),
                        Expanded(child: _WeekLabel('THU')),
                        Expanded(child: _WeekLabel('FRI')),
                        Expanded(child: _WeekLabel('SAT')),
                        Expanded(child: _WeekLabel('SUN')),
                      ],
                    ),

                    SizedBox(height: hp * 0.006),

                    // Calendar grid
                    ...List.generate(rowCount, (row) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: hp * 0.004),
                        child: Row(
                          children: List.generate(7, (col) {
                            final index = row * 7 + col;
                            final date = calDays[index];

                            return Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: date == null
                                    ? SizedBox(
                                  width: cellSize,
                                  height: cellSize * 0.82,
                                )
                                    : _CalendarDay(
                                  date: date,
                                  isCurrentMonth: _isCurrentMonth(date),
                                  isSelected: _isSelected(date),
                                  isToday: _isToday(date),
                                  cellSize: cellSize * 1,
                                  onTap: () => _onDateTap(date),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              SizedBox(height: hp * 0.018),

              // ── Stats Row ──
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: hp * 0.115,
                      padding: EdgeInsets.symmetric(
                        horizontal: wp * 0.05,
                        vertical: hp * 0.018,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Consistency Rate',
                            style: TextStyle(
                              fontSize: wp * 0.03,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: hp * 0.007),
                          Text(
                            '${_consistencyRate.toInt()}%',
                            style: TextStyle(
                              fontSize: wp * 0.07,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: wp * 0.04),
                  Expanded(
                    child: Container(
                      height: hp * 0.115,
                      padding: EdgeInsets.symmetric(
                        horizontal: wp * 0.05,
                        vertical: hp * 0.018,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Missed Days',
                            style: TextStyle(
                              fontSize: wp * 0.03,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: hp * 0.007),
                          Text(
                            '$_missedDays',
                            style: TextStyle(
                              fontSize: wp * 0.07,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: hp * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Week day label ──
class _WeekLabel extends StatelessWidget {
  final String label;
  const _WeekLabel(this.label);

  @override
  Widget build(BuildContext context) {
    final wp = MediaQuery.of(context).size.width;
    return Center(
      child: Text(
        label,
        style: TextStyle(
          fontSize: wp * 0.028,
          fontWeight: FontWeight.w600,
          color: Colors.grey[500],
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ── Single Calendar Day Cell ──
class _CalendarDay extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final double cellSize;
  final VoidCallback onTap;

  const _CalendarDay({
    super.key,
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.cellSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor;
    FontWeight fontWeight;

    if (isSelected) {
      bgColor = const Color(0xFF2D7D2D);
      textColor = Colors.white;
      fontWeight = FontWeight.bold;
    } else if (isCurrentMonth) {
      bgColor = null;
      textColor = Colors.black;
      fontWeight = isToday ? FontWeight.bold : FontWeight.w400;
    } else {
      bgColor = null;
      textColor = Colors.grey.shade400;
      fontWeight = FontWeight.w400;
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cellSize,
        height: cellSize,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: cellSize * 0.92,
            height: cellSize * 0.92,
            decoration: bgColor != null
                ? const BoxDecoration(
              color: Color(0xFF2D7D2D),
              shape: BoxShape.circle,
            )
                : null,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: cellSize * 0.38,
                  color: textColor,
                  fontWeight: fontWeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}