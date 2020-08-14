import 'package:dbapp/constants/colors.dart';
import 'package:flutter/material.dart';

const textInputDecorations=InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF565656),
                          width:2.0
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:Colors.grey,
                          width:2.0
                        )
                      )
                  );

const headingDecoration=TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                      height: 1
);  