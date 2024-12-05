import 'package:flutter/material.dart';

class ProjectTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ProjectTable({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Title')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Employees on this Project')),
        ],
        rows: data.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item['title'])),
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item['statusColor'],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item['status'],
                  style: const TextStyle(color: Colors.white),
                ),
              )),
              DataCell(Text(item['date'])),
              DataCell(Row(
                children: [
                  ...item['employees'].map<Widget>((employee) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(employee),
                      ),
                    );
                  }).toList(),
                  if (item['additionalCount'] > 0)
                    Text('+${item['additionalCount']}'),
                ],
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class MyTablePage extends StatelessWidget {
  MyTablePage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> projectData = [
    {
      'title': 'FRONT BUMPERS',
      'status': 'ONGOING',
      'statusColor': Colors.green,
      'date': '2023/09/17',
      'employees': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
      'additionalCount': 3,
    },
    {
      'title': 'WING MIRRORS',
      'status': 'DONE',
      'statusColor': Colors.blue,
      'date': '2023/09/17',
      'employees': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
      'additionalCount': 3,
    },
    {
      'title': 'Text',
      'status': 'SEARCH',
      'statusColor': Colors.yellow,
      'date': '2023/09/17',
      'employees': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
      'additionalCount': 3,
    },
    {
      'title': 'Text',
      'status': 'LABEL',
      'statusColor': Colors.orange,
      'date': '2023/09/17',
      'employees': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
      'additionalCount': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Table')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProjectTable(data: projectData),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyTablePage(),
  ));
}
