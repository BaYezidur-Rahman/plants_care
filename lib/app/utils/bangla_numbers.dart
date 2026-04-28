class BanglaNumbers {
  static const Map<String, String> _englishToBangla = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };

  static String toBangla(String input) {
    String output = '';
    for (int i = 0; i < input.length; i++) {
      if (_englishToBangla.containsKey(input[i])) {
        output += _englishToBangla[input[i]]!;
      } else {
        output += input[i];
      }
    }
    return output;
  }
}
