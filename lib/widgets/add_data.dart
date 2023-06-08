import 'package:flutter/material.dart';
import '../widgets/textfield_decoration.dart';
// import '../services/storage_service.dart';
import '../models/storage_item.dart';

class AddDataDialog extends StatelessWidget {
  AddDataDialog({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  // final StorageService _storageService = StorageService();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _keyController,
                decoration: textFieldDecoration(hintText: "Enter Email"),
              ),
              TextFormField(
                controller: _valueController,
                decoration: textFieldDecoration(hintText: "Enter Number"),
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        final StorageItem storageItem = StorageItem(
                            _keyController.text, _valueController.text);
                        Navigator.of(context).pop(storageItem);
                      },
                      child: const Text('Secure')))
            ],
          ),
        ),
      ),
    );
  }
}
