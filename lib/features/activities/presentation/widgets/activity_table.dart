import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:guardian_area/features/activities/domain/entities/activity.dart';

class ActivityTable extends StatelessWidget {
  final List<Activity> activities;

  const ActivityTable({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    const rowsPerPage = 5;

    return PaginatedDataTable(
      columns: const [
        DataColumn(
          label: Text(
            'Event',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF08273A),
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Date and Time',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF08273A),
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Type',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF08273A),
            ),
          ),
        ),
      ],
      source: ActivityDataSource(activities),
      rowsPerPage: rowsPerPage,
      columnSpacing: 20.0,
      horizontalMargin: 20.0,
      showCheckboxColumn: false,
    );
  }
}

class ActivityDataSource extends DataTableSource {
  final List<Activity> activities;

  ActivityDataSource(this.activities);

  @override
  DataRow getRow(int index) {
    if (index >= activities.length) return const DataRow(cells: []);

    final activity = activities[index];
    final formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.dateAndTime);

    return DataRow(
      cells: [
        DataCell(Text(activity.activityName)),
        DataCell(Text(formattedDate)),
        DataCell(Text(activity.activityType)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => activities.length;

  @override
  int get selectedRowCount => 0;
}
