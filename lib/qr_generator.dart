import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({Key key}) : super(key: key);

  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate a QR from URL')),
      body: Consumer((context, watch) {
        final qr = watch(qrProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 30),
              title: Text("Transparent"),
              value: qr.transparent,
              onChanged: (value) {
                print(value);
                qrProvider.read(context).setTransparent();
              },
            ),
            Divider(),
            SectionTitle(title: "Image Type"),
            RadioListTile(
                title: Text("PNG"),
                value: "png",
                groupValue: qr.type,
                onChanged: (value) {
                  qr.setType(value);
                }),
            RadioListTile(
                title: Text("SVG"),
                value: "svg",
                groupValue: qr.type,
                onChanged: (value) {
                  qr.setType(value);
                }),
            Divider(),
            SectionTitle(title: "URL"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                onChanged: (value) => qr.setUrl(value),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.link),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: RaisedButton(
                onPressed: qr.url.isEmpty ? null : () => API.getEndpoint(qr),
                child: Text("Generate QR"),
              ),
            ),
            if (qr.imageURL != null)
              Center(
                child: Image.network(qr.imageURL),
              )
          ],
        );
      }),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        "$title",
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
