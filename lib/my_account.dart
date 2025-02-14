import 'package:damh/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_scaffold.dart';


class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  Future<void> _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.orange,
      ),
    );
    // Navigate directly to the LoginScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error signing out: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.black),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'QB',
                        style: TextStyle(fontSize: 22, color: Colors.orange),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'trinhquocbao27092003@gmail.com',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      )
                    ],
                  ),
                ),
              ),
              Image.asset(
                'images/shoelogo.jpg',
                height: 150,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'My account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const ListofOption(
                icon: Icon(
                  Icons.person_2_outlined,
                  color: Colors.orange,
                ),
                title: 'Home',
              ),
              const ListofOption(
                icon: Icon(
                  Icons.location_city_outlined,
                  color: Colors.orange,
                ),
                title: 'Addresses',
              ),
              const ListofOption(
                icon: Icon(
                  Icons.payment_outlined,
                  color: Colors.orange,
                ),
                title: 'Payment',
              ),
              const ListofOption(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.orange,
                ),
                title: 'Orders',
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const ListofOption(
                icon: Icon(
                  Icons.language_outlined,
                  color: Colors.orange,
                ),
                title: 'Language',
              ),
              ListofOption(
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.orange,
                ),
                title: 'Sign Out',
                onTap: () => _signOut(context),
              ),
            ],
          ),
        ),
      ),
      showBottomNavBar: true,
      initialIndex: 2,
    );
  }
}

class ListofOption extends StatelessWidget {
  final Icon icon;
  final String title;
  final VoidCallback? onTap;

  const ListofOption({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
      onTap: onTap,
    );
  }
}
