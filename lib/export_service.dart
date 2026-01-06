import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExportService {
  static Future<void> exportPasswordsToPdf(List<QueryDocumentSnapshot> docs) async {
    final pdf = pw.Document();

    // PDF İçeriğini oluşturuyoruz
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Vaulty - Sifre Yedekleme Raporu", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Baslik', 'Sifre'],
                data: docs.map((doc) => [doc['title'].toString(), doc['password'].toString()]).toList(),
              ),
            ],
          );
        },
      ),
    );

    // Dosyayı geçici hafızaya kaydet ve paylaşım penceresini aç
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/vaulty_yedek.pdf");
    await file.writeAsBytes(await pdf.save());

    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], text: 'Vaulty Şifre Yedeği');
  }
}