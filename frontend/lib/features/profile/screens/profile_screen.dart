import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: ref.watch(profileProvider).when(
        loading: () => const Center(
            child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
            child: Text(e.toString()),
        ),
        data: (user) {
            final upiController = TextEditingController(
                text: user.upiId ?? "",
            );

            return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Center(
                    child: CircleAvatar(
                        radius: 45,
                        child: Text(
                        user.fullName[0],
                        style: const TextStyle(fontSize: 30),
                        ),
                    ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                    user.fullName,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                    ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                    user.email,
                    style: const TextStyle(
                        color: Colors.grey,
                    ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                    "UPI ID",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                    ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                    controller: upiController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "example@oksbi",
                    ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                            await ref
                                .read(profileControllerProvider)
                                .updateUpiId(
                                    upiController.text.trim(),
                                );

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                content: Text(
                                    "UPI ID updated successfully",
                                ),
                                ),
                            );
                            },
                        child: const Text("Save"),
                    ),
                    ),
                ],
                ),
            );
          },
      ),
    );
  }
}