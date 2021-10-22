import 'package:another_flushbar/flushbar_helper.dart';
import 'package:currency_converter/stores/currency/currency_store.dart';
import 'package:currency_converter/ui/converted_list/converted_list.dart';
import 'package:currency_converter/ui/converter/converter.dart';
import 'package:currency_converter/utils/locale/app_localization.dart';
import 'package:currency_converter/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  int _page = 0;
  late CurrencyStore _currencyStore;
  bool isInited = false;

  final List<Widget> _pages = <Widget>[
    ConverterScreen(),
    ConvertertedListScreen()
  ];

  @override
  void didChangeDependencies() {
    if (!isInited) {
      _currencyStore = Provider.of<CurrencyStore>(context);
      _currencyStore.initialize();
      isInited = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (context) => Text(
              '${AppLocalizations.of(context)!.translate('currency_converter')}   ${_currencyStore.selectedFrom.currencySymbol}'),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: (int index) {
          setState(() {
            _page = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              label: AppLocalizations.of(context)!.translate('converter'),
              icon: Icon(Icons.swap_vert_circle)),
          BottomNavigationBarItem(
              label: AppLocalizations.of(context)!.translate('curriencies'),
              icon: Icon(Icons.swap_horiz))
        ],
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildContent(),
        ),
        Observer(
            builder: (context) => _currencyStore.isLoading
                ? Center(child: CustomProgressIndicatorWidget())
                : SizedBox.shrink())
      ],
    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_currencyStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_currencyStore.errorStore.errorMessage);
        }
        return SizedBox.shrink();
      },
    );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context)!.translate('home_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  Widget buildContent() {
    return _pages.elementAt(_page);
  }
}
