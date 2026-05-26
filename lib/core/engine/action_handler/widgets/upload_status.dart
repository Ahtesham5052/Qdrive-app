import 'package:Qdrive/core/engine/action_handler/providers/visual_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisualSearchUploadStatus extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const VisualSearchUploadStatus({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = ref.watch(visualSearchMediaProvider);

    final hasMedia = media.hasMedia;

    final icon = hasMedia
        ? Icons.check_circle_outline
        : Icons.cloud_upload_outlined;

    final title = hasMedia
        ? data['selectedTitle']?.toString() ?? 'Media selected'
        : data['emptyTitle']?.toString() ?? 'Upload Photo or Video';

    final subtitle = hasMedia
        ? media.fileName ?? 'Tap to change'
        : data['emptySubtitle']?.toString() ?? 'PNG, JPG, MP4 up to 50MB';

    final helper = hasMedia
        ? data['selectedSubtitle']?.toString() ?? 'Tap to replace this file'
        : null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 42,
          color: hasMedia
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 4),
          Text(
            helper,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ],
    );
  }
}