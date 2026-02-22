import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import 'download_controler.dart';

class DownloadTile extends StatelessWidget {
  const DownloadTile({super.key, required this.controller});

  final DownloadController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // File icon
                Icon(
                  Icons.insert_drive_file,
                  color: AppColors.iconLight,
                  size: 30,
                ),
                const SizedBox(width: 12),

                // File info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.ressource.name,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        '${(controller.progress * 100).toStringAsFixed(1)} % completed'
                        ' - ${(controller.progress * controller.ressource.size).toStringAsFixed(1)}'
                        ' of ${controller.ressource.size} MB',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Action icon — changes per download state
                _buildAction(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAction() {
    switch (controller.status) {
      case DownloadStatus.notDownloaded:
        return GestureDetector(
          onTap: controller.startDownload,
          child: Icon(Icons.download, color: AppColors.iconNormal, size: 30),
        );

      case DownloadStatus.downloading:
        return Icon(Icons.downloading, color: AppColors.iconNormal, size: 30);

      case DownloadStatus.downloaded:
        return Icon(Icons.folder, color: AppColors.iconNormal, size: 30);
    }
  }
}
