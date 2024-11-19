import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:guardian_area/features/activities/domain/entities/activity.dart';

class ActivityTable extends StatefulWidget {
  final List<Activity> activities;

  const ActivityTable({super.key, required this.activities});

  @override
  State<ActivityTable> createState() => _ActivityTableState();
}

class _ActivityTableState extends State<ActivityTable> {
  late final ActivityDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = ActivityDataSource(widget.activities);
  }

  @override
  Widget build(BuildContext context) {
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
      source: _dataSource,
      rowsPerPage: 5, // !Número de filas por página
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
