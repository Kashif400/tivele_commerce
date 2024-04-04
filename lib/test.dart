import 'package:flutter/material.dart';
import 'package:e_commerce_foods/ui/thank_you.dart';

class Empty extends StatefulWidget {
  @override
  _EmptyState createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
//  @override
//  void initState() {
//    super.initState();
//    print('initState');
//  }

//  @override
//  void dispose() {
//    print('dispose');
//    super.dispose();
//  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    print('dispose');
    super.didChangeDependencies();
  }

//  @override
//  void deactivate() {
//    // TODO: implement deactivate
//    print('dispose');
//    super.deactivate();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (__) => ThankYou(
                ref: null,
              ),
            ),
          );
        },
      ),
    );
  }
}
