import 'dart:developer';
import 'dart:io';


import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

import '../windowtitlebar.dart';

class CustomTitleBar extends StatelessWidget {
  const CustomTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: DragToMoveArea(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 5),
                      child: FlutterLogo(),
                    ),
                    Text(
                      "Abou",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3, right: 5),
                  child: Button(
                    child: Text("Caisse"),
                    onPressed: () {
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 3, right: 5),
                  child: Button(
                    child: Text("Sauvegarder"),
                    onPressed: null,
                  ),
                )
              ],
            ),
          ),
          WindowButtons()
        ],
      ),
    );
  }
}
