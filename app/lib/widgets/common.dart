import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Bo'lim sarlavhasi.
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionHeader(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}

/// Doiraviy progress halqa (markazida matn).
class ProgressRing extends StatelessWidget {
  final double progress; // 0..1
  final Color color;
  final double size;
  final Widget center;
  final double stroke;
  const ProgressRing({
    super.key,
    required this.progress,
    required this.color,
    required this.center,
    this.size = 120,
    this.stroke = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress.clamp(0, 1).toDouble(),
          color,
          stroke,
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Center(child: center),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double stroke;
  final Color bg;
  _RingPainter(this.progress, this.color, this.stroke, this.bg);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final bgPaint = Paint()
      ..color = bg
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.color != color;
}

/// Oddiy ustunli (bar) mini-grafik.
class MiniBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final String Function(double)? valueLabel;
  const MiniBarChart({
    super.key,
    required this.values,
    required this.labels,
    required this.color,
    this.valueLabel,
  });

  @override
  Widget build(BuildContext context) {
    final maxV = values.isEmpty ? 1.0 : values.reduce(math.max);
    final safeMax = maxV <= 0 ? 1.0 : maxV;
    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final v = values[i];
          final h = (v / safeMax) * 96;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (valueLabel != null && v > 0)
                  Text(valueLabel!(v),
                      style: const TextStyle(fontSize: 9),
                      maxLines: 1),
                const SizedBox(height: 2),
                Container(
                  height: math.max(3, h),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: v > 0 ? color : color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(labels[i], style: const TextStyle(fontSize: 10)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Bosh ekrandagi metrika kartasi.
class MetricCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String? subtitle;
  final double? progress;
  final VoidCallback? onTap;
  const MetricCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    this.subtitle,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Spacer(),
                  if (progress != null)
                    SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        value: progress!.clamp(0, 1),
                        strokeWidth: 4,
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.15),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(title,
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              if (subtitle != null)
                Text(subtitle!,
                    style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
