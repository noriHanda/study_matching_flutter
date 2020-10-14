String validateEmpty(value) {
  if (value.isEmpty) {
    return '文字を一文字以上入力してください。';
  } else {
    return null;
  }
}

String validateEmail(String value) {
  final result = validateEmpty(value);
  if (result != null) {
    return result;
  }
  if (value.contains('hokudai.ac.jp')) {
    return null;
  } else {
    return 'hokudai.ac.jp で終わるアドレスを利用してください。';
  }
}
