import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final bool isCompact;

  const StatusChip({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isCompact ? 6 : 8,
            height: isCompact ? 6 : 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: isCompact ? 4 : 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

