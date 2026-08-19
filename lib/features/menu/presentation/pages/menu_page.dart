import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/core/di/injection_container.dart';
import 'package:restaurant_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:restaurant_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:restaurant_app/features/cart/presentation/pages/cart_page.dart';
import 'package:restaurant_app/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:restaurant_app/features/menu/presentation/pages/item_detail_page.dart';
import 'package:restaurant_app/features/menu/presentation/widgets/category_chip.dart';
import 'package:restaurant_app/features/menu/presentation/widgets/menu_item_card.dart';
import 'package:restaurant_app/features/orders/presentation/pages/my_orders_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentNavIndex = 0;
  bool _isOfferFilterActive = false;
  bool _isUploadingPic = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ImageProvider _getUserAvatarImage(String? profilePic) {
    if (profilePic != null && profilePic.isNotEmpty) {
      if (profilePic.startsWith('http://') || profilePic.startsWith('https://')) {
        return NetworkImage(profilePic);
      }
      final file = File(profilePic);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    return const NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200');
  }

  Future<void> _pickAndUpdateProfilePic(BuildContext context, ImageSource source) async {
    const primaryOrange = Color(0xFFD35400);
    final authBloc = context.read<AuthBloc>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: 70);

      if (pickedFile != null) {
        final authState = authBloc.state;
        if (authState is AuthAuthenticated) {
          if (mounted) setState(() => _isUploadingPic = true);

          authBloc.add(UpdateProfilePicRequested(
            uid: authState.user.uid,
            imagePath: pickedFile.path,
          ));

          messenger.showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully.'),
              backgroundColor: primaryOrange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Could not pick image: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploadingPic = false);
      }
    }
  }

  void _showImagePickerModal(BuildContext context) {
    const secondaryOrange = Color(0xFFE67E22);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    showModalBottomSheet(
      context: context,
      backgroundColor: darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Change Profile Picture',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: creamText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select a new photo for your account profile.',
              style: TextStyle(fontSize: 13, color: creamText.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 20),

            Material(
              color: Colors.transparent,
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                leading: const Icon(Icons.photo_library_rounded, color: secondaryOrange),
                title: const Text('Choose from Gallery', style: TextStyle(color: creamText, fontWeight: FontWeight.bold)),
                subtitle: Text('Select an image from your device', style: TextStyle(color: creamText.withValues(alpha: 0.6), fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUpdateProfilePic(context, ImageSource.gallery);
                },
              ),
            ),
            const SizedBox(height: 8),
            Material(
              color: Colors.transparent,
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                leading: const Icon(Icons.camera_alt_rounded, color: secondaryOrange),
                title: const Text('Take a New Photo', style: TextStyle(color: creamText, fontWeight: FontWeight.bold)),
                subtitle: Text('Capture a picture with your camera', style: TextStyle(color: creamText.withValues(alpha: 0.6), fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUpdateProfilePic(context, ImageSource.camera);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfferClaimedDialog(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryOrange.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_fire_department_rounded, color: secondaryOrange, size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                '30% OFF Special Deal! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: creamText,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Use promo code FOODIE30 today to get 30% off your entire order!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: creamText.withValues(alpha: 0.8), height: 1.4),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: secondaryOrange.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.confirmation_number_outlined, color: secondaryOrange, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'FOODIE30',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: secondaryOrange,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: creamText,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => _isOfferFilterActive = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('⚡ Filtered to Special Offers items!'),
                        backgroundColor: primaryOrange,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Claim Deal & View Offers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAllOffersSheet(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    showModalBottomSheet(
      context: context,
      backgroundColor: darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Exclusive Daily Offers 🔥',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: creamText,
                    ),
                  ),
                  Icon(Icons.local_offer_rounded, color: secondaryOrange),
                ],
              ),
              const SizedBox(height: 16),
              _buildOfferTile('30% OFF Chef Kebabs', 'Use code FOODIE30 on all grilled specials', secondaryOrange),
              _buildOfferTile('Free Iced Matcha', 'On all orders above \$25.00 today', primaryOrange),
              _buildOfferTile('Buy 1 Get 1 Ramen', 'Available every Tuesday & Thursday', const Color(0xFF2ECC71)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: creamText,
                    side: const BorderSide(color: secondaryOrange),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close Deals', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfferTile(String title, String desc, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: accentColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFDF5E6))),
                Text(desc, style: TextStyle(fontSize: 12, color: const Color(0xFFFDF5E6).withValues(alpha: 0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);
    const neutralBackground = Color(0xFF1A1614);

    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final email = user?.email ?? fb.FirebaseAuth.instance.currentUser?.email ?? 'user@foodiego.com';
    final name = user?.name ?? 'FoodieGo Customer';
    final profilePic = user?.profilePic;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () => _showImagePickerModal(context),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: secondaryOrange, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: secondaryOrange.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _getUserAvatarImage(profilePic),
                      child: _isUploadingPic
                          ? const CircularProgressIndicator(color: primaryOrange)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryOrange,
                        shape: BoxShape.circle,
                        border: Border.all(color: neutralBackground, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 18,
                        color: creamText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap picture to update profile photo',
            style: TextStyle(fontSize: 12, color: secondaryOrange.withValues(alpha: 0.9), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: creamText),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(color: creamText.withValues(alpha: 0.6), fontSize: 14),
          ),
          const SizedBox(height: 28),

          Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: darkSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt_outlined, color: secondaryOrange),
                    title: const Text('Update Profile Picture', style: TextStyle(color: creamText, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => _showImagePickerModal(context),
                  ),
                  const Divider(height: 1, color: Colors.white12),
                  ListTile(
                    leading: const Icon(Icons.receipt_long_rounded, color: secondaryOrange),
                    title: const Text('My Orders', style: TextStyle(color: creamText, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => setState(() => _currentNavIndex = 1),
                  ),
                  const Divider(height: 1, color: Colors.white12),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_rounded, color: secondaryOrange),
                    title: const Text('Shopping Cart', style: TextStyle(color: creamText, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => setState(() => _currentNavIndex = 2),
                  ),
                  const Divider(height: 1, color: Colors.white12),
                  ListTile(
                    leading: const Icon(Icons.local_offer_rounded, color: secondaryOrange),
                    title: const Text('My Promo Codes', style: TextStyle(color: creamText, fontWeight: FontWeight.w500)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: primaryOrange, borderRadius: BorderRadius.circular(6)),
                      child: const Text('1 Active', style: TextStyle(color: creamText, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    onTap: () => _showAllOffersSheet(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              label: const Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              onPressed: () => context.read<AuthBloc>().add(const LogoutRequested()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const neutralBackground = Color(0xFF1A1614);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthAuthenticated ? authState.user : null;

    return BlocProvider(
      create: (_) => sl<MenuBloc>()..add(const LoadMenu()),
      child: Scaffold(
        backgroundColor: neutralBackground,
        drawer: Drawer(
          backgroundColor: darkSurface,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryOrange, secondaryOrange],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'FoodieGo 👋',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: creamText,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Satisfy your cravings',
                      style: TextStyle(color: creamText, fontSize: 13),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.restaurant_menu, color: secondaryOrange),
                title: const Text('Home / Menu', style: TextStyle(color: creamText)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _currentNavIndex = 0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long, color: secondaryOrange),
                title: const Text('My Orders', style: TextStyle(color: creamText)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _currentNavIndex = 1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag, color: secondaryOrange),
                title: const Text('Cart', style: TextStyle(color: creamText)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _currentNavIndex = 2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: secondaryOrange),
                title: const Text('Profile', style: TextStyle(color: creamText)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _currentNavIndex = 3);
                },
              ),
              const Divider(color: Colors.white12),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthBloc>().add(const LogoutRequested());
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: neutralBackground,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: creamText, size: 24),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Foodie',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryOrange,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Go',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: secondaryOrange,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () => setState(() => _currentNavIndex = 3),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: secondaryOrange.withValues(alpha: 0.6), width: 1.5),
                    image: DecorationImage(
                      image: _getUserAvatarImage(currentUser?.profilePic),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Body based on active bottom navigation tab index
        body: IndexedStack(
          index: _currentNavIndex,
          children: [
            // Tab 0: Home / Menu Page
            BlocBuilder<MenuBloc, MenuState>(
              builder: (context, state) {
                if (state is MenuLoading || state is MenuInitial) {
                  return const Center(child: CircularProgressIndicator(color: primaryOrange));
                }
                if (state is MenuError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: creamText)));
                }
                final loaded = state as MenuLoaded;

                var filteredItems = loaded.items.where((item) {
                  if (_searchQuery.isEmpty) return true;
                  return item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      item.description.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                if (_isOfferFilterActive) {
                  filteredItems = filteredItems.take(3).toList();
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: darkSurface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: creamText, fontSize: 14),
                            onChanged: (val) => setState(() => _searchQuery = val.trim()),
                            decoration: InputDecoration(
                              hintText: 'Search delicious meals...',
                              hintStyle: TextStyle(
                                color: creamText.withValues(alpha: 0.45),
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: creamText.withValues(alpha: 0.5),
                                size: 20,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, color: creamText, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Category Filters Row
                      CategoryChipRow(
                        categories: loaded.categories,
                        selectedCategoryId: loaded.selectedCategoryId,
                        onSelected: (id) {
                          setState(() => _isOfferFilterActive = false);
                          context.read<MenuBloc>().add(FilterByCategory(id));
                        },
                      ),
                      const SizedBox(height: 24),

                      // Playful Special Offers Section Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Special Offers',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: creamText,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                if (_isOfferFilterActive) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => setState(() => _isOfferFilterActive = false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: primaryOrange,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text('Filtered ✕', style: TextStyle(fontSize: 11, color: creamText, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            // Playful "see all" button with ripple & action sheet trigger
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: secondaryOrange,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              ),
                              onPressed: () => _showAllOffersSheet(context),
                              icon: const Icon(Icons.local_offer_rounded, size: 16),
                              label: const Text(
                                'see all',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Playful Special Offers Banner Card with Tap Claim Event
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            onTap: () => _showOfferClaimedDialog(context),
                            borderRadius: BorderRadius.circular(18),
                            splashColor: primaryOrange.withValues(alpha: 0.3),
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: secondaryOrange.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryOrange.withValues(alpha: 0.25),
                                    blurRadius: 14,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(
                                        'assets/images/offer_banner.png',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: darkSurface,
                                          child: const Icon(Icons.fastfood, size: 60, color: primaryOrange),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.black.withValues(alpha: 0.85),
                                              Colors.black.withValues(alpha: 0.45),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                '30%',
                                                style: TextStyle(
                                                  fontSize: 38,
                                                  fontWeight: FontWeight.w900,
                                                  color: creamText,
                                                  height: 1.0,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Discount\nOnly valid\nToday',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: creamText,
                                                  height: 1.25,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: secondaryOrange,
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: const [
                                                Text('Tap Deal', style: TextStyle(color: creamText, fontWeight: FontWeight.bold, fontSize: 12)),
                                                SizedBox(width: 4),
                                                Icon(Icons.touch_app_rounded, color: creamText, size: 16),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Menu Items List Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: filteredItems.isEmpty
                            ? Container(
                                padding: const EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.restaurant, size: 56, color: secondaryOrange),
                                      const SizedBox(height: 12),
                                      Text(
                                        _searchQuery.isNotEmpty
                                            ? 'No items matching "$_searchQuery".'
                                            : 'No items in this category.',
                                        style: TextStyle(color: creamText.withValues(alpha: 0.7)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = filteredItems[index];
                                  return MenuItemCard(
                                    item: item,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ItemDetailPage(item: item),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),

            // Tab 1: Orders Tab
            const MyOrdersPage(),

            // Tab 2: Cart Tab
            const CartPage(),

            // Tab 3: Profile Tab
            _buildProfileTab(context),
          ],
        ),

        // Persistent 100% working Bottom Navigation Bar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: darkSurface,
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_rounded, 'Home', primaryOrange, secondaryOrange, creamText),
                  _buildNavItem(1, Icons.receipt_long_rounded, 'Orders', primaryOrange, secondaryOrange, creamText),
                  _buildNavItem(2, Icons.shopping_bag_rounded, 'Cart', primaryOrange, secondaryOrange, creamText, isCart: true),
                  _buildNavItem(3, Icons.person_rounded, 'Profile', primaryOrange, secondaryOrange, creamText),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color primaryOrange, Color secondaryOrange, Color creamText, {bool isCart = false}) {
    final isSelected = _currentNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _currentNavIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3D251A) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(builder: (context) {
              final cartState = context.watch<CartBloc>().state;
              final cartCount = (isCart && cartState is CartLoaded)
                  ? cartState.items.fold<int>(0, (sum, i) => sum + i.quantity)
                  : 0;

              return Badge(
                label: Text('$cartCount'),
                isLabelVisible: isCart && cartCount > 0,
                backgroundColor: primaryOrange,
                textColor: creamText,
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected ? secondaryOrange : creamText.withValues(alpha: 0.5),
                ),
              );
            }),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: secondaryOrange,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
