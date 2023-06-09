import 'package:flutter/material.dart';
import 'package:task_application/widgets/alert_dialog.dart';
import '../widgets/textfield_decoration.dart';
import '../services/storage_service.dart';
import '../models/storage_item.dart';
import 'package:email_validator/email_validator.dart';
import 'package:custom_alert_dialog_box/custom_alert_dialog_box.dart';

class AddDataDialog extends StatelessWidget {
  AddDataDialog({Key? key}) : super(key: key);

  String _errorMessage = "";
  String _errorPhoneMessage = "";
  String? _value;

  // final StorageService _storageService = StorageService();
  final TextEditingController _keyController = TextEditingController();

  final TextEditingController _valueController = TextEditingController();
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _keyController,
              onChanged: (value) => validateEmail(value),
              decoration: textFieldDecoration(hintText: "Enter Email"),
            ),
            TextFormField(
              controller: _valueController,
              decoration: textFieldDecoration(hintText: "Enter Number"),
              keyboardType: TextInputType.number,
              onChanged: (value) => validateNumber(value),
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_errorMessage.isNotEmpty) {
                        await CustomAlertDialogBox.showCustomAlertBox(
                          context: context,
                          willDisplayWidget: Text(_errorMessage),
                        );
                        return;
                      } else if (_errorPhoneMessage.isNotEmpty) {
                        await CustomAlertDialogBox.showCustomAlertBox(
                          context: context,
                          willDisplayWidget: Text(_errorPhoneMessage),
                        );
                        return;
                      } else if (_keyController.text == "") {
                        await CustomAlertDialogBox.showCustomAlertBox(
                          context: context,
                          willDisplayWidget:
                              const Text('Please Input Email Address'),
                        );
                        return;
                      } else if (_valueController.text == "") {
                        await CustomAlertDialogBox.showCustomAlertBox(
                          context: context,
                          willDisplayWidget:
                              const Text('Please Input Phone Number'),
                        );
                        return;
                      } else {
                        _value = await _storageService
                            .readSecureData(_keyController.text);
                        if (_value != null || _value == _valueController.text) {
                          // ignore: use_build_context_synchronously
                          await CustomAlertDialogBox.showCustomAlertBox(
                            context: context,
                            willDisplayWidget:
                                const Text('Email is Already Exist'),
                          );
                          return;
                        }
                      }

                      final StorageItem storageItem = StorageItem(
                          _keyController.text, _valueController.text);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop(storageItem);
                    },
                    child: const Text('Submit')))
          ],
        ),
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      _errorMessage = "Email can not be empty";
    } else if (!EmailValidator.validate(val, true)) {
      _errorMessage = "Invalid Email Address";
    } else {
      _errorMessage = "";
    }
  }

  void validateNumber(String val) {
    if (val.isEmpty) {
      _errorPhoneMessage = "Number can not be empty";
    } else if (val.length != 10) {
      _errorPhoneMessage = "Invalid Phone Number";
    } else if (!RegExp(
            r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
        .hasMatch(val)) {
      _errorPhoneMessage = "Please Enter a Valid Number";
    } else {
      _errorPhoneMessage = "";
    }
  }
}
