import 'package:flutter/material.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';

class NeuBox extends StatelessWidget {

  final Widget? child;
  
  const NeuBox({
    super.key, this.child
  
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 15,
            offset: const Offset(4, 4),
          ),
  
          BoxShadow(
            color: Colors.deepPurple,
            blurRadius: 15,
            offset: const Offset(4, 4)
          )
        ]

      ),
      padding: const EdgeInsets.all(12),
    child: child,
    );
  }
}