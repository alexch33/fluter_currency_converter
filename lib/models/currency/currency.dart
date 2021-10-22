class Currency {
  final String currencyName;
  final String? currencySymbol;
  final String id;

  Currency(
      {this.currencyName = 'no name',
      this.currencySymbol,
      this.id = 'no id'});

  factory Currency.fromMap(Map<String, dynamic> json) => Currency(
      currencyName: json['currencyName'],
      currencySymbol: json['currencySymbol'],
      id: json['id']);

  Map<String, dynamic> toMap() => {
        'currencyName': currencyName,
        'currencySymbol': currencySymbol,
        'id': id
      };

  static final Currency defaultCurrency = Currency(
      currencyName: "United States Dollar", currencySymbol: '\$', id: 'USD');
}
