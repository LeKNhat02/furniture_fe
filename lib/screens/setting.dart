import 'package:flutter/material.dart';
import 'package:furniture_fe/screens/login.dart';
import 'package:furniture_fe/screens/order.dart';
import 'package:furniture_fe/screens/test.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import 'cart.dart';
import 'favorite.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

UserProvider userProvider = UserProvider();

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Stack(
      children: [
        Image.asset(
          "assets/images/background_setting.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        GlassmorphicContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            borderRadius: 0,
            linearGradient: LinearGradient(colors: [
              Colors.white.withOpacity(0),
              Colors.white.withOpacity(0)
            ]),
            border: 0,
            blur: 50,
            borderGradient: LinearGradient(colors: [
              Colors.white.withOpacity(0),
              Colors.white.withOpacity(0)
            ])),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(35)),
                          child: (userProvider.currentUser?.img ?? '').isNotEmpty
                              ? FadeInImage(
                                  fit: BoxFit.fill,
                                  placeholder:
                                      const AssetImage('assets/icons/user.png'),
                                  image: NetworkImage(
                                      userProvider.currentUser?.img ?? ''),
                                )
                              : const Image(
                                  image: AssetImage('assets/icons/user.png')),
                        ),
                      ),
                      Text(
                        userProvider.currentUser?.fullName ?? 'Guest',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  getRowDirect(Icons.account_circle_outlined, 'Hồ sơ'),
                  const SizedBox(
                    height: 10,
                  ),
                  getRowDirect(Icons.favorite_border_outlined, 'Yêu thích'),
                  const SizedBox(
                    height: 10,
                  ),
                  getRowDirect(Icons.shopping_cart_outlined, 'Giỏ hàng'),
                  const SizedBox(
                    height: 10,
                  ),
                  getRowDirect(Icons.receipt_long_sharp, 'Đơn hàng'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                  getRowDirect(Icons.power_settings_new_outlined, 'Đăng xuất')
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getRowDirect(IconData icon, String text) {
    return ElevatedButton(
      onPressed: () {
        if(text == "Hồ sơ") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
        }
        else if(text == "Yêu thích") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePage()));
        }
        else if(text == "Giỏ hàng") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
        }
        else if(text == "Đơn hàng") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderPage()));
        }
        else if(text == "Đăng xuất") {

          showDialog(
              context: context,
              builder: (_) {
                return Dialog(
                  // The background color
                  backgroundColor: const Color(0xff560f20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(height: 20,),
                        CircularProgressIndicator(color: Color(0xffecd8e0),),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                );
              }
          );

          userProvider.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(10),

      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
