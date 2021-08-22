// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'models.dart';

Future<void> generateBoletin() async {
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Add page to the PDF
  final PdfPage page = document.pages.add();
  final PdfPage page2 = document.pages.add();
  //Get page client size
  final Size pageSize = page.getClientSize();
  final Size pageSize2 = page2.getClientSize();
  //Draw rectangle
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(PdfColor(142, 170, 219, 255)));
  page2.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize2.width, pageSize2.height),
      pen: PdfPen(PdfColor(142, 170, 219, 255)));
  //Generate PDF grid.
  final PdfGrid grid = getGrid();
  final PdfGrid grid1 = getGrid1();
  final PdfGrid grid2 = getGrid2();
  //Draw the header section by creating text element
  final PdfLayoutResult result =
      await drawHeader(page, pageSize, grid, 'principal');
  final PdfLayoutResult result2 =
      await drawHeader(page2, pageSize, grid, 'principal');
  //Draw grid
  drawGrid(page, grid, result);
  drawGrid(page2, grid, result2);
  //Draw grid
  drawGrid1(page, grid1, result);
  drawGrid1(page2, grid1, result2);
  //Draw grid
  double inicio = 75;
  double step = 87;
  // Page1
  drawGrid2(page, grid2, result, inicio + (step * 0));
  drawGrid2(page, grid2, result, inicio + (step * 1));
  drawGrid2(page, grid2, result, inicio + (step * 2));
  drawGrid2(page, grid2, result, inicio + (step * 3));
  drawGrid2(page, grid2, result, inicio + (step * 4));
  drawGrid2(page, grid2, result, inicio + (step * 5));
  drawGrid2(page, grid2, result, inicio + (step * 6));
  // Page2
  drawGrid2(page2, grid2, result2, inicio + (step * 0));
  drawGrid2(page2, grid2, result2, inicio + (step * 1));
  drawGrid2(page2, grid2, result2, inicio + (step * 2));
  //Add invoice footer
  // // drawFooter(page, pageSize);
  //Save the PDF document
  final List<int> bytes = document.save();
  //Dispose the document.
  document.dispose();
  //Save and launch the file.
  // await FileSaveHelper.saveAndLaunchFile(bytes, 'Invoice.pdf');
  Uint8List data = Uint8List.fromList(bytes);
  MimeType type = MimeType.PDF;
  String? val = await FileSaver.instance.saveFile(
    'Boletin',
    data,
    "pdf",
    mimeType: type,
  );
  print(val);
}

Future<void> generateBoletin2(Resumen datos) async {
  // Create a PDF document.
  final PdfDocument document = PdfDocument();
  // Cargo la lista de estudiantes
  List<Estudiante> lista = estudiantes
      .where((e) => (e.grupo == datos.asignacion![0].grupo))
      .toList();
  lista.sort((a, b) {
    return a.miPromedio().compareTo(b.miPromedio());
  });
  // Crea los boletines individuales
  for (var i = 0; i < lista.length; i++) {
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    print(['Tamaño - width', pageSize.width, 'height', pageSize.height]);
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
    //Generate PDF grid.
    final PdfGrid grid = getGrid0(i, lista[i]);
    final PdfGrid grid1 = getGrid1();
    //Draw the header section by creating text element
    final PdfLayoutResult result =
        await drawHeader(page, pageSize, grid, lista[0].sede!);
    //Draw grid
    drawGrid(page, grid, result);
    //Draw grid
    drawGrid1(page, grid1, result);
    //Draw grid
    double inicio = 75;
    double step = 87 / 5; // 87
    // Page1
    // drawGrid2(page, grid2, result, inicio + (step * 0));
    // print(['Estudiante', lista[i].toJson()]);
    for (var j = 0; j < lista[i].misCalificacionesFinales().length; j++) {
      Calificacion cal = lista[i].misCalificacionesFinales()[j];
      final PdfGrid grid2 = getGrid02(cal);
      double salto = (cal.logros!.isEmpty)
          ? (((step * 5) * (cal.logros!.length + 1)) * j)
          : ((step * (cal.logros!.length + 1)) * j);
      drawGrid2(page, grid2, result, inicio + salto);
    }
  }
  // //Add invoice footer
  // // // drawFooter(page, pageSize);
  //Save the PDF document
  final List<int> bytes = document.save();
  //Dispose the document.
  document.dispose();
  //Save and launch the file.
  // await FileSaveHelper.saveAndLaunchFile(bytes, 'Invoice.pdf');
  Uint8List data = Uint8List.fromList(bytes);
  MimeType type = MimeType.PDF;
  String? val = await FileSaver.instance.saveFile(
    'Boletines - ' + datos.asignacion![0].grupo,
    data,
    "pdf",
    mimeType: type,
  );
  print(val);
}

Future<void> generateBoletin3(Resumen datos) async {
  // Create a PDF document.
  PdfDocument document = PdfDocument();
  // Cargo la lista de estudiantes
  List<Estudiante> lista = estudiantes
      .where((e) => (e.grupo == datos.asignacion![0].grupo))
      .toList();
  lista.sort((a, b) {
    return a.miPromedio().compareTo(b.miPromedio());
  });
  // Crea los boletines individuales
  for (var i = 0; i < lista.length; i++) {
    int p = 0;
    // double pageHeight = 0;
    var rta = await drawPage(document, lista, i, p);
    PdfPage page = rta[0];
    PdfLayoutResult result = rta[1];
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw grid
    double pageHeight = 60;
    double step = 87 / 1; // 5
    int conta = 0;
    // Page1
    // drawGrid2(page, grid2, result, inicio + (step * 0));
    // print(['Estudiante', lista[i].toJson()]);
    List<Calificacion> listax = lista[i].misCalificacionesFinales();
    listax.sort((a, b) {
      return a.area.toLowerCase().compareTo(b.area.toLowerCase());
    });
    for (var j = 0; j < listax.length; j++) {
      Calificacion cal = listax[j];
      if (cal.periodo == dropdownPeriodo) {
        final PdfGrid grid2 = getGrid02(cal);
        // double salto = (step * conta);
        double salto = (cal.logros!.isEmpty) ? 18 : ((step * conta) - 7);
        if (j == 0) pageHeight += salto;
        if ((i == 0)) {
          print(['area', cal.area, cal.logros!.length, salto, pageHeight]);
        }
        if ((pageHeight * 0.4) > pageSize.height) {
          //Add page to the PDF
          pageHeight = 75;
          step = 87;
          conta = 0;
          salto = (step * conta);
          var rta = await drawPage(document, lista, i, p);
          page = rta[0];
          result = rta[1];
        }
        // print([
        //   j,
        //   lista[i].apellidos! + ' ' + lista[i].nombres!,
        //   salto,
        //   pageHeight
        // ]);
        drawGrid2(page, grid2, result, pageHeight);
        // pageHeight = (cal.logros!.length == 0)
        //     ? pageHeight
        //     : (pageHeight + (cal.logros!.length * 22.15));
        pageHeight += salto;
        step = pageHeight;
        conta += 1;
      }
    }
  }
  // //Add invoice footer
  // // // drawFooter(page, pageSize);
  //Save the PDF document
  final List<int> bytes = document.save();
  //Dispose the document.
  document.dispose();
  //Save and launch the file.
  // await FileSaveHelper.saveAndLaunchFile(bytes, 'Invoice.pdf');
  Uint8List data = Uint8List.fromList(bytes);
  MimeType type = MimeType.PDF;
  String? val = await FileSaver.instance.saveFile(
    'Boletines - ' + datos.asignacion![0].grupo,
    data,
    "pdf",
    mimeType: type,
  );
  print(val);
}

Future<List> drawPage(
    PdfDocument document, List<Estudiante> lista, int i, int p) async {
  //Add page to the PDF
  final PdfPage page = document.pages.add();
  //Get page client size
  final Size pageSize = page.getClientSize();
  // print(['Tamaño - width', pageSize.width, 'height', pageSize.height]);
  //Draw rectangle
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(PdfColor(142, 170, 219, 255)));
  //Generate PDF grid.
  final PdfGrid grid = getGrid0(i, lista[i]);
  final PdfGrid grid1 = getGrid1();
  //Draw the header section by creating text element
  final PdfLayoutResult result =
      await drawHeader(page, pageSize, grid, lista[0].sede!);
  //Draw grid
  drawGrid(page, grid, result);
  //Draw grid
  drawGrid1(page, grid1, result);
  return [page, result];
}

//Draws the invoice header
Future<PdfLayoutResult> drawHeader(
    PdfPage page, Size pageSize, PdfGrid grid, String sede) async {
  //Draw rectangle
  page.graphics.drawRectangle(
    // brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
    bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 100),
  );
  //Draw string
  page.graphics.drawString(
    'I. ETNO. RURAL INTERNADO INDIGENA\nNAZARETH',
    PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 60),
    format: PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.middle,
      alignment: PdfTextAlignment.center,
    ),
  );
  //Draw string
  page.graphics.drawString(
    ('sede ' + sede).toUpperCase(),
    PdfStandardFont(PdfFontFamily.helvetica, 9),
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 100),
    format: PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.middle,
      alignment: PdfTextAlignment.center,
    ),
  );
  //Draw string
  page.graphics.drawString(
    'INFORME DE EVALUACIÓN',
    PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 120),
    format: PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.middle,
      alignment: PdfTextAlignment.center,
    ),
  );
  //Draw string
  page.graphics.drawString(
    'Informe: PERIODO ' + dropdownPeriodo.toString(),
    PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(15, 0, pageSize.width - 30, 160),
    format: PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.middle,
      alignment: PdfTextAlignment.left,
    ),
  );
  //Draw string
  page.graphics.drawString(
    'Año lectivo: 2021',
    PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(0, 0, pageSize.width - 60, 160),
    format: PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.middle,
      alignment: PdfTextAlignment.center,
    ),
  );
  //Draw string
  page.graphics.drawString(
    DateTime.now().toLocal().toString(),
    PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(0, 0, pageSize.width - 90, 160),
    format: PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.middle,
      alignment: PdfTextAlignment.right,
    ),
  );

  page.graphics.drawRectangle(
    bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
    // brush: PdfSolidBrush(
    //   PdfColor(65, 104, 205),
    // ),
  );
  page.graphics.drawImage(PdfBitmap(await _readImageData('logox400.png')),
      Rect.fromLTWH(430, 0, pageSize.width - 430, 85));
  // PdfBitmap(await _readImageData('Pdf_Succinctly_img_1.jpg')

  // page.graphics.drawString(r'$' + getTotalAmount(grid).toString(),
  //     PdfStandardFont(PdfFontFamily.helvetica, 18),
  //     bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
  //     brush: PdfBrushes.black,
  //     format: PdfStringFormat(
  //         alignment: PdfTextAlignment.center,
  //         lineAlignment: PdfVerticalAlignment.middle));

  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
  //Draw string
  // page.graphics.drawString('Amount - Sta', contentFont,
  //     brush: PdfBrushes.black,
  //     bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
  //     format: PdfStringFormat(
  //         alignment: PdfTextAlignment.center,
  //         lineAlignment: PdfVerticalAlignment.bottom));
  //Create data foramt and convert it to text.
  // final DateFormat format = DateFormat.yMMMMd('en_US');
  // final String invoiceNumber = 'Invoice Number: 2058557939\r\n\r\nDate: ' +
  //     format.format(DateTime.now());
  // final Size contentSize = contentFont.measureString(invoiceNumber);
  // // ignore: leading_newlines_in_multiline_strings
  // const String address = '''Bill To: \r\n\r\nAbraham Swearegin,
  //       \r\n\r\nUnited States, California, San Mateo,
  //       \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136''';

  // PdfTextElement(text: invoiceNumber, font: contentFont).draw(
  //     page: page,
  //     bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
  //         contentSize.width + 30, pageSize.height - 120));

  return PdfTextElement(font: contentFont).draw(
    page: page,
    bounds: Rect.fromLTWH(30, 60, pageSize.width - (30), pageSize.height - 60),
  )!;
}

//Draws the grid
void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
    } else if (args.cellIndex == grid.columns.count - 2) {}
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

  //Draw grand total.
  // page.graphics.drawString('Grand Total',
  //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
  //     bounds: Rect.fromLTWH(quantityCellBounds!.left, result.bounds.bottom + 10,
  //         quantityCellBounds!.width, quantityCellBounds!.height));
  // page.graphics.drawString(getTotalAmount(grid).toString(),
  //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
  //     bounds: Rect.fromLTWH(
  //         totalPriceCellBounds!.left,
  //         result.bounds.bottom + 10,
  //         totalPriceCellBounds!.width,
  //         totalPriceCellBounds!.height));
}

//Draws the grid
void drawGrid1(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
    } else if (args.cellIndex == grid.columns.count - 2) {}
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 61.5, 0, 0))!;

  //Draw grand total.
  // page.graphics.drawString('Grand Total',
  //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
  //     bounds: Rect.fromLTWH(quantityCellBounds!.left, result.bounds.bottom + 10,
  //         quantityCellBounds!.width, quantityCellBounds!.height));
  // page.graphics.drawString(getTotalAmount(grid).toString(),
  //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
  //     bounds: Rect.fromLTWH(
  //         totalPriceCellBounds!.left,
  //         result.bounds.bottom + 10,
  //         totalPriceCellBounds!.width,
  //         totalPriceCellBounds!.height));
}

//Draws the grid
void drawGrid2(PdfPage page, PdfGrid grid, PdfLayoutResult result, double pos) {
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
    } else if (args.cellIndex == grid.columns.count - 2) {}
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + pos, 0, 0))!;
}

//Draw the invoice footer data.
void drawFooter(PdfPage page, Size pageSize) {
  final PdfPen linePen =
      PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
  linePen.dashPattern = <double>[3, 3];
  //Draw line
  page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
      Offset(pageSize.width, pageSize.height - 100));

  const String footerContent =
      // ignore: leading_newlines_in_multiline_strings
      '''800 Interchange Blvd.\r\n\r\nSuite 2501, Austin,
         TX 78721\r\n\r\nAny Questions? support@adventure-works.com''';

  //Added 30 as a margin for the layout
  page.graphics.drawString(
      footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
}

//Create PDF grid and return
PdfGrid getGrid() {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Codigo: 000';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.left;
  headerRow.cells[1].value = 'STANLEY MARCOS ILLIDGE ARAUJO';
  headerRow.cells[2].value = 'Grupo: 3H';
  headerRow.cells[3].value = 'Puesto 1';
  //Add rows
  // addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
  // addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
  // addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
  // addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
  // addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
  // addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  grid.columns[0].width = 80;
  grid.columns[1].width = 340;
  grid.columns[2].width = 50;
  grid.columns[3].width = 50;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

//Create PDF grid and return
PdfGrid getGrid0(int puesto, Estudiante est) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Codigo: 000';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.left;
  headerRow.cells[1].value = est.apellidos! + ' ' + est.nombres!;
  headerRow.cells[2].value = 'Grupo: ' + est.grupo!;
  headerRow.cells[3].value = 'Puesto ' + (puesto + 1).toString();
  //Add rows
  // addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
  // addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
  // addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
  // addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
  // addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
  // addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  grid.columns[0].width = 80;
  grid.columns[1].width = 340;
  grid.columns[2].width = 50;
  grid.columns[3].width = 50;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

//Create PDF grid and return
PdfGrid getGrid1() {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Asignatura';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Escala Valorativa';
  headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[2].value = 'Inasistencias';
  headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.right;
  //Add rows
  // addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
  // addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
  // addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
  // addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
  // addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
  // addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  grid.columns[0].width = 100;
  grid.columns[1].width = 300;
  grid.columns[2].width = 100;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 1.5, left: 1.5, right: 1.5, top: 1.5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

//Create PDF grid and return
PdfGrid getGrid02(Calificacion cal) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = cal.area;
  // headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  var desempeno = (cal.nota <= 5 && cal.nota >= 4.6)
      ? 'Desempeño Superior'
      : (cal.nota <= 4.5 && cal.nota >= 4)
          ? 'Desempeño Alto'
          : (cal.nota <= 3.9 && cal.nota >= 3.5)
              ? 'Desempeño Basico'
              : 'Desempeño Bajo';
  headerRow.cells[1].value = cal.nota.toString() + ' ' + desempeno;
  // print(['logros', cal.logros!]);
  //Add rows
  for (var k = 0; k < cal.logros!.length; k++) {
    if (cal.nota >= 3) {
      addProducts2('Fortaleza:', cal.logros![k], grid);
    } else {
      addProducts2('Debilidad:', cal.logros![k], grid);
    }
  }
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  grid.columns[0].width = 200;
  grid.columns[1].width = 200;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 2, left: 2, right: 2, top: 2);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.left;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 1.5, left: 1.5, right: 1.5, top: 1.5);
    }
  }
  return grid;
}

//Create PDF grid and return
PdfGrid getGrid2() {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  // headerRow.style = PdfGridRowStyle(
  //     // backgroundBrush: PdfBrushes.lightGoldenrodYellow,
  //     // textPen: PdfPens.indianRed,
  //     textBrush: PdfBrushes.white,
  //     font: PdfStandardFont(
  //       PdfFontFamily.helvetica, 8,
  //       // style: PdfFontStyle.bold,
  //     ));
  headerRow.cells[0].value = 'Asignatura';
  // headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Escala Valorativa';
  //Add rows
  addProducts2('Fortaleza:', 'AWC Logo Cap', grid);
  addProducts2('Fortaleza:', 'Long-Sleeve Logo Jersey,M', grid);
  addProducts2('Fortaleza:', 'Mountain Bike Socks,M', grid);
  addProducts2('Fortaleza:', 'Long-Sleeve Logo Jersey,M', grid);
  addProducts2('Observaciones:', 'ML Fork', grid);
  // addProducts2('HL-U509', 'Sports-100 Helmet,Black', grid);
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  grid.columns[0].width = 100;
  grid.columns[1].width = 250;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 2, left: 2, right: 2, top: 2);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.left;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 1.5, left: 1.5, right: 1.5, top: 1.5);
    }
  }
  return grid;
}

//Create PDF grid and return
PdfGrid getGrid3() {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Product Id';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Product Name';
  headerRow.cells[2].value = 'Price';
  headerRow.cells[3].value = 'Quantity';
  headerRow.cells[4].value = 'Total';
  //Add rows
  addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
  addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
  addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
  addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
  addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
  addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  grid.columns[1].width = 200;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

//Create and row for the grid.
void addProducts(String productId, String productName, double price,
    int quantity, double total, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  row.cells[0].value = productId;
  row.cells[1].value = productName;
  row.cells[2].value = price.toString();
  row.cells[3].value = quantity.toString();
  row.cells[4].value = total.toString();
}

//Create and row for the grid.
void addProducts2(String productId, String productName, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  row.cells[0].value = productId;
  row.cells[1].value = productName;
}

//Get the total amount.
double getTotalAmount(PdfGrid grid) {
  double total = 0;
  for (int i = 0; i < grid.rows.count; i++) {
    final String value =
        grid.rows[i].cells[grid.columns.count - 1].value as String;
    total += double.parse(value);
  }
  return total;
}

Future<List<int>> _readImageData(String name) async {
  final ByteData data = await rootBundle.load('assets/images/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
