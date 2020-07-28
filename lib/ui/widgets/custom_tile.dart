import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final Text title;
  final Icon icon;
  final Text subtitle;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  const CustomTile({
    Key key,
    @required this.leading,
    this.trailing,
    @required this.title,
    this.icon,
    @required this.subtitle,
    this.margin = const EdgeInsets.all(0.0),
    this.mini = true,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: margin,
        padding: EdgeInsets.symmetric(
          horizontal: mini ? 10.0 : 0.0,
        ),
        child: Row(
          children: <Widget>[
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: mini ? 10 : 15,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: mini ? 3 : 20,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.black12,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    title,
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        icon ?? Container(),

                      ],
                    ),
                    subtitle,
                    trailing ?? Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
