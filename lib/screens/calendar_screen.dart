import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};
  bool _showWeekends = true;
  bool _showEventIndicators = true;
  Color _selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showWeekends = prefs.getBool('show_weekends') ?? true;
      _showEventIndicators = prefs.getBool('show_event_indicators') ?? true;
      _selectedColor = Color(prefs.getInt('selected_color') ?? Colors.blue.value);
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_weekends', _showWeekends);
    await prefs.setBool('show_event_indicators', _showEventIndicators);
    await prefs.setInt('selected_color', _selectedColor.value);
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calendar Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Show Weekends'),
              subtitle: const Text('Display Saturday and Sunday in the calendar'),
              value: _showWeekends,
              onChanged: (value) {
                setState(() {
                  _showWeekends = value;
                });
                _savePreferences();
              },
            ),
            SwitchListTile(
              title: const Text('Show Event Indicators'),
              subtitle: const Text('Display dots for days with events'),
              value: _showEventIndicators,
              onChanged: (value) {
                setState(() {
                  _showEventIndicators = value;
                });
                _savePreferences();
              },
            ),
            ListTile(
              title: const Text('Calendar Color'),
              subtitle: const Text('Choose the color theme for your calendar'),
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Select Color'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildColorOption(Colors.blue, 'Blue'),
                          _buildColorOption(Colors.purple, 'Purple'),
                          _buildColorOption(Colors.green, 'Green'),
                          _buildColorOption(Colors.orange, 'Orange'),
                          _buildColorOption(Colors.red, 'Red'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color, String name) {
    return ListTile(
      title: Text(name),
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
        _savePreferences();
        Navigator.pop(context);
      },
    );
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString('calendar_events');
    if (eventsJson != null) {
      final Map<String, dynamic> decoded = json.decode(eventsJson);
      setState(() {
        _events = decoded.map((key, value) {
          final date = DateTime.parse(key);
          return MapEntry(date, List<String>.from(value));
        });
      });
    }
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> encoded = _events.map((key, value) {
      return MapEntry(key.toIso8601String(), value);
    });
    await prefs.setString('calendar_events', json.encode(encoded));
  }

  List<String> _getEventsForDay(DateTime day) {
    if (!_showWeekends && (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday)) {
      return [];
    }
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
  }

  void _addEvent() {
    if (_selectedDay == null) return;

    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Progress Note'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter your progress note',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    final date = DateTime(
                      _selectedDay!.year,
                      _selectedDay!.month,
                      _selectedDay!.day,
                    );
                    if (_events[date] == null) {
                      _events[date] = [];
                    }
                    _events[date]!.add(controller.text);
                  });
                  _saveEvents();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Calendar'),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _showOptionsMenu,
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            onFormatChanged: _onFormatChanged,
            onPageChanged: _onPageChanged,
            eventLoader: _showEventIndicators ? _getEventsForDay : null,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: _selectedColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: _selectedColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(
                color: _showWeekends ? null : Colors.transparent,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedDay != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Events for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _getEventsForDay(_selectedDay!).length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_getEventsForDay(_selectedDay!)[index]),
                    leading: Icon(Icons.check_circle, color: _selectedColor),
                  );
                },
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        backgroundColor: _selectedColor,
        child: const Icon(Icons.add),
      ),
    );
  }
} 