import 'dart:math' show Rectangle, Point, max;

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'package:charts_flutter/src/text_style.dart' as chartsTextStyle;


class TooltipSymbolRenderer extends charts.CircleSymbolRenderer {

  String value = '';

  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.FillPatternType fillPattern,
      charts.Color strokeColor,
      double strokeWidthPx}) {

    // CircleSymbolRendererの描画処理は不要
    // super.paint(canvas, bounds,
    //     dashPattern: dashPattern,
    //     fillColor: fillColor,
    //     strokeColor: strokeColor,
    //     strokeWidthPx: strokeWidthPx);

    var bgColor = charts.Color.fromHex(code: '#262626');
    var textColor = charts.Color.fromHex(code: '#FFFFFF');

    // TextElement
    final textStyle = chartsTextStyle.TextStyle();
    textStyle.color = textColor;
    textStyle.fontSize = 12;
    final textElement = chartsTextElement.TextElement(value, style: textStyle);

    final textW = textElement.measurement.horizontalSliceWidth;
    final textH = textElement.measurement.verticalSliceWidth;

    // Bubble
    const triangleH = 5;
    const bubbleH = 28;
    final bubbleW = max(textW, 60);
    const bubbleRadius = 6;//bubbleH / 2.0;

    final x = bounds.left - bubbleW/2 + 5;
    final y = bounds.top - bubbleH - triangleH;

    canvas.drawRRect(
      Rectangle(x, y, bubbleW, bubbleH),
      fill: bgColor,
      radius: bubbleRadius,
      roundTopLeft: true,
      roundBottomLeft: true,
      roundBottomRight: true,
      roundTopRight: true
    );

    // Triangle
    final triangleTop = y + bubbleH;
    final centerX = (bounds.left + bounds.right) / 2;
    canvas.drawPolygon(
      points: [
        Point(centerX - 4, triangleTop),
        Point(centerX + 4, triangleTop),
        Point(centerX, triangleTop + triangleH),
      ],
      fill: getSolidFillColor(bgColor),
      stroke: strokeColor,
      strokeWidthPx: getSolidStrokeWidthPx(strokeWidthPx)
    );

    // Text
    var textBoundsTop = (y + (bubbleH - textH)/2).round();
    var textBoundsLeft = ((x + (bubbleW - textW) / 2)).round();
    canvas.drawText(textElement, textBoundsLeft, textBoundsTop);
  }
}
