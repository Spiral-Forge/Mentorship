import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return Container(
      color:themeFlag ? Colors.black54 : Colors.white,
      child:Center(
        child:SpinKitChasingDots(
          color:AppColors.COLOR_TEAL_LIGHT,
          size:50.0,
        )
      )
    );
  }
}