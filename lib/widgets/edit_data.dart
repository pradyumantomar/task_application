import 'package:flutter/material.dart';
import '../widgets/textfield_decoration.dart';
import '../services/storage_service.dart';
import '../models/storage_item.dart';
import 'package:custom_alert_dialog_box/custom_alert_dialog_box.dart';
import '../services/storage_phone_service.dart';

class EditDataDialog extends StatefulWidget {
  final StorageItem item;

  const EditDataDialog({Key? key, required this.item}) : super(key: key);

  @override
  State<EditDataDialog> createState() => _EditDataDialogState();
}

class _EditDataDialogState extends State<EditDataDialog> {
  // late TextEditingController _keyController;
  late TextEditingController _valueController;
  final StorageServicesPhone _phoneService = StorageServicesPhone();
  String? _phone;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(text: widget.item.value);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _valueController,
              decoration: textFieldDecoration(hintText: "Enter Value"),
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_valueController.text.length != 10) {
                        await CustomAlertDialogBox.showCustomAlertBox(
                          context: context,
                          willDisplayWidget:
                              const Text('Phone Number must be of 10 digits'),
                        );
                        return;
                      } else if (!RegExp(
                              r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
                          .hasMatch(_valueController.text)) {
                        await CustomAlertDialogBox.showCustomAlertBox(
                          context: context,
                          willDisplayWidget:
                              const Text('Phone Number is invalid'),
                        );
                        return;
                      } else {
                        debugPrint('INside phone check edit');
                        _phone = await _phoneService
                            .readSecureData(_valueController.text);
                        if (_phone != null || _phone == 'Yes') {
                          // ignore: use_build_context_synchronously
                          await CustomAlertDialogBox.showCustomAlertBox(
                            context: context,
                            willDisplayWidget:
                                const Text('Phone is Already Exist'),
                          );
                          return;
                        }
                      }
                      Navigator.of(context).pop(_valueController.text);
                    },
                    child: const Text('Update')))
          ],
        ),
      ),
    );
  }
}
