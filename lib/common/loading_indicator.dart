import 'package:flutter/material.dart';

loadingIndicator() {
  return Container(
    color: Colors.black.withOpacity(0.3),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
