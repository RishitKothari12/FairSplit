import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/group_member_controller.dart';

class GroupInfoScreen extends ConsumerWidget {
  final String groupId;
  final String groupName;

  const GroupInfoScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(groupMembersProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
      ),
      body: members.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
        data: (memberList) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                groupName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "${memberList.length} Members",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              ...memberList.map(
                (member) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        member.fullName[0].toUpperCase(),
                      ),
                    ),
                    title: Text(member.fullName),
                    subtitle: Text(member.email),
                    trailing: Chip(
                      label: Text(
                        member.role.toUpperCase(),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Next Sprint
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text("Add Member"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}