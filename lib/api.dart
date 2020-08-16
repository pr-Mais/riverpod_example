import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class QRCode extends ChangeNotifier {
  bool transparent;
  String type;
  String url;
  String imageURL;
  QRCode({
    this.transparent = false,
    this.type = "png",
    this.url = "",
    this.imageURL,
  });

  void setTransparent() {
    transparent = !transparent;
    notifyListeners();
  }

  void setType(type) {
    this.type = type;
    notifyListeners();
  }

  void setUrl(url) {
    this.url = url;
    notifyListeners();
  }

  setImage(url) {
    this.imageURL = url;
    notifyListeners();
  }
}

class API {
  static final host = "https://qrtag.net/api/qr";
  static Future getEndpoint(code) async {
    print('dfdfg');
    final transparent = code.transparent ? "_transparent" : "";
    String url = "https://www.${code.url}";
    print(url);
    final endpoint =
        "$host" + "$transparent" + ".${code.type}" + "?url=$url ";
    final endpointData = await http.get(endpoint);
    if (endpointData.statusCode == 200) code.setImage(endpoint);
  }
}

final qrProvider = ChangeNotifierProvider((_) => QRCode());
