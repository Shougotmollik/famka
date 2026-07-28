import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderTimePickerDialog extends StatefulWidget {
  const ReminderTimePickerDialog({super.key, required this.initialTime});

  final TimeOfDay initialTime;

  static Future<TimeOfDay?> show(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) {
    return showDialog<TimeOfDay>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => ReminderTimePickerDialog(initialTime: initialTime),
    );
  }

  @override
  State<ReminderTimePickerDialog> createState() =>
      _ReminderTimePickerDialogState();
}

class _ReminderTimePickerDialogState extends State<ReminderTimePickerDialog> {
  late bool _isAm;
  late int _hour;
  late int _minute;

  late final FixedExtentScrollController _periodCtrl;
  late final FixedExtentScrollController _hourCtrl;
  late final FixedExtentScrollController _minuteCtrl;

  static const _itemExtent = 44.0;

  @override
  void initState() {
    super.initState();
    final h = widget.initialTime.hour;
    _isAm = h < 12;
    _hour = h % 12 == 0 ? 12 : h % 12;
    _minute = widget.initialTime.minute;

    _periodCtrl = FixedExtentScrollController(initialItem: _isAm ? 0 : 1);
    _hourCtrl = FixedExtentScrollController(initialItem: _hour - 1);
    _minuteCtrl = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _periodCtrl.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  TimeOfDay get _selectedTime {
    int hour = _hour % 12;
    if (!_isAm) hour += 12;
    return TimeOfDay(hour: hour, minute: _minute);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF_1A1E25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set time',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: _itemExtent * 3,
              child: Row(
                children: [
                  // AM / PM
                  Expanded(child: _buildPeriodWheel()),
                  // Hour
                  Expanded(child: _buildHourWheel()),
                  // Minute
                  Expanded(child: _buildMinuteWheel()),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => Navigator.pop(context, _selectedTime),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B2FC4),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodWheel() {
    return _PickerWheel(
      controller: _periodCtrl,
      itemCount: 2,
      itemBuilder: (index) => index == 0 ? 'AM' : 'PM',
      selectedIndex: _isAm ? 0 : 1,
      onChanged: (i) => setState(() => _isAm = i == 0),
    );
  }

  Widget _buildHourWheel() {
    return _PickerWheel(
      controller: _hourCtrl,
      itemCount: 12,
      itemBuilder: (index) => (index + 1).toString().padLeft(2, '0'),
      selectedIndex: _hour - 1,
      onChanged: (i) => setState(() => _hour = i + 1),
    );
  }

  Widget _buildMinuteWheel() {
    return _PickerWheel(
      controller: _minuteCtrl,
      itemCount: 60,
      itemBuilder: (index) => index.toString().padLeft(2, '0'),
      selectedIndex: _minute,
      onChanged: (i) => setState(() => _minute = i),
    );
  }
}

class _PickerWheel extends StatelessWidget {
  const _PickerWheel({
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
    required this.selectedIndex,
    required this.onChanged,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final String Function(int index) itemBuilder;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _itemExtent = 44.0;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _itemExtent,
      perspective: 0.003,
      diameterRatio: 1.8,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final isSelected = index == selectedIndex;
          return Center(
            child: Text(
              itemBuilder(index),
              style: TextStyle(
                fontSize: isSelected ? 22.sp : 16.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? Colors.white : const Color(0xFF8B8E95),
              ),
            ),
          );
        },
      ),
    );
  }
}
