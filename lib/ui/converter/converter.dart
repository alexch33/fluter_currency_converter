import 'package:currency_converter/models/currency/currency.dart';
import 'package:currency_converter/stores/currency/currency_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController textFromController = TextEditingController();

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
      body: Observer(builder: (context) {
        List<Currency> itemsFrom = _currencyStore.currencies;
        List<Currency> itemsTo = _currencyStore.currencies
            .where((element) => element.id != _currencyStore.selectedFrom.id)
            .toList();
        String? toValue = itemsTo.indexOf(_currencyStore.selectedTo) < 0
            ? null
            : _currencyStore.selectedTo.id;
        if (itemsTo.isNotEmpty && toValue == null) {
          toValue = itemsTo.first.id;
        }
        double toValueCurr = 0.0;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('From'),
                DropdownButton<String>(
                  value: _currencyStore.selectedFrom.id,
                  isDense: true,
                  onChanged: (String? newValue) {
                    _currencyStore.setSelectedFromById(newValue);
                  },
                  items: itemsFrom.map((Currency value) {
                    return DropdownMenuItem(
                      value: value.id,
                      child: Text(value.id),
                    );
                  }).toList(),
                )
              ],
            ),
            TextField(
              controller: textFromController,
              decoration:
                  new InputDecoration(labelText: "Enter your number from"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('To'),
                itemsTo.isNotEmpty
                    ? DropdownButton<String>(
                        value: toValue,
                        isDense: true,
                        onChanged: (String? newValue) {
                          _currencyStore.setSelectedToById(newValue);
                        },
                        items: itemsTo.map((Currency value) {
                          return DropdownMenuItem(
                            value: value.id,
                            child: Text(value.id),
                          );
                        }).toList(),
                      )
                    : Container()
              ],
            ),
            Expanded(
                child: Center(
              child: Text(
                  "$toValueCurr ${_currencyStore.selectedTo.currencySymbol}"),
            ))
          ],
        );
      }),
    );
  }
}
