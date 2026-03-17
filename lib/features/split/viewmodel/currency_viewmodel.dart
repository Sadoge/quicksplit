import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Currency {
  usd('\$', 'USD'),
  eur('€', 'EUR'),
  gbp('£', 'GBP'),
  jpy('¥', 'JPY'),
  cad('CA\$', 'CAD'),
  aud('A\$', 'AUD'),
  chf('CHF', 'CHF'),
  inr('₹', 'INR'),
  krw('₩', 'KRW'),
  brl('R\$', 'BRL'),
  mxn('MX\$', 'MXN'),
  sek('kr', 'SEK');

  final String symbol;
  final String code;
  const Currency(this.symbol, this.code);
}

const _prefsKey = 'selected_currency';

class CurrencyViewmodel extends AsyncNotifier<Currency> {
  @override
  Future<Currency> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null) {
      return Currency.values.firstWhere(
        (c) => c.code == saved,
        orElse: () => Currency.usd,
      );
    }
    return Currency.usd;
  }

  Future<void> setCurrency(Currency currency) async {
    state = AsyncData(currency);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, currency.code);
  }
}

final currencyProvider =
    AsyncNotifierProvider<CurrencyViewmodel, Currency>(CurrencyViewmodel.new);
