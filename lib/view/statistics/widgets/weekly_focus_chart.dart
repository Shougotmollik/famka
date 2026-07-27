import 'package:famka/config/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeeklyFocusChart extends StatelessWidget {
  final List<double> weekData;
  final int todayIndex;

  const WeeklyFocusChart({
    super.key,
    required this.weekData,
    required this.todayIndex,
  });

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _cardBg = Color(0xFF252A34);
  static const _barBg = Color(0xFF2E3340);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 24.h),
          _buildChart(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Focus during the week",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "This week",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return SizedBox(
      height: 160.h,
      child: BarChart(
        BarChartData(
          maxY: 10,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28.h,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= _days.length) return const SizedBox();
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      _days[idx],
                      style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(weekData.length, (i) {
            final isToday = i == todayIndex;
            final value = weekData[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: value == 0 ? 0.4 : value,
                  width: 28.w,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r),
                  ),
                  color: isToday ? AppColors.primary : _barBg,
                  backDrawRodData: BackgroundBarChartRodData(show: false),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
