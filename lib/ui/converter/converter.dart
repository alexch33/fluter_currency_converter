import 'package:currency_converter/models/currency/currency.dart';
import 'package:currency_converter/stores/currency/currency_store.dart';
import 'package:currency_converter/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  TextEditingController _editingController = TextEditingController();
  FocusNode _focus = new FocusNode();

  //stores:---------------------------------------------------------------------
  late CurrencyStore _currencyStore;
  bool isInited = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void didChangeDependencies() {
    if (!isInited) {
      _currencyStore = Provider.of<CurrencyStore>(context);

      isInited = true;
    }
    _editingController.text = _currencyStore.quantity.toString();
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
        String? toValue = _currencyStore.selectedTo.id;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate('from'),
                    style: TextStyle(fontSize: 18),
                  ),
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
            ),
            Expanded(
              child: TextField(
                controller: _editingController,
                focusNode: _focus,
                onChanged: (String value) {
                  double val = double.tryParse(value) ?? 0.0;
                  _currencyStore.quantity = val;
                  _currencyStore.convertVal();
                },
                decoration: new InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate('currency_volume')),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(AppLocalizations.of(context)!.translate('to'),
                      style: TextStyle(fontSize: 18)),
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
            ),
            Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    "${_currencyStore.toValueCurr} ${_currencyStore.selectedTo.currencySymbol}",
                    style: TextStyle(fontSize: 24),
                  ),
                ))
          ],
        );
      }),
    );
  }

  void _onFocusChange() {
    if (_focus.hasFocus && _editingController.text == '0.0') {
      _editingController.text = '';
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }
}
