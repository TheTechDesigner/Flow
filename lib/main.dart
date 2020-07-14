import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFC41A3B),
        primaryColorLight: Color(0xFFFBE0E6),
        accentColor: Color(0xFF1B1F32),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String title = 'Flow Class';

  AnimationController _menuAnimation;

  IconData _endTapped = Icons.notifications;

  final List<IconData> _menuItems = <IconData>[
    Icons.person,
    Icons.shopping_cart,
    Icons.search,
    Icons.category,
    Icons.menu,
  ];

  void _updateMenu(IconData icon) {
    if (icon != Icons.menu)
      setState(() {
        _endTapped = icon;
      });
  }

  @override
  void initState() {
    super.initState();
    _menuAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  Widget _flowMenuItem(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
      child: RawMaterialButton(
        fillColor: _endTapped == icon ? Color(0xFF1B1F32) : Color(0xFFC41A3B),
        splashColor: Colors.black54,
        shape: CircleBorder(),
        constraints: BoxConstraints.tight(Size(66.0, 66.0)),
        onPressed: () {
          _updateMenu(icon);
          _menuAnimation.status == AnimationStatus.completed
              ? _menuAnimation.reverse()
              : _menuAnimation.forward();
        },
        child: Icon(
          icon,
          size: 40.0,
          color: Color(0xFFFBE0E6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Flow(
        delegate: FlowMenuDelegate(menuAnimation: _menuAnimation),
        children: _menuItems
            .map<Widget>((IconData icon) => _flowMenuItem(icon))
            .toList(),
      ),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({this.menuAnimation}) : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double _dx = 0.0;
    for (int i = 0; i < context.childCount; i++) {
      _dx = context.getChildSize(i).width * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          _dx * menuAnimation.value,
          0,
          0,
        ),
      );
    }
  }
}
