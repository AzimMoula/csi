/*import 'package:flutter/lib/global/colors.dart';*/
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

class CustomColors extends StatelessWidget {
  const CustomColors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        //debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.purple,
          brightness: Brightness.light,
          colorScheme: lightDynamic,
          useMaterial3: true,
        ),

        darkTheme: ThemeData(
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.dark,
          //0xFF11ASAC,0xFFE1966D,0xFF0078D4
          colorScheme: darkDynamic,
          useMaterial3: true,
        ),
      );
    });
  }
}
