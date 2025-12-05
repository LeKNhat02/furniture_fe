import 'dart:async';

import 'package:furniture_fe/screens/home.dart';

import '../../provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../models/order_model.dart';

OrderProvider provider = OrderProvider();

class ResultOrder extends StatefulWidget {
  const ResultOrder({super.key, required this.order, required this.listCart});
  final OrderModel order;
  final List<Cart> listCart;

  @override
  State<ResultOrder> createState() => _ResultOrderState();
}

class _ResultOrderState extends State<ResultOrder> {
  int i = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<OrderProvider>(context);

    print(widget.order.fullName);

    if (i == 0) {
      setState(() {
        provider.createOrder(widget.order).then((value) {
          Timer(const Duration(milliseconds: 1000), () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          });
        });
        i += 1;
      });
    }

    // Order creation handled by createOrder above
    return Scaffold(
      backgroundColor: const Color(0xfff2f9fe),
      body: SafeArea(
        child: Center(
          child: Column(
            children: const [
              SizedBox(
                height: 200,
              ),
              Image(image: AssetImage("assets/icons/success.png")),
              SizedBox(
                height: 10,
              ),
              Text('Order Successfully' , style: TextStyle(
                fontSize: 18
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
