import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';


import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Create PDF'),
          onPressed: _createPDF,
        ),
      ),
    );
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    ///RectAngle

    document.pages[0].annotations.add(PdfRectangleAnnotation(
        Rect.fromLTWH(50, 0, 420, 750), 'Rectangle',
        color: PdfColor(0,0, 0), setAppearance: true));

    ///Image


    page.graphics.drawImage(
        PdfBitmap(await _readImageData('image.png',)),
        Rect.fromLTWH(150, -40,0 , 0));


    ///Text

    page.graphics.drawString('Invoice Number #',
        PdfStandardFont(
            PdfFontFamily.helvetica,
            16,style:PdfFontStyle.bold  ),
      bounds: Rect.fromLTWH(120, 65, 150, 400),

    );

    page.graphics.drawString('1200303030',
      PdfStandardFont(
          PdfFontFamily.helvetica,
          16,style:PdfFontStyle.bold  ),
      bounds: Rect.fromLTWH(270, 65, 300, 400),

    );


    ///Text

    page.graphics.drawString('Date:',
      PdfStandardFont(
          PdfFontFamily.helvetica,
          16,style:PdfFontStyle.bold  ),
      bounds: Rect.fromLTWH(200, 80, 150, 400),

    );

    page.graphics.drawString('12/30/3030',
      PdfStandardFont(
          PdfFontFamily.helvetica,
          16,style:PdfFontStyle.bold  ),
      bounds: Rect.fromLTWH(270, 80, 300, 400),

    );





    document.pages[0].annotations.add(PdfRectangleAnnotation(
        Rect.fromLTWH(60, 110, 400, 0), 'SquareAnnotation',
        color: PdfColor(0,0, 0), setAppearance: true));



    // PdfGrid grid = PdfGrid();
    // grid.style = PdfGridStyle(
    //     font: PdfStandardFont(PdfFontFamily.helvetica, 30),
    //     cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));
    //
    // grid.columns.add(count: 3);
    // grid.headers.add(1);
    //
    //
    //
    //
    // PdfGridRow header = grid.headers[0];
    // header.cells[0].value = 'Roll No';
    // header.cells[1].value = 'Name';
    // header.cells[2].value = 'Class';
    //
    //
    //
    //
    // PdfGridRow row = grid.rows.add();
    // row.cells[0].value = '1';
    // row.cells[1].value = 'Arya';
    // row.cells[2].value = '6';
    //
    // row = grid.rows.add();
    // row.cells[0].value = '2';
    // row.cells[1].value = 'John';
    // row.cells[2].value = '9';
    //
    // row = grid.rows.add();
    // row.cells[0].value = '3';
    // row.cells[1].value = 'Tony';
    // row.cells[2].value = '8';






    //
    //
    //
    // grid.draw(
    //     page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));







    List<int> bytes =await document.save();
    document.dispose();

     saveAndLaunchFile(  bytes, 'Output.pdf');
  }
}

Future<Uint8List> _readImageData(String name) async {


  final data = await rootBundle.load('assets/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}


Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {

  final path = (await getExternalStorageDirectory())!.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes( bytes, flush: true);
  OpenFile.open('$path/$fileName');
}