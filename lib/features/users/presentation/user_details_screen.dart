import 'package:flutter/material.dart';
import 'package:users_app/features/users/data/user_model.dart';

class UserDetailsScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailsScreen({
    super.key,
    required this.user,
  });

  static const bg = Color(0xFFF5F7FF);
  static const primary = Color(0xFF2E6AE6);

  String fakePhone(int id) {
    
    final base = 1000000 + (id * 9137);
    final s = base.toString().padLeft(7, '0');
    return '+962 7${s.substring(0, 2)} ${s.substring(2, 5)} ${s.substring(5, 7)}';
  }

  @override
  Widget build(BuildContext context) {
    final phone = fakePhone(user.id);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'User Details',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          child: Column(
            children: [
              _AvatarWithHalo(
                imageUrl: user.avatar,
                haloColor: primary,
                size: 124,
              ),
              const SizedBox(height: 14),
              Text(
                user.fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2430),
                ),
              ),
              const SizedBox(height: 18),

              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                      color: Colors.black.withValues(alpha: 0.06),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.email_rounded,
                      iconColor: primary,
                      text: user.email,
                    ),
                    const Divider(height: 6),
                    _InfoRow(
                      icon: Icons.phone_rounded,
                      iconColor: const Color(0xFF24A55A),
                      text: phone,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarWithHalo extends StatelessWidget {
  final String imageUrl;
  final Color haloColor;
  final double size;

  const _AvatarWithHalo({
    required this.imageUrl,
    required this.haloColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final outer = size + 18; 

    return SizedBox(
      width: outer,
      height: outer,
      child: Stack(
        alignment: Alignment.center,
        children: [
         
          Container(
            width: outer,
            height: outer,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: haloColor.withValues(alpha: 0.10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 26,
                  spreadRadius: 2,
                  color: haloColor.withValues(alpha: 0.18),
                ),
              ],
            ),
          ),

          
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                onError: (_,__) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2B3140),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
