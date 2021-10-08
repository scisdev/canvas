import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawLayerCubit extends Cubit<int> {
  DrawLayerCubit(Size canvasDimensions, double pixelDensity) : super(0) {}
}

///pixels are laid out FIRST left to right THEN top to bottom
class Pixel {
  final int x;
  final int y;
  int color = 0;

  Pixel(this.x, this.y);
}

class PixelUtils {
  static List<Pixel> getPixelsInGivenCircularRange(
    int cx,
    int cy,
    int r,
    CanvasData data,
  ) {
    final left = math.max(0, cx - r);
    final right = math.min(data.width, cx + r);
    final top = math.max(0, cy - r);
    final bottom = math.min(data.height, cy + r);

    var res = <Pixel>[];

    for (var y = top; y < bottom; y++) {
      for (var x = left; x < right; x++) {
        final fx = abs(x - cx);
        final fy = abs(y - cy);
        if (fx * fx + fy * fy < r * r) {
          res.add(getPixel(x, y, data));
        }
      }
    }

    return res;
  }

  static int abs(int x) {
    if (x >= 0) return x;

    return -x;
  }

  static Pixel getPixel(int x, int y, CanvasData data) {
    return data.pixels[y * data.width + x];
  }
}

class CanvasData {
  final int width;
  final int height;
  final List<Pixel> pixels;

  CanvasData({
    required this.width,
    required this.height,
    required this.pixels,
  });
}
