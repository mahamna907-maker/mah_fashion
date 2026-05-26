import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/app_provider.dart';
import '../widgets/mah_logo.dart';
import 'login_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditDialog(BuildContext context, AppProvider provider) {
    final nameCtrl = TextEditingController(text: provider.displayName);
    final emailCtrl = TextEditingController(text: provider.userEmail);
    final phoneCtrl = TextEditingController(text: provider.phone);
    bool saving = false;

    InputDecoration dec(String label) => InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        );

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Edit Profile',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: dec('Full Name')),
              const SizedBox(height: 12),
              TextField(
                  controller: emailCtrl,
                  decoration: dec('Email'),
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              TextField(
                  controller: phoneCtrl,
                  decoration: dec('Phone'),
                  keyboardType: TextInputType.phone),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textGrey)),
            ),
            ElevatedButton(
              onPressed: saving
                  ? null
                  : () async {
                      setState(() => saving = true);
                      final error = await provider.updateProfile(
                        nameCtrl.text,
                        emailCtrl.text,
                        phoneCtrl.text,
                      );
                      if (!ctx.mounted) return;
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              error ?? 'Profile updated successfully'),
                          backgroundColor:
                              error == null ? AppColors.green : Colors.red,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out?',
            style: TextStyle(color: AppColors.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final name = provider.displayName;
    final email = provider.userEmail;
    final wishlistCount = provider.wishlist.length;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'M';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Pink gradient header background
            Container(
              height: 260,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFE5EE), Color(0xFFFFCCE0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 24, bottom: 32),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 28),

                          // Avatar
                          Stack(
                            children: [
                              Container(
                                width: 108,
                                height: 108,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xFFFF889B),
                                      width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFFB3C6)
                                          .withOpacity(0.24),
                                      blurRadius: 24,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: name.isNotEmpty
                                      ? Text(initial,
                                          style: const TextStyle(
                                              fontSize: 42,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary))
                                      : const ClipOval(
                                          child: SizedBox(
                                              width: 88,
                                              height: 88,
                                              child: MahLogo(size: 72))),
                                ),
                              ),
                              // Edit button
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () =>
                                      _showEditDialog(context, provider),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Name & email
                          Text(
                            name.isNotEmpty ? name : 'User',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email.isNotEmpty ? email : '',
                            style: const TextStyle(
                                color: AppColors.textGrey, fontSize: 13),
                          ),
                          const SizedBox(height: 12),

                          // Premium badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFD63366), Color(0xFFFF6B9D)],
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text('Premium Member',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 22),

                          // Stats row
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F4F8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: _stat(
                                        '$wishlistCount', 'Wishlist')),
                                _vDivider(),
                                Expanded(
                                    child: _stat('4.9', 'Rating')),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Menu tiles
                          const Divider(
                              height: 1, color: Color(0xFFF0F0F3)),
                          _tile(
                            Icons.shopping_bag_outlined,
                            'My Orders',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const OrderHistoryScreen()),
                            ),
                          ),
                          const Divider(
                              height: 1, color: Color(0xFFF0F0F3)),
                          _tile(
                            Icons.person_outline_rounded,
                            'Edit Profile',
                            () => _showEditDialog(context, provider),
                          ),
                          const Divider(
                              height: 1, color: Color(0xFFF0F0F3)),
                          _tile(
                            Icons.favorite_border_rounded,
                            'My Wishlist (${provider.wishlist.length})',
                            () {},
                          ),
                          const Divider(
                              height: 1, color: Color(0xFFF0F0F3)),
                          _tile(
                            Icons.settings_outlined,
                            'Settings',
                            () {},
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign out button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmLogout(context, provider),
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Sign Out',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Color(0xFFD63366)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        foregroundColor: const Color(0xFFD63366),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1, height: 44, color: const Color(0xFFE9E1E8));

  Widget _stat(String value, String label) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(label,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textGrey)),
        ],
      );

  Widget _tile(IconData icon, String label, VoidCallback onTap) =>
      ListTile(
        leading: Icon(icon, color: AppColors.textGrey, size: 22),
        title: Text(label,
            style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.textLight),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      );
}