import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final CoinData _coinData = CoinData();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final prices = await _coinData.fetchData();

    setState(() {
      _coinData.prices = prices;
    });
  }

  void selectIndex(int index) {
    _coinData.selectedCurrency = currenciesList[index];
    getData();
  }

  void updateCurrency(value) {
    _coinData.selectedCurrency = value;
    getData();
  }

  List<DropdownMenuItem<String>> getDropdownOptions() {
    List<DropdownMenuItem<String>> options = [];

    for (String currency in currenciesList) {
      options.add(DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      ));
    }

    return options;
  }

  List<Text> getCupertinoOptions() {
    return currenciesList.map((String currency) => Text(currency)).toList();
  }

  DropdownButton<String> getDropdownButton() {
    return DropdownButton<String>(
      value: _coinData.selectedCurrency,
      items: getDropdownOptions(),
      onChanged: updateCurrency,
    );
  }

  CupertinoPicker getIosPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: selectIndex,
      children: getCupertinoOptions(),
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return getIosPicker();
    }
    return getDropdownButton();
  }

  List<Widget> getPrices() {
    List<Widget> prices = [];

    for (String crypto in cryptoList) {
      prices.add(Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = ${_coinData.prices[crypto]} ${_coinData.selectedCurrency}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ));
    }

    return prices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(children: getPrices()),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
