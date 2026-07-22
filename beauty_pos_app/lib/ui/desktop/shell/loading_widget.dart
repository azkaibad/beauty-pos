// lib/ui/desktop/shell/loading_widget.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

/// Widget shimmer untuk placeholder loading
class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingWidget({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundMuted,
      highlightColor: AppColors.surfaceLight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.backgroundMuted,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer card placeholder untuk list item
class LoadingCard extends StatelessWidget {
  final double? height;

  const LoadingCard({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.backgroundMuted),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.backgroundMuted,
        highlightColor: AppColors.surfaceLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.backgroundMuted,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 160,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.backgroundMuted,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer stat card placeholder (untuk Dashboard)
class LoadingStatCard extends StatelessWidget {
  const LoadingStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.backgroundMuted),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.backgroundMuted,
        highlightColor: AppColors.surfaceLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundMuted,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.backgroundMuted,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 60,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.backgroundMuted,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// List shimmer — tampilkan N item loading sekaligus
class LoadingList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const LoadingList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, _) => LoadingCard(height: itemHeight),
    );
  }
}
