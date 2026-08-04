extension TitleCaseExtension on String {
  String toTitleCase() {
    if (this.isEmpty) return this;
    return this
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}

extension FirstNameExtension on String {
  String get firstName {
    if (trim().isEmpty) return '';

    final first = trim().split(RegExp(r'\s+')).first;

    return first[0].toUpperCase() + first.substring(1).toLowerCase();
  }
}
