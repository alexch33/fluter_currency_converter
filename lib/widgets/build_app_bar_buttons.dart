import 'package:currency_converter/stores/theme/theme_store.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

Widget buildThemeButton(BuildContext context, ThemeStore themeStore) {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {
            themeStore.changeBrightnessToDark(!themeStore.darkMode);
          },
          icon: Icon(
            themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
          ),
        );
      },
    );
  }
