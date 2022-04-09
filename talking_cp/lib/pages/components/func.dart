import 'package:flutter/material.dart';

isPortrait({required BuildContext context}) {
  return MediaQuery.of(context).size.width <
      MediaQuery.of(context).size.height * 1.3;
}
