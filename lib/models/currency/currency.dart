class Currency {
  final String currencyName;
  final String? currencySymbol;
  final String id;

  Currency(
      {this.currencyName = 'no name', this.currencySymbol, this.id = 'no id'});

  factory Currency.fromMap(Map<String, dynamic> json) => Currency(
      currencyName: json['currencyName'],
      currencySymbol: json['currencySymbol'],
      id: json['id']);

  Map<String, dynamic> toMap() => {
        'currencyName': currencyName,
        'currencySymbol': currencySymbol,
        'id': id
      };

  String toString() {
    return '$currencyName $currencySymbol $id';
  }

  bool operator ==(o) => o is Currency && id == o.id;
  int get hashCode => id.hashCode;

  static final Currency defaultCurrency = Currency(
      currencyName: "United States Dollar", currencySymbol: '\$', id: 'USD');
}
