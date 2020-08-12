import 'package:dbapp/constants/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:AppColors.PROTEGE_CYAN,
      child:Center(
        child:SpinKitChasingDots(
          color:AppColors.COLOR_TEAL_LIGHT,
          size:50.0,
        )
      )
    );
  }
}