import 'package:flutter/material.dart';
import '../utils/timestamp_formatter.dart';

class InfoHeader extends StatelessWidget {
  final String groupName;
  final String userName;
  final String address;
  final dynamic timestamp;
  final VoidCallback onRefresh;

  const InfoHeader({
    Key? key,
    required this.groupName,
    required this.userName,
    required this.address,
    required this.timestamp,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Group: $groupName',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'User: $userName',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Address: $address',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Timestamp: ${TimestampFormatter.format(timestamp)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
