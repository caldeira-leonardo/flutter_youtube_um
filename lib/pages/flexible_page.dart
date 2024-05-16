import 'package:flutter/material.dart';

class FlexiblePage extends StatelessWidget {
  const FlexiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espaçamento Flexível'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 19,
              child: Image.asset('../../images/space/image1.jpg'),
            ),
            const Spacer(
              flex: 1,
            ),
            Flexible(
              flex: 19,
              child: Image.asset('../../images/space/image2.webp'),
            ),
            const Spacer(
              flex: 1,
            ),
            Flexible(
              flex: 19,
              child: Image.asset('../../images/space/image3.jpg'),
            ),
            const Spacer(
              flex: 1,
            ),
            Flexible(
              flex: 19,
              child: Image.asset('../../images/space/image4.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}
