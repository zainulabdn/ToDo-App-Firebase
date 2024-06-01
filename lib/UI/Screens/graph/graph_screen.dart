import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/Models/task_model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TaskStatisticsScreen extends StatefulWidget {
  final String uid;

  const TaskStatisticsScreen({super.key, required this.uid});

  @override
  _TaskStatisticsScreenState createState() => _TaskStatisticsScreenState();
}

class _TaskStatisticsScreenState extends State<TaskStatisticsScreen> {
  List<Task>? tasks;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() {
    FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: widget.uid) // Filter tasks by UID
        .get()
        .then((querySnapshot) {
      setState(() {
        tasks =
            querySnapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
      });
    }).catchError((error) {
      print('Error fetching tasks: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back, color: kBlack)),
        backgroundColor: Colors.transparent,
        title: const Text(
          'Task Statistics',
          style: TextStyle(color: kBlack),
        ),
      ),
      body: tasks != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  buildTaskChart(),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildTaskChart() {
    // Calculate task statistics
    List<TaskStatistic> taskStatistics = calculateTaskStatistics(tasks!);

    // Create a chart series
    List<CartesianSeries<TaskStatistic, String>> series = [
      ColumnSeries<TaskStatistic, String>(
        // Bind data source
        dataSource: taskStatistics,
        xValueMapper: (TaskStatistic stat, _) => stat.period,
        yValueMapper: (TaskStatistic stat, _) => stat.doneCount,
        name: 'Done',
        color: Colors.green, // Color for Done tasks
      ),
      ColumnSeries<TaskStatistic, String>(
        // Bind data source
        dataSource: taskStatistics,
        xValueMapper: (TaskStatistic stat, _) => stat.period,
        yValueMapper: (TaskStatistic stat, _) => stat.lateDoneCount,
        name: 'Late Done',
        color: Colors.red, // Color for Late Done tasks
      ),
      ColumnSeries<TaskStatistic, String>(
        // Bind data source
        dataSource: taskStatistics,
        xValueMapper: (TaskStatistic stat, _) => stat.period,
        yValueMapper: (TaskStatistic stat, _) => stat.pendingCount,
        name: 'Pending',
        color: Colors.yellow, // Color for Pending tasks
      ),
    ];

    // Build and return the chart widget
    return Center(
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          // Initialize category axis
          primaryXAxis: const CategoryAxis(),

          // Initialize numeric axis with integer interval
          primaryYAxis: NumericAxis(
            interval:
                1, // Set the interval to 1 to ensure only integer values are displayed
            labelFormat: '{value}', // Format to display values as integers
          ),

          // Add series to the chart
          series: series,

          // Add legend
          legend: Legend(isVisible: true),
        ),
      ),
    );
  }

  List<TaskStatistic> calculateTaskStatistics(List<Task> tasks) {
    // For demonstration purposes, let's assume we're calculating statistics for each month
    Map<String, TaskStatistic> statisticsMap = {};

    // Iterate through the tasks
    for (var task in tasks) {
      // Convert the task's create date to a formatted month string (e.g., 'Jan 2024')
      String monthYear = DateFormat('MMM yyyy').format(task.createDate);

      // Check if the statistic for this month exists in the map
      if (statisticsMap.containsKey(monthYear)) {
        // Update the existing statistic based on the task's properties
        TaskStatistic statistic = statisticsMap[monthYear]!;
        statistic.totalCount++;
        if (task.done) {
          statistic.doneCount++;
        } else if (task.lateDone) {
          statistic.lateDoneCount++;
        } else {
          statistic
              .pendingCount++; // Increment pendingCount if not done or late done
        }
      } else {
        // Create a new statistic for this month
        TaskStatistic statistic = TaskStatistic(
          period: monthYear,
          doneCount: task.done ? 1 : 0,
          lateDoneCount: task.lateDone ? 1 : 0,
          pendingCount:
              (!task.done && !task.lateDone) ? 1 : 0, // Initialize pendingCount
        );
        statisticsMap[monthYear] = statistic;
      }
    }

    // Convert the map values to a list and return
    return statisticsMap.values.toList();
  }
}

// TaskStatistic class to represent task statistics for a specific time period
class TaskStatistic {
  final String period;
  int doneCount;
  int lateDoneCount;
  int totalCount;
  int pendingCount;

  TaskStatistic({
    required this.period,
    required this.doneCount,
    required this.pendingCount,
    required this.lateDoneCount,
  }) : totalCount =
            doneCount + lateDoneCount + pendingCount; // Calculate totalCount

  // Other methods or properties can be added here if needed
}
