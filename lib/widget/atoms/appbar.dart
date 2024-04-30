import 'package:flutter/material.dart';
import 'package:todo_planner/theme/colors.dart';

class AppBarAtom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAtom({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: tdBgColor,
        elevation: 0,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Icon(Icons.menu, color: tdBlack, size: 30),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset("lib/assets/avatar.webp")),
          )
        ]));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
