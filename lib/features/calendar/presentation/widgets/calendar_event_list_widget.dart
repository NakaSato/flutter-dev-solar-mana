import 'package:flutter/material.dart';

import '../../domain/entities/calendar_event.dart';

/// Widget for displaying a list of calendar events
///
/// This widget provides a clean, Material Design 3 compliant list
/// of calendar events with optional customization for display options.
class CalendarEventListWidget extends StatelessWidget {
  /// Creates a [CalendarEventListWidget]
  const CalendarEventListWidget({
    super.key,
    required this.events,
    this.onEventTap,
    this.showDate = true,
    this.showProject = true,
    this.showPriority = true,
  });

  /// List of calendar events to display
  final List<CalendarEvent> events;

  /// Callback when an event is tapped
  final void Function(CalendarEvent)? onEventTap;

  /// Whether to show event dates
  final bool showDate;

  /// Whether to show project information
  final bool showProject;

  /// Whether to show priority badges
  final bool showPriority;

  // Spacing constants following Material Design 3 4dp grid system
  static const double _cardMarginHorizontal = 16.0;
  static const double _cardMarginVertical = 8.0;
  static const double _cardPadding = 16.0;
  static const double _emptyStateIconSize = 64.0;
  static const double _eventTypeIconSize = 20.0;
  static const double _smallIconSize = 16.0;
  static const double _colorIndicatorSize = 12.0;
  static const double _spaceSmall = 4.0;
  static const double _spaceMedium = 8.0;
  static const double _spaceLarge = 12.0;
  static const double _spaceXLarge = 16.0;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(context, event);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: _emptyStateIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: _spaceXLarge),
          Text(
            'No Events',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: _spaceMedium),
          Text(
            'No calendar events found',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, CalendarEvent event) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: _cardMarginHorizontal,
        vertical: _cardMarginVertical,
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => onEventTap?.call(event),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(_cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildEventTypeIcon(event.eventType),
                  const SizedBox(width: _spaceLarge),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (showDate) ...[
                          const SizedBox(height: _spaceSmall),
                          Text(
                            _formatEventDateTime(event),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showPriority) _buildPriorityBadge(event.priority),
                  if (event.color != null)
                    Container(
                      width: _colorIndicatorSize,
                      height: _colorIndicatorSize,
                      margin: const EdgeInsets.only(left: _spaceMedium),
                      decoration: BoxDecoration(
                        color: _parseColor(event.color!),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              if (event.description != null &&
                  event.description!.isNotEmpty) ...[
                const SizedBox(height: _spaceMedium),
                Text(
                  event.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: _spaceMedium),
              Wrap(
                spacing: _spaceMedium,
                runSpacing: _spaceSmall,
                children: [
                  _buildStatusChip(event.status),
                  if (event.location != null && event.location!.isNotEmpty)
                    _buildLocationChip(context, event.location!),
                ],
              ),
              if (showProject &&
                  event.projectName != null &&
                  event.projectName!.isNotEmpty) ...[
                const SizedBox(height: _spaceMedium),
                Row(
                  children: [
                    Icon(
                      Icons.work,
                      size: _smallIconSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: _spaceSmall),
                    Text(
                      'Project: ${event.projectName!}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
              if (event.assignedToUserName != null &&
                  event.assignedToUserName!.isNotEmpty) ...[
                const SizedBox(height: _spaceSmall),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: _smallIconSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: _spaceSmall),
                    Text(
                      'Assigned: ${event.assignedToUserName!}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTypeIcon(CalendarEventType type) {
    return Container(
      padding: const EdgeInsets.all(_spaceMedium),
      decoration: BoxDecoration(
        color: _parseColor(type.defaultColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getEventTypeIcon(type),
        size: _eventTypeIconSize,
        color: _parseColor(type.defaultColor),
      ),
    );
  }

  Widget _buildStatusChip(CalendarEventStatus status) {
    return Chip(
      label: Text(
        status.displayName,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      backgroundColor: _parseColor(status.color).withValues(alpha: 0.1),
      side: BorderSide(color: _parseColor(status.color)),
      padding: const EdgeInsets.symmetric(horizontal: _spaceSmall),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildPriorityBadge(CalendarEventPriority priority) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _spaceMedium,
        vertical: _spaceSmall,
      ),
      decoration: BoxDecoration(
        color: priority.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.displayName,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLocationChip(BuildContext context, String location) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _spaceMedium,
        vertical: _spaceSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            size: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: _spaceSmall),
          Flexible(
            child: Text(
              location,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatEventDateTime(CalendarEvent event) {
    if (event.isAllDay) {
      return 'All day - ${_formatDate(event.startDateTime)}';
    }

    final startDate = _formatDate(event.startDateTime);
    final endDate = _formatDate(event.endDateTime);
    final startTime = _formatTime(event.startDateTime);
    final endTime = _formatTime(event.endDateTime);

    if (startDate == endDate) {
      return '$startDate, $startTime - $endTime';
    } else {
      return '$startDate $startTime - $endDate $endTime';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour == 0
        ? 12
        : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Color _parseColor(String colorHex) {
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  IconData _getEventTypeIcon(CalendarEventType type) {
    switch (type) {
      case CalendarEventType.meeting:
        return Icons.group;
      case CalendarEventType.deadline:
        return Icons.alarm;
      case CalendarEventType.installation:
        return Icons.build;
      case CalendarEventType.maintenance:
        return Icons.settings;
      case CalendarEventType.training:
        return Icons.school;
      case CalendarEventType.other:
        return Icons.event;
    }
  }
}
