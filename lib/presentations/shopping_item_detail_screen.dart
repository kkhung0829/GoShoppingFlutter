import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/models.dart';

class ShoppingItemDetailScreen extends StatefulWidget {
  final ShoppingItem item;
  final bool isEdit;

  ShoppingItemDetailScreen({
    Key key,
    ShoppingItem item,
  })  : this.isEdit = (item != null),
        this.item = item ?? ShoppingItem(numUnit: 1),
        super(key: key);

  @override
  _ShoppingItemDetailScreenState createState() =>
      _ShoppingItemDetailScreenState();
}

class _ShoppingItemDetailScreenState extends State<ShoppingItemDetailScreen> {
  TextEditingController _tcUnitPrice;
  String _imageFilePath;

  @override
  void initState() {
    super.initState();

    _tcUnitPrice = TextEditingController(
      text: widget.item.unitPrice.toString(),
    );
    _imageFilePath = widget.item.imageFilePath;
  }

  @override
  void dispose() {
    super.dispose();

    _tcUnitPrice.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = Center(child: widget.isEdit ? Text('Edit Shopping Item') : Text('Add Shopping Item'));

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: _tcUnitPrice,
          decoration: InputDecoration(labelText: 'Unit Price'),
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
          ),
        ),
        GestureDetector(
          child: Container(
            child: Hero(
              tag: widget.item.id,
              child: Material(
                color: Colors.transparent,
                child: (_imageFilePath != null && _imageFilePath.isNotEmpty)
                  ? Image.file(File(_imageFilePath))
                  : const Icon(Icons.camera_alt),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 8.0,
              ),
            ),
            width: 192,
            height: 192,
          ),
          onTap: () async {
            File imageFile =
                (await ImagePicker.pickImage(source: ImageSource.camera));

            setState(() {
              _imageFilePath = imageFile.path;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, null);
              },
            ),
            FlatButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.pop(
                    context,
                    widget.item
                        .copyWith(
                          unitPrice: double.parse(_tcUnitPrice.text),
                          imageFilePath: _imageFilePath));
              },
            ),
          ],
        ),
      ],
    );

    return AlertDialog(
      title: title,
      content: content,
    );
  }
}
