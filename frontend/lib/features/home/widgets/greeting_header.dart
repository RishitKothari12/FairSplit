import 'package:flutter/material.dart';
import '../../profile/screens/profile_screen.dart';

class GreetingHeader extends StatelessWidget {
  final String name;

  const GreetingHeader({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;

    String greeting;

    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 17) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "$greeting,",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
          },
          child: const CircleAvatar(
            radius: 22,
            child: Icon(Icons.person),
          ),
        ),
      ],
    );
  }
}