import 'package:flutter/material.dart';
import 'package:task_application/services/storage_service.dart';
import 'package:task_application/widgets/vault_card.dart';
import '../models/storage_item.dart';
import '../widgets/add_data.dart';
import '../widgets/search_key.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<StorageItem> _items;
  bool _loading = true;

  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() async {
    _items = await _storageService.readAllSecureData();
    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                () => showDialog(
                    context: context,
                    builder: (_) => const SearchKeyValueDialog());
              },
              icon: const Icon(Icons.search, color: Colors.black))
        ],
      ),
      body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : _items.isEmpty
                  ? const Text('Input email And Phone Number to display Here')
                  : ListView.builder(
                      itemCount: _items.length,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (_, index) {
                        // delete part

                        //return VaultCard(item: _items[index]);//
                        return Dismissible(
                          // 2
                          key: Key(_items[index].toString()),
                          child: VaultCard(item: _items[index]),
                          // 3
                          onDismissed: (direction) async {
                            // 4
                            await _storageService
                                .deleteSecureData(_items[index])
                                .then((value) => _items.removeAt(index));
                            // 5
                            initList();
                          },
                        );
                      })),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final StorageItem? newItem = await showDialog<StorageItem>(
                        context: context, builder: (_) => AddDataDialog());
                    if (newItem != null) {
                      _storageService.writeSecureData(newItem).then((value) {
                        setState(() {
                          _loading = true;
                        });
                        initList();
                      });
                    }
                  },
                  child: const Text("Add Data"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent),
                  onPressed: () async {
                    _storageService
                        .deleteAllSecureData()
                        .then((value) => initList());
                  },
                  child: const Text("Delete All Data"),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
