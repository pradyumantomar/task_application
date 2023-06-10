// ignore_for_file: must_be_immutable
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:task_application/models/storage_item.dart';
import 'package:task_application/models/storage_phone_item.dart';
import '../services/storage_service.dart';
import '../widgets/edit_data.dart';
import '../services/storage_phone_service.dart';

class VaultCard extends StatefulWidget {
  VaultCard({required this.item, Key? key}) : super(key: key);
  StorageItem item;

  @override
  State<VaultCard> createState() => _VaultCardState();
}

class _VaultCardState extends State<VaultCard> {
  bool _visibility = true;
  List iconList = [Icons.audiotrack, Icons.favorite, Icons.beach_access];
  var colorList = [Colors.pink, Colors.green, Colors.blue];
  int rn = Random().nextInt(1000) % 3;

  final StorageService _storageService = StorageService();

  final StorageServicesPhone _phoneService = StorageServicesPhone();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(3, 3),
                    color: Colors.grey.shade300,
                    blurRadius: 5)
              ]),
          child: ListTile(
              onLongPress: () {
                setState(() {
                  _visibility = !_visibility;
                });
              },
              title: Text(
                '${widget.item.key}',
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              subtitle: Visibility(
                visible: _visibility,
                child: Text(
                  // '{widget.item.value}',
                  '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
              leading: Icon(iconList[rn], color: colorList[rn], size: 30),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.green.shade800,
                ),
                onPressed: () async {
                  final String updatedValue = await showDialog(
                      context: context,
                      builder: (_) => EditDataDialog(item: widget.item));
                  if (updatedValue.isNotEmpty) {
                    final StoragePhone phoneItem =
                        StoragePhone(widget.item.key, 'Yes');
                    _phoneService.writeSecureData(phoneItem.phone).catchError(
                        (onError) =>
                            debugPrint("inside vault")); //?? phone addition

                    _storageService
                        .writeSecureData(
                            StorageItem(widget.item.key, updatedValue))
                        .then((value) {
                      // 3
                      widget.item = StorageItem(widget.item.key, updatedValue);
                      setState(() {});
                    });
                  }
                },
              ))),
    );
  }
}
