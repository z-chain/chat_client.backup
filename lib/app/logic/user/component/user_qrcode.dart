import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:styled_widget/styled_widget.dart';

import '../user.dart';

class UserQRCode extends StatefulWidget {
  final User user;

  const UserQRCode({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserQRCodeState();
}

class UserQRCodeState extends State<UserQRCode> {
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    scanner
        .generateBarCode(this.widget.user.address)
        .then((value) => this.setState(() {
              _image = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return _image != null
        ? Image.memory(
            _image!,
          ).padding(all: 16).backgroundColor(Colors.white)
        : SizedBox();
  }
}
