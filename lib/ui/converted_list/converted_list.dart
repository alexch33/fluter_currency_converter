import 'package:currency_converter/stores/currency/currency_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ConvertertedListScreen extends StatefulWidget {
  @override
  _ConvertertedListScreenState createState() => _ConvertertedListScreenState();
}

class _ConvertertedListScreenState extends State<ConvertertedListScreen> {
  //stores:---------------------------------------------------------------------
  late CurrencyStore _currencyStore;
  bool isInited = false;

  @override
  void didChangeDependencies() {
    if (!isInited) {
      _currencyStore = Provider.of<CurrencyStore>(context);
      isInited = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Observer(
      builder: (context) => ListView(
        children: _currencyStore.converted.entries
            .map((e) => Card(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${e.key.currencyName}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${e.value} ${e.key.currencySymbol}'),
                    )
                  ],
                )))
            .toList(),
      ),
    ));
  }
}
