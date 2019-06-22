import 'dart:convert';

import 'package:http/http.dart' as http;

import 'constants.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  String selectedCurrency = 'USD';

  Map<String, double> prices = {'BTC': 0, 'ETH': 0, 'LTC': 0};

  Future<Map<String, double>> fetchData() async {
    Map<String, double> currentPrices = {};

    for (String crypto in cryptoList) {
      http.Response data = await http.get(
        '$kApiUrl/indices/global/ticker/$crypto$selectedCurrency',
        headers: {
          '$kApiKeyHeader': kApiKey,
        },
      );

      var json = jsonDecode(data.body);
      currentPrices[crypto] = json['last'];
    }

    return currentPrices;
  }
}
