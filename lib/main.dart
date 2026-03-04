import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const FoodieApp());
}

// ══════════════════════════════════════════════════════════════════════════════
// APP ROOT
// ══════════════════════════════════════════════════════════════════════════════

class FoodieApp extends StatelessWidget {
  const FoodieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF4B2B)),
        scaffoldBackgroundColor: const Color(0xFFF8F5F2),
        fontFamily: 'Georgia',
      ),
      home: const WelcomePage(), // ← Auth flow starts here
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// COLORS & CONSTANTS
// ══════════════════════════════════════════════════════════════════════════════

const kPrimary      = Color(0xFFFF4B2B);
const kPrimaryLight = Color(0xFFFF7A5C);
const kPrimaryWarm  = Color(0xFFFF8C42);
const kDark         = Color(0xFF1C1C1E);
const kGrey         = Color(0xFF8E8E93);
const kLightBg      = Color(0xFFF8F5F2);
const kLightGrey    = Color(0xFFF2F2F7);
const kGold         = Color(0xFFFFB800);

// ══════════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════════════

class Restaurant {
  final String name, cuisine, time, rating, image, priceRange;
  final bool isOpen, isFeatured;
  final List<MenuItem> menu;
  const Restaurant({
    required this.name, required this.cuisine, required this.time,
    required this.rating, required this.image, required this.priceRange,
    required this.menu, this.isOpen = true, this.isFeatured = false,
  });
}

class MenuItem {
  final String name, description, price, emoji;
  final bool isPopular;
  const MenuItem({
    required this.name, required this.description,
    required this.price, required this.emoji, this.isPopular = false,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;
  CartItem({required this.item, this.quantity = 1});
}

// ══════════════════════════════════════════════════════════════════════════════
// SAMPLE DATA
// ══════════════════════════════════════════════════════════════════════════════

final sampleRestaurants = [
  Restaurant(
    name: 'Burger Palace', cuisine: 'American · Burgers', time: '20-30 min',
    rating: '4.8', image: '🍔', priceRange: '\$\$', isFeatured: true,
    menu: [
      const MenuItem(name: 'Classic Smash Burger', description: 'Double smash patty, cheddar, pickles, special sauce', price: '\$12.99', emoji: '🍔', isPopular: true),
      const MenuItem(name: 'BBQ Bacon Crunch', description: 'Crispy bacon, BBQ sauce, onion rings, jalapenos', price: '\$14.99', emoji: '🥓'),
      const MenuItem(name: 'Truffle Mushroom', description: 'Sauteed mushrooms, truffle mayo, swiss cheese', price: '\$15.99', emoji: '🍄', isPopular: true),
      const MenuItem(name: 'Crispy Chicken', description: 'Buttermilk fried chicken, coleslaw, hot honey', price: '\$13.99', emoji: '🍗'),
      const MenuItem(name: 'Loaded Fries', description: 'Cheese sauce, bacon bits, sour cream, chives', price: '\$7.99', emoji: '🍟', isPopular: true),
      const MenuItem(name: 'Chocolate Shake', description: 'Hand-spun thick milkshake, oreo crumble', price: '\$6.99', emoji: '🥤'),
    ],
  ),
  Restaurant(
    name: 'Sushi Zen', cuisine: 'Japanese · Sushi', time: '35-45 min',
    rating: '4.9', image: '🍱', priceRange: '\$\$\$',
    menu: [
      const MenuItem(name: 'Dragon Roll', description: 'Shrimp tempura, avocado, eel sauce', price: '\$16.99', emoji: '🐉', isPopular: true),
      const MenuItem(name: 'Salmon Sashimi 8pc', description: 'Premium Atlantic salmon, fresh wasabi', price: '\$18.99', emoji: '🐟', isPopular: true),
      const MenuItem(name: 'Spicy Tuna Roll', description: 'Tuna, cucumber, spicy mayo, tobiko', price: '\$13.99', emoji: '🌶️'),
      const MenuItem(name: 'Gyoza 6pc', description: 'Pan-fried pork and cabbage dumplings', price: '\$8.99', emoji: '🥟'),
      const MenuItem(name: 'Miso Soup', description: 'Tofu, wakame, green onion, dashi broth', price: '\$3.99', emoji: '🍜'),
    ],
  ),
  Restaurant(
    name: 'Pizza Roma', cuisine: 'Italian · Pizza', time: '25-35 min',
    rating: '4.7', image: '🍕', priceRange: '\$\$', isFeatured: true,
    menu: [
      const MenuItem(name: 'Margherita Classica', description: 'San Marzano tomato, fior di latte, basil', price: '\$14.99', emoji: '🍕', isPopular: true),
      const MenuItem(name: 'Diavola', description: 'Spicy salami, chilli oil, smoked mozzarella', price: '\$17.99', emoji: '🌶️'),
      const MenuItem(name: 'Quattro Formaggi', description: 'Gorgonzola, parmesan, mozzarella, taleggio', price: '\$18.99', emoji: '🧀', isPopular: true),
      const MenuItem(name: 'Tiramisu', description: 'House made, espresso soaked ladyfingers', price: '\$7.99', emoji: '☕'),
    ],
  ),
  Restaurant(
    name: 'Green Bowl', cuisine: 'Healthy · Salads', time: '15-25 min',
    rating: '4.6', image: '🥗', priceRange: '\$',
    menu: [
      const MenuItem(name: 'Power Acai Bowl', description: 'Acai, banana, granola, berries, honey', price: '\$11.99', emoji: '🫐', isPopular: true),
      const MenuItem(name: 'Quinoa Buddha Bowl', description: 'Roasted veggies, chickpeas, tahini dressing', price: '\$13.99', emoji: '🌾'),
      const MenuItem(name: 'Caesar Wrap', description: 'Grilled chicken, romaine, parmesan, croutons', price: '\$10.99', emoji: '🌯', isPopular: true),
    ],
  ),
  Restaurant(
    name: 'Taco Fiesta', cuisine: 'Mexican · Tacos', time: '20-30 min',
    rating: '4.5', image: '🌮', priceRange: '\$',
    menu: [
      const MenuItem(name: 'Al Pastor Taco 3pc', description: 'Marinated pork, pineapple, cilantro, onion', price: '\$10.99', emoji: '🌮', isPopular: true),
      const MenuItem(name: 'Guacamole and Chips', description: 'Fresh avocado, lime, tomato, jalapeno', price: '\$7.99', emoji: '🥑'),
      const MenuItem(name: 'Burrito Bowl', description: 'Rice, black beans, grilled chicken, pico, sour cream', price: '\$12.99', emoji: '🫙', isPopular: true),
    ],
  ),
];

final categories = [
  {'emoji': '🍔', 'label': 'Burgers'},
  {'emoji': '🍕', 'label': 'Pizza'},
  {'emoji': '🍱', 'label': 'Sushi'},
  {'emoji': '🥗', 'label': 'Healthy'},
  {'emoji': '🌮', 'label': 'Mexican'},
  {'emoji': '🍜', 'label': 'Noodles'},
  {'emoji': '🍗', 'label': 'Chicken'},
  {'emoji': '🧁', 'label': 'Desserts'},
];

// ══════════════════════════════════════════════════════════════════════════════
// CART STATE
// ══════════════════════════════════════════════════════════════════════════════

class CartState {
  static final List<CartItem> items = [];
  static int get totalCount => items.fold(0, (s, i) => s + i.quantity);
  static double get total => items.fold(0.0,
      (s, i) => s + (double.parse(i.item.price.replaceAll('\$', '')) * i.quantity));
  static void add(MenuItem item) {
    final e = items.where((c) => c.item.name == item.name);
    if (e.isNotEmpty) { e.first.quantity++; } else { items.add(CartItem(item: item)); }
  }
  static void remove(MenuItem item) {
    final e = items.where((c) => c.item.name == item.name);
    if (e.isNotEmpty) {
      if (e.first.quantity > 1) { e.first.quantity--; }
      else { items.removeWhere((c) => c.item.name == item.name); }
    }
  }
  static int quantityOf(MenuItem item) {
    final e = items.where((c) => c.item.name == item.name);
    return e.isNotEmpty ? e.first.quantity : 0;
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PAGE TRANSITION HELPER
// ══════════════════════════════════════════════════════════════════════════════

PageRouteBuilder _slideRoute(Widget page, {bool fromRight = true}) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) => FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(fromRight ? 1.0 : -1.0, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
    ),
    transitionDuration: const Duration(milliseconds: 450),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// 1. WELCOME / ONBOARDING PAGE  (3 animated pages)
// ══════════════════════════════════════════════════════════════════════════════

class _OnboardData {
  final String emoji, title, subtitle;
  final Color bg1, bg2;
  final List<String> floaters;
  const _OnboardData({
    required this.emoji, required this.title, required this.subtitle,
    required this.bg1, required this.bg2, required this.floaters,
  });
}

const _onboardPages = [
  _OnboardData(
    emoji: '🍔', bg1: Color(0xFFFF4B2B), bg2: Color(0xFFFF8C42),
    title: 'Order Your\nFavorite Food',
    subtitle: 'Discover hundreds of restaurants and thousands of dishes — all at your fingertips.',
    floaters: ['🌮', '🍕', '🥗', '🍜', '🧁'],
  ),
  _OnboardData(
    emoji: '🛵', bg1: Color(0xFF1C1C1E), bg2: Color(0xFF3A3A3C),
    title: 'Lightning Fast\nDelivery',
    subtitle: 'Real-time tracking so you know exactly when your food arrives at your door.',
    floaters: ['⚡', '📍', '🗺️', '🕐', '✅'],
  ),
  _OnboardData(
    emoji: '❤️', bg1: Color(0xFFFF2D55), bg2: Color(0xFFFF6B81),
    title: 'Crafted With\nLove & Care',
    subtitle: 'Every meal is prepared fresh by top-rated local restaurants just for you.',
    floaters: ['⭐', '🏆', '👨‍🍳', '🎁', '💫'],
  ),
];

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  late PageController _pageCtrl;
  late AnimationController _contentCtrl, _orbCtrl, _floatCtrl;
  late Animation<double> _contentFade, _orbRotate, _floatAnim;
  late Animation<Offset> _contentSlide;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();

    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));

    _orbCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    _orbRotate = Tween<double>(begin: 0, end: 2 * math.pi).animate(_orbCtrl);

    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -12, end: 12)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _contentCtrl.forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose(); _contentCtrl.dispose();
    _orbCtrl.dispose(); _floatCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int i) {
    _contentCtrl.reset();
    setState(() => _current = i);
    _contentCtrl.forward();
  }

  void _next() {
    if (_current < _onboardPages.length - 1) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      _toSignIn();
    }
  }

  void _toSignIn() => Navigator.pushReplacement(context, _slideRoute(const SignInPage()));

  @override
  Widget build(BuildContext context) {
    final page = _onboardPages[_current];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [page.bg1, page.bg2],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Stack(children: [

          // Rotating rings
          AnimatedBuilder(animation: _orbRotate, builder: (_, __) => Positioned(
            top: size.height * 0.06, left: size.width * 0.5 - 170,
            child: Transform.rotate(angle: _orbRotate.value,
              child: Container(width: 340, height: 340,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5)))),
          )),
          AnimatedBuilder(animation: _orbRotate, builder: (_, __) => Positioned(
            top: size.height * 0.09, left: size.width * 0.5 - 130,
            child: Transform.rotate(angle: -_orbRotate.value * 0.7,
              child: Container(width: 260, height: 260,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.12), width: 1)))),
          )),

          // Glow blobs
          Positioned(top: -60, right: -40,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07)))),
          Positioned(bottom: size.height * 0.3, left: -80,
            child: Container(width: 220, height: 220,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05)))),

          // Floating emoji cards
          ...List.generate(page.floaters.length, (i) {
            final angle = (i / page.floaters.length) * 2 * math.pi;
            final cx = size.width / 2 + math.cos(angle) * 138;
            final cy = size.height * 0.27 + math.sin(angle) * 70;
            return AnimatedBuilder(
              animation: _floatAnim,
              builder: (_, __) => Positioned(
                left: cx - 22,
                top: cy + (i.isEven ? _floatAnim.value : -_floatAnim.value),
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Center(child: Text(page.floaters[i],
                    style: const TextStyle(fontSize: 20))),
                ),
              ),
            );
          }),

          // Swipe gesture layer
          PageView.builder(
            controller: _pageCtrl, onPageChanged: _onPageChanged,
            itemCount: _onboardPages.length,
            itemBuilder: (_, __) => const SizedBox.shrink(),
          ),

          // Hero emoji (floating)
          Positioned(
            top: size.height * 0.15, left: 0, right: 0,
            child: AnimatedBuilder(
              animation: _floatAnim,
              builder: (_, __) => Transform.translate(
                offset: Offset(0, _floatAnim.value * 0.5),
                child: Center(child: Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2),
                      blurRadius: 40, offset: const Offset(0, 16))],
                  ),
                  child: Center(child: Text(page.emoji,
                    style: const TextStyle(fontSize: 54))),
                )),
              ),
            ),
          ),

          // Bottom white card
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
              ),
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
              child: SafeArea(top: false, child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dot indicators
                  Row(children: List.generate(_onboardPages.length, (i) {
                    final active = i == _current;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.only(right: 6),
                      width: active ? 28 : 8, height: 8,
                      decoration: BoxDecoration(
                        color: active ? page.bg1 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  })),

                  const SizedBox(height: 22),

                  // Title
                  FadeTransition(opacity: _contentFade,
                    child: SlideTransition(position: _contentSlide,
                      child: Text(page.title, style: const TextStyle(
                        color: kDark, fontSize: 34, fontWeight: FontWeight.w900,
                        height: 1.15, letterSpacing: -0.5)))),

                  const SizedBox(height: 12),

                  // Subtitle
                  FadeTransition(opacity: _contentFade,
                    child: SlideTransition(position: _contentSlide,
                      child: Text(page.subtitle, style: const TextStyle(
                        color: kGrey, fontSize: 15, height: 1.6)))),

                  const SizedBox(height: 32),

                  // Next / Get Started button
                  GestureDetector(
                    onTap: _next,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [page.bg1, page.bg2]),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: page.bg1.withOpacity(0.4),
                          blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          _current == _onboardPages.length - 1 ? 'Get Started' : 'Next',
                          style: const TextStyle(color: Colors.white, fontSize: 17,
                            fontWeight: FontWeight.w800, letterSpacing: 0.3)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                      ]),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(child: GestureDetector(
                    onTap: _toSignIn,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: RichText(text: TextSpan(
                        text: 'Already have an account?  ',
                        style: const TextStyle(color: kGrey, fontSize: 14),
                        children: [TextSpan(text: 'Sign In',
                          style: TextStyle(color: page.bg1, fontWeight: FontWeight.w800))],
                      )),
                    ),
                  )),

                  const SizedBox(height: 10),
                ],
              )),
            ),
          ),

          // Skip button
          if (_current < _onboardPages.length - 1)
            Positioned(top: 52, right: 20,
              child: GestureDetector(
                onTap: _toSignIn,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Text('Skip', style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              )),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 2. SIGN IN PAGE
// ══════════════════════════════════════════════════════════════════════════════

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool _obscure = true, _loading = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _signIn() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushAndRemoveUntil(context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        // Gradient header
        Positioned(top: 0, left: 0, right: 0,
          child: Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [kPrimary, kPrimaryWarm],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Stack(children: [
              Positioned(top: -30, right: -30,
                child: Container(width: 160, height: 160,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08)))),
              Positioned(bottom: 20, left: -40,
                child: Container(width: 120, height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06)))),
            ]),
          ),
        ),

        SafeArea(child: SingleChildScrollView(child: Column(children: [
          // Back button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Align(alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
                ),
              )),
          ),

          const SizedBox(height: 20),

          // Logo + text
          FadeTransition(opacity: _fade, child: Column(children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15),
                  blurRadius: 30, offset: const Offset(0, 10))],
              ),
              child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 38))),
            ),
            const SizedBox(height: 14),
            const Text('Welcome Back!', style: TextStyle(
              color: Colors.white, fontSize: 26,
              fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            const SizedBox(height: 4),
            Text('Sign in to continue ordering',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
          ])),

          const SizedBox(height: 36),

          // Form card
          FadeTransition(opacity: _fade, child: SlideTransition(position: _slide,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08),
                  blurRadius: 30, offset: const Offset(0, 10))],
              ),
              child: Column(children: [
                _AuthField(controller: _emailCtrl, label: 'Email Address',
                  hint: 'you@example.com', icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _AuthField(
                  controller: _passCtrl, label: 'Password',
                  hint: 'Enter your password', icon: Icons.lock_outline_rounded,
                  obscure: _obscure,
                  suffix: GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: kGrey, size: 20)),
                ),
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerRight,
                  child: GestureDetector(onTap: () {},
                    child: const Text('Forgot Password?', style: TextStyle(
                      color: kPrimary, fontWeight: FontWeight.w700, fontSize: 13)))),
                const SizedBox(height: 24),

                // Sign In button
                GestureDetector(
                  onTap: _loading ? null : _signIn,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [kPrimary, kPrimaryWarm]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.4),
                        blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: Center(child: _loading
                        ? const SizedBox(width: 22, height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white)))
                        : const Text('Sign In', style: TextStyle(
                      color: Colors.white, fontSize: 17,
                      fontWeight: FontWeight.w800, letterSpacing: 0.3))),
                  ),
                ),

                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or continue with',
                      style: TextStyle(color: kGrey, fontSize: 12))),
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                ]),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: _SocialButton(icon: '🌐', label: 'Google', onTap: () {})),
                  const SizedBox(width: 12),
                  Expanded(child: _SocialButton(icon: '🍎', label: 'Apple', onTap: () {})),
                ]),
              ]),
            ),
          )),

          const SizedBox(height: 28),

          FadeTransition(opacity: _fade, child: GestureDetector(
            onTap: () => Navigator.push(context, _slideRoute(const SignUpPage())),
            child: RichText(text: const TextSpan(
              text: "Don't have an account?  ",
              style: TextStyle(color: kGrey, fontSize: 14),
              children: [TextSpan(text: 'Create one',
                style: TextStyle(color: kPrimary, fontWeight: FontWeight.w800))],
            )),
          )),

          const SizedBox(height: 36),
        ]))),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 3. SIGN UP PAGE
// ══════════════════════════════════════════════════════════════════════════════

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool _obscure = true, _obscureConfirm = true, _loading = false, _agreed = false;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    _passCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _phoneCtrl.dispose(); _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushAndRemoveUntil(context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: Stack(children: [
        // Dark header strip
        Positioned(top: 0, left: 0, right: 0,
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF1C1C1E), Color(0xFF3A3A3C)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Stack(children: [
              Positioned(top: -20, right: -20,
                child: Container(width: 120, height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: kPrimary.withOpacity(0.2)))),
              Positioned(bottom: -10, left: 30,
                child: Container(width: 80, height: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: kPrimaryLight.withOpacity(0.15)))),
            ]),
          ),
        ),

        SafeArea(child: SingleChildScrollView(child: Column(children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
                ),
              ),
              const Spacer(),
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(14)),
                child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 22))),
              ),
            ]),
          ),

          const SizedBox(height: 14),

          FadeTransition(opacity: _fade, child: Column(children: [
            const Text('Create Account', style: TextStyle(
              color: Colors.white, fontSize: 26,
              fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            const SizedBox(height: 4),
            Text('Join foodie and start ordering today',
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
          ])),

          const SizedBox(height: 24),

          // Form card
          FadeTransition(opacity: _fade, child: SlideTransition(position: _slide,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08),
                  blurRadius: 30, offset: const Offset(0, 10))],
              ),
              child: Column(children: [
                _AuthField(controller: _nameCtrl, label: 'Full Name',
                  hint: 'Ahmed Al-Rashid', icon: Icons.person_outline_rounded),
                const SizedBox(height: 14),
                _AuthField(controller: _emailCtrl, label: 'Email Address',
                  hint: 'you@example.com', icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 14),
                _AuthField(controller: _phoneCtrl, label: 'Phone Number',
                  hint: '+971 50 000 0000', icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone),
                const SizedBox(height: 14),
                _AuthField(
                  controller: _passCtrl, label: 'Password',
                  hint: 'At least 8 characters', icon: Icons.lock_outline_rounded,
                  obscure: _obscure,
                  suffix: GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: kGrey, size: 20)),
                ),
                const SizedBox(height: 10),
                _PasswordStrength(password: _passCtrl.text),
                const SizedBox(height: 14),
                _AuthField(
                  controller: _confirmCtrl, label: 'Confirm Password',
                  hint: 'Re-enter your password', icon: Icons.lock_outline_rounded,
                  obscure: _obscureConfirm,
                  suffix: GestureDetector(
                    onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    child: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: kGrey, size: 20)),
                ),
                const SizedBox(height: 18),

                // Terms checkbox
                GestureDetector(
                  onTap: () => setState(() => _agreed = !_agreed),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: _agreed ? kPrimary : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _agreed ? kPrimary : Colors.grey.shade300, width: 1.5),
                      ),
                      child: _agreed
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: RichText(text: const TextSpan(
                      text: 'I agree to the ',
                      style: TextStyle(color: kGrey, fontSize: 13, height: 1.5),
                      children: [
                        TextSpan(text: 'Terms of Service',
                          style: TextStyle(color: kPrimary, fontWeight: FontWeight.w700)),
                        TextSpan(text: ' and '),
                        TextSpan(text: 'Privacy Policy',
                          style: TextStyle(color: kPrimary, fontWeight: FontWeight.w700)),
                      ],
                    ))),
                  ]),
                ),

                const SizedBox(height: 24),

                // Create account button
                GestureDetector(
                  onTap: (_loading || !_agreed) ? null : _signUp,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _agreed ? [kPrimary, kPrimaryWarm] : [Colors.grey.shade300, Colors.grey.shade300]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _agreed ? [BoxShadow(color: kPrimary.withOpacity(0.35),
                        blurRadius: 16, offset: const Offset(0, 6))] : [],
                    ),
                    child: Center(child: _loading
                        ? const SizedBox(width: 22, height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white)))
                        : Text('Create Account', style: TextStyle(
                      color: _agreed ? Colors.white : kGrey,
                      fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 0.3))),
                  ),
                ),

                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or sign up with', style: TextStyle(color: kGrey, fontSize: 12))),
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                ]),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: _SocialButton(icon: '🌐', label: 'Google', onTap: () {})),
                  const SizedBox(width: 12),
                  Expanded(child: _SocialButton(icon: '🍎', label: 'Apple', onTap: () {})),
                ]),
              ]),
            ),
          )),

          const SizedBox(height: 28),

          FadeTransition(opacity: _fade, child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: RichText(text: const TextSpan(
              text: 'Already have an account?  ',
              style: TextStyle(color: kGrey, fontSize: 14),
              children: [TextSpan(text: 'Sign In',
                style: TextStyle(color: kPrimary, fontWeight: FontWeight.w800))],
            )),
          )),

          const SizedBox(height: 40),
        ]))),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED AUTH COMPONENTS
// ══════════════════════════════════════════════════════════════════════════════

class _AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  const _AuthField({
    required this.controller, required this.label, required this.hint, required this.icon,
    this.obscure = false, this.suffix, this.keyboardType,
  });
  @override
  State<_AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<_AuthField> {
  bool _focused = false;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label, style: const TextStyle(
        color: kDark, fontSize: 13, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Focus(
        onFocusChange: (f) => setState(() => _focused = f),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _focused ? Colors.white : kLightGrey,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _focused ? kPrimary : Colors.transparent, width: 1.5),
            boxShadow: _focused
                ? [BoxShadow(color: kPrimary.withOpacity(0.12), blurRadius: 12)]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscure,
            keyboardType: widget.keyboardType,
            style: const TextStyle(color: kDark, fontSize: 14, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: kGrey.withOpacity(0.7), fontSize: 13),
              prefixIcon: Icon(widget.icon, color: _focused ? kPrimary : kGrey, size: 20),
              suffixIcon: widget.suffix != null
                  ? Padding(padding: const EdgeInsets.only(right: 4), child: widget.suffix)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _SocialButton extends StatelessWidget {
  final String icon, label;
  final VoidCallback onTap;
  const _SocialButton({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: kLightGrey,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(
            color: kDark, fontWeight: FontWeight.w700, fontSize: 14)),
        ]),
      ),
    );
  }
}

class _PasswordStrength extends StatelessWidget {
  final String password;
  const _PasswordStrength({required this.password});
  int get _strength {
    if (password.isEmpty) return 0;
    int s = 0;
    if (password.length >= 8) s++;
    if (password.contains(RegExp(r'[A-Z]'))) s++;
    if (password.contains(RegExp(r'[0-9]'))) s++;
    if (password.contains(RegExp(r'[!@#\$%^&*]'))) s++;
    return s;
  }
  String get _label => ['', 'Weak', 'Fair', 'Good', 'Strong'][_strength.clamp(0, 4)];
  Color get _color => [Colors.transparent, Colors.red, Colors.orange, Colors.amber, Colors.green]
      [_strength.clamp(0, 4)];
  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    return Row(children: [
      ...List.generate(4, (i) => Expanded(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 4),
          height: 4,
          decoration: BoxDecoration(
            color: i < _strength ? _color : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      )),
      const SizedBox(width: 8),
      Text(_label, style: TextStyle(
        color: _color, fontSize: 11, fontWeight: FontWeight.w700)),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 4. HOME SCREEN  (original app continues from here)
// ══════════════════════════════════════════════════════════════════════════════

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeTab(onCartUpdate: () => setState(() {})),
      const _SearchScreen(),
      const _OrdersScreen(),
      const _ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: kLightBg,
      body: pages[_navIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20)],
        ),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _NavItem(icon: Icons.home_rounded, label: 'Home', index: 0, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
            _NavItem(icon: Icons.search_rounded, label: 'Search', index: 1, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
            _NavItem(icon: Icons.receipt_long_rounded, label: 'Orders', index: 2, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
            _NavItem(icon: Icons.person_rounded, label: 'Profile', index: 3, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
          ]),
        )),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, current;
  final void Function(int) onTap;
  const _NavItem({required this.icon, required this.label,
    required this.index, required this.current, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final selected = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kPrimary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: selected ? kPrimary : kGrey, size: 24),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(
            color: selected ? kPrimary : kGrey, fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
        ]),
      ),
    );
  }
}

// ─── Home Tab ─────────────────────────────────────────────────────────────────

class _HomeTab extends StatefulWidget {
  final VoidCallback onCartUpdate;
  const _HomeTab({required this.onCartUpdate});
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  int _selectedCat = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [kPrimary, kPrimaryWarm],
              begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.location_on, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              const Text('Dubai Marina, UAE', style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CartScreen()))
                    .then((_) => setState(() {})),
                child: Stack(children: [
                  Container(width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22)),
                  if (CartState.totalCount > 0)
                    Positioned(right: 0, top: 0,
                      child: Container(width: 18, height: 18,
                        decoration: const BoxDecoration(color: kDark, shape: BoxShape.circle),
                        child: Center(child: Text('${CartState.totalCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800))))),
                ]),
              ),
            ]),
            const SizedBox(height: 16),
            const Text('What are you\ncraving today?', style: TextStyle(
              color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, height: 1.2)),
            const SizedBox(height: 16),
            Container(
              height: 48,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
              child: Row(children: [
                const SizedBox(width: 14),
                Icon(Icons.search, color: kGrey, size: 20),
                const SizedBox(width: 10),
                Text('Search restaurants, food...', style: TextStyle(color: kGrey, fontSize: 14)),
              ]),
            ),
          ]),
        ),
      ),

      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1C1C1E), Color(0xFF3A3A3C)]),
            borderRadius: BorderRadius.circular(18)),
          child: Row(children: [
            const SizedBox(width: 20),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(6)),
                  child: const Text('LIMITED OFFER',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1))),
                const SizedBox(height: 6),
                const Text('Free delivery\non first 3 orders!', style: TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800, height: 1.3)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(8)),
                  child: const Text('Order Now', style: TextStyle(
                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
              ],
            )),
            const Text('🛵', style: TextStyle(fontSize: 56)),
            const SizedBox(width: 16),
          ]),
        ),
      )),

      SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('Categories', style: TextStyle(color: kDark, fontSize: 18, fontWeight: FontWeight.w800))),
        SizedBox(height: 90, child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: categories.length,
          itemBuilder: (_, i) {
            final sel = i == _selectedCat;
            return GestureDetector(
              onTap: () => setState(() => _selectedCat = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 72,
                decoration: BoxDecoration(
                  color: sel ? kPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(
                    color: sel ? kPrimary.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                    blurRadius: 8, offset: const Offset(0, 4))]),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(categories[i]['emoji']!, style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 4),
                  Text(categories[i]['label']!, style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    color: sel ? Colors.white : kDark)),
                ]),
              ),
            );
          },
        )),
      ])),

      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(children: [
          const Text('Featured', style: TextStyle(color: kDark, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(width: 6),
          const Text('🔥', style: TextStyle(fontSize: 18)),
          const Spacer(),
          Text('See all', style: TextStyle(color: kPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      )),

      SliverToBoxAdapter(child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: sampleRestaurants.where((r) => r.isFeatured).length,
          itemBuilder: (_, i) {
            final featured = sampleRestaurants.where((r) => r.isFeatured).toList();
            return _FeaturedCard(restaurant: featured[i]);
          },
        ),
      )),

      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: const Text('Near You 📍', style: TextStyle(
          color: kDark, fontSize: 18, fontWeight: FontWeight.w800)))),

      SliverList(delegate: SliverChildBuilderDelegate(
        (_, i) => _RestaurantTile(restaurant: sampleRestaurants[i]),
        childCount: sampleRestaurants.length,
      )),

      const SliverToBoxAdapter(child: SizedBox(height: 20)),
    ]);
  }
}

// ─── Featured Card ────────────────────────────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  final Restaurant restaurant;
  const _FeaturedCard({required this.restaurant});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: restaurant))),
      child: Container(
        width: 200, margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 15)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kPrimary.withOpacity(0.8), kPrimaryLight.withOpacity(0.5)]),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18))),
            child: Center(child: Text(restaurant.image, style: const TextStyle(fontSize: 52))),
          ),
          Padding(padding: const EdgeInsets.all(10), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(restaurant.name, style: const TextStyle(
                fontWeight: FontWeight.w800, fontSize: 14, color: kDark)),
              const SizedBox(height: 2),
              Text(restaurant.cuisine, style: const TextStyle(color: kGrey, fontSize: 11)),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.star, color: kGold, size: 13),
                const SizedBox(width: 3),
                Text(restaurant.rating, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                const SizedBox(width: 8),
                Icon(Icons.access_time, color: kGrey, size: 12),
                const SizedBox(width: 3),
                Text(restaurant.time, style: const TextStyle(color: kGrey, fontSize: 11)),
              ]),
            ],
          )),
        ]),
      ),
    );
  }
}

// ─── Restaurant Tile ──────────────────────────────────────────────────────────

class _RestaurantTile extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantTile({required this.restaurant});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: restaurant))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
        child: Row(children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kPrimary.withOpacity(0.15), kPrimaryLight.withOpacity(0.08)]),
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16))),
            child: Center(child: Text(restaurant.image, style: const TextStyle(fontSize: 40))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(restaurant.name, style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 15, color: kDark))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text('Open', style: TextStyle(
                    color: Colors.green.shade600, fontSize: 10, fontWeight: FontWeight.w700))),
              ]),
              const SizedBox(height: 3),
              Text(restaurant.cuisine, style: const TextStyle(color: kGrey, fontSize: 12)),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.star, color: kGold, size: 14),
                const SizedBox(width: 3),
                Text(restaurant.rating, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(width: 12),
                Icon(Icons.access_time_rounded, color: kGrey, size: 13),
                const SizedBox(width: 3),
                Text(restaurant.time, style: const TextStyle(color: kGrey, fontSize: 12)),
                const SizedBox(width: 12),
                Text(restaurant.priceRange, style: const TextStyle(color: kGrey, fontSize: 12)),
              ]),
            ]),
          )),
          const SizedBox(width: 12),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 5. RESTAURANT SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantScreen({super.key, required this.restaurant});
  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  void _updateCart() => setState(() {});
  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    return Scaffold(
      backgroundColor: kLightBg,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 220, pinned: true, backgroundColor: kPrimary,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back_ios_rounded, color: kDark, size: 18))),
          actions: [
            GestureDetector(
              onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CartScreen()))
                  .then((_) => setState(() {})),
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.shopping_bag_outlined, color: kPrimary, size: 18),
                  if (CartState.totalCount > 0) ...[
                    const SizedBox(width: 4),
                    Text('${CartState.totalCount}', style: const TextStyle(
                      color: kPrimary, fontWeight: FontWeight.w800, fontSize: 13)),
                  ],
                ]),
              )),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [kPrimary, kPrimaryWarm],
                  begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 40),
                Text(r.image, style: const TextStyle(fontSize: 72)),
                Text(r.name, style: const TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(r.cuisine, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
              ]),
            ),
          ),
        ),

        SliverToBoxAdapter(child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _InfoChip(icon: Icons.star, label: r.rating, color: kGold),
            _InfoDivider(),
            _InfoChip(icon: Icons.access_time_rounded, label: r.time, color: kPrimary),
            _InfoDivider(),
            _InfoChip(icon: Icons.delivery_dining_rounded, label: 'Free', color: Colors.green),
            _InfoDivider(),
            _InfoChip(icon: Icons.storefront_rounded, label: r.priceRange, color: kDark),
          ]),
        )),

        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Row(children: [
            Container(width: 4, height: 20,
              decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            const Text('Menu', style: TextStyle(color: kDark, fontSize: 18, fontWeight: FontWeight.w800)),
          ]),
        )),

        SliverList(delegate: SliverChildBuilderDelegate(
          (_, i) => _MenuItemTile(item: r.menu[i], onChanged: _updateCart),
          childCount: r.menu.length,
        )),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ]),

      bottomNavigationBar: CartState.totalCount > 0
          ? Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)]),
        child: GestureDetector(
          onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CartScreen()))
              .then((_) => setState(() {})),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [kPrimary, kPrimaryLight]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))]),
            child: Row(children: [
              Container(margin: const EdgeInsets.all(6), width: 42, height: 42,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text('${CartState.totalCount}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)))),
              const Expanded(child: Text('View Cart', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
              Padding(padding: const EdgeInsets.only(right: 16),
                child: Text('\$${CartState.total.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15))),
            ]),
          ),
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _InfoChip({required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 18),
      const SizedBox(height: 3),
      Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: color)),
    ]);
  }
}

class _InfoDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 28, color: Colors.grey.shade200);
}

// ─── Menu Item Tile ───────────────────────────────────────────────────────────

class _MenuItemTile extends StatefulWidget {
  final MenuItem item; final VoidCallback onChanged;
  const _MenuItemTile({required this.item, required this.onChanged});
  @override
  State<_MenuItemTile> createState() => _MenuItemTileState();
}

class _MenuItemTileState extends State<_MenuItemTile> {
  @override
  Widget build(BuildContext context) {
    final qty = CartState.quantityOf(widget.item);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Row(children: [
        Container(width: 64, height: 64,
          decoration: BoxDecoration(color: kLightBg, borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(widget.item.emoji, style: const TextStyle(fontSize: 30)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(widget.item.name, style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 14, color: kDark))),
            if (widget.item.isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6)),
                child: const Text('Popular', style: TextStyle(
                  color: kPrimary, fontSize: 9, fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 3),
          Text(widget.item.description, style: const TextStyle(color: kGrey, fontSize: 11, height: 1.4),
            maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(children: [
            Text(widget.item.price, style: const TextStyle(
              color: kPrimary, fontWeight: FontWeight.w900, fontSize: 15)),
            const Spacer(),
            if (qty == 0)
              GestureDetector(
                onTap: () { CartState.add(widget.item); setState(() {}); widget.onChanged(); },
                child: Container(width: 34, height: 34,
                  decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.add, color: Colors.white, size: 18)))
            else
              Row(children: [
                GestureDetector(
                  onTap: () { CartState.remove(widget.item); setState(() {}); widget.onChanged(); },
                  child: Container(width: 30, height: 30,
                    decoration: BoxDecoration(color: kLightBg, borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kPrimary.withOpacity(0.3))),
                    child: const Icon(Icons.remove, size: 16, color: kPrimary))),
                SizedBox(width: 28, child: Text('$qty', textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15))),
                GestureDetector(
                  onTap: () { CartState.add(widget.item); setState(() {}); widget.onChanged(); },
                  child: Container(width: 30, height: 30,
                    decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.add, size: 16, color: Colors.white))),
              ]),
          ]),
        ])),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 6. CART SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final items = CartState.items;
    final subtotal = CartState.total;
    const delivery = 1.99;
    final total = subtotal + delivery;
    return Scaffold(
      backgroundColor: kLightBg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: GestureDetector(onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_rounded, color: kDark, size: 20)),
        title: const Text('Your Cart', style: TextStyle(
          color: kDark, fontWeight: FontWeight.w900, fontSize: 18)),
        actions: [
          if (items.isNotEmpty)
            TextButton(onPressed: () { CartState.items.clear(); setState(() {}); },
              child: const Text('Clear', style: TextStyle(color: kPrimary, fontWeight: FontWeight.w700))),
        ],
      ),
      body: items.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('🛒', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 16),
        const Text('Your cart is empty', style: TextStyle(color: kDark, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('Add items from a restaurant to get started', style: TextStyle(color: kGrey, fontSize: 13)),
        const SizedBox(height: 24),
        GestureDetector(onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [kPrimary, kPrimaryLight]),
              borderRadius: BorderRadius.circular(14)),
            child: const Text('Browse Restaurants',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
      ]))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...items.map((ci) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
            child: Row(children: [
              Text(ci.item.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ci.item.name, style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 13, color: kDark)),
                const SizedBox(height: 3),
                Text(ci.item.price, style: const TextStyle(
                  color: kPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
              ])),
              Row(children: [
                GestureDetector(onTap: () { CartState.remove(ci.item); setState(() {}); },
                  child: Container(width: 28, height: 28,
                    decoration: BoxDecoration(color: kLightBg, borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kPrimary.withOpacity(0.3))),
                    child: const Icon(Icons.remove, size: 14, color: kPrimary))),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('${ci.quantity}', style: const TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 16))),
                GestureDetector(onTap: () { CartState.add(ci.item); setState(() {}); },
                  child: Container(width: 28, height: 28,
                    decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.add, size: 14, color: Colors.white))),
              ]),
            ]),
          )),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
            child: Column(children: [
              const Align(alignment: Alignment.centerLeft,
                child: Text('Order Summary', style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 15, color: kDark))),
              const SizedBox(height: 12),
              _SummaryRow(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 6),
              _SummaryRow(label: 'Delivery fee', value: '\$${delivery.toStringAsFixed(2)}'),
              const SizedBox(height: 6),
              const _SummaryRow(label: 'Discount', value: '-\$0.00', valueColor: Colors.green),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
              _SummaryRow(label: 'Total', value: '\$${total.toStringAsFixed(2)}',
                bold: true, valueColor: kPrimary),
            ]),
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: items.isEmpty ? null : Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15)]),
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [kPrimary, kPrimaryLight]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))]),
            child: Center(child: Text('Proceed to Checkout   \$${total.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  final Color? valueColor;
  const _SummaryRow({required this.label, required this.value, this.bold = false, this.valueColor});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label, style: TextStyle(color: bold ? kDark : kGrey,
        fontWeight: bold ? FontWeight.w800 : FontWeight.w400, fontSize: bold ? 15 : 13)),
      const Spacer(),
      Text(value, style: TextStyle(color: valueColor ?? kDark,
        fontWeight: FontWeight.w700, fontSize: bold ? 15 : 13)),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 7. CHECKOUT SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _payMethod = 0;
  final _methods = [
    {'icon': '💳', 'label': 'Credit Card', 'sub': '**** 4242'},
    {'icon': '📱', 'label': 'Apple Pay', 'sub': 'Touch ID'},
    {'icon': '💵', 'label': 'Cash on Delivery', 'sub': 'Pay when delivered'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: GestureDetector(onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_rounded, color: kDark, size: 20)),
        title: const Text('Checkout', style: TextStyle(
          color: kDark, fontWeight: FontWeight.w900, fontSize: 18))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _Section(title: 'Delivery Address',
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kPrimary.withOpacity(0.3))),
            child: Row(children: [
              Container(width: 40, height: 40,
                decoration: BoxDecoration(color: kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.home_outlined, color: kPrimary)),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Home', style: TextStyle(fontWeight: FontWeight.w800, color: kDark)),
                Text('Dubai Marina, Building 7, Floor 4',
                  style: TextStyle(color: kGrey, fontSize: 12)),
              ])),
              const Icon(Icons.edit_outlined, color: kGrey, size: 18),
            ]),
          )),
        const SizedBox(height: 16),

        _Section(title: 'Payment Method',
          child: Column(children: List.generate(_methods.length, (i) {
            final m = _methods[i];
            return GestureDetector(
              onTap: () => setState(() => _payMethod = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _payMethod == i ? kPrimary : Colors.transparent, width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
                child: Row(children: [
                  Text(m['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(m['label']!, style: const TextStyle(
                      fontWeight: FontWeight.w700, color: kDark, fontSize: 13)),
                    Text(m['sub']!, style: const TextStyle(color: kGrey, fontSize: 11)),
                  ])),
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _payMethod == i ? kPrimary : Colors.grey.shade300, width: 2),
                      color: _payMethod == i ? kPrimary : Colors.transparent),
                    child: _payMethod == i
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null),
                ]),
              ),
            );
          }))),
        const SizedBox(height: 16),

        _Section(title: 'Order Summary',
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
            child: Column(children: [
              _SummaryRow(label: 'Subtotal', value: '\$${CartState.total.toStringAsFixed(2)}'),
              const SizedBox(height: 6),
              const _SummaryRow(label: 'Delivery', value: '\$1.99'),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
              _SummaryRow(label: 'Total', value: '\$${(CartState.total + 1.99).toStringAsFixed(2)}',
                bold: true, valueColor: kPrimary),
            ]),
          )),
        const SizedBox(height: 100),
      ]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15)]),
        child: GestureDetector(
          onTap: () {
            CartState.items.clear();
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => const OrderConfirmedScreen()), (r) => r.isFirst);
          },
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [kPrimary, kPrimaryLight]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))]),
            child: const Center(child: Text('Place Order',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title; final Widget child;
  const _Section({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: kDark, fontSize: 15, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      child,
    ]);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 8. ORDER CONFIRMED
// ══════════════════════════════════════════════════════════════════════════════

class OrderConfirmedScreen extends StatefulWidget {
  const OrderConfirmedScreen({super.key});
  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBg,
      body: Center(child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ScaleTransition(scale: _scale,
            child: Container(width: 100, height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [kPrimary, kPrimaryLight]),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.3), blurRadius: 30)]),
              child: const Center(child: Icon(Icons.check_rounded, color: Colors.white, size: 52)))),
          const SizedBox(height: 28),
          const Text('Order Placed!', style: TextStyle(
            color: kDark, fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text('Your food is being prepared\nand will arrive soon.',
            textAlign: TextAlign.center,
            style: TextStyle(color: kGrey, fontSize: 15, height: 1.5)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15)]),
            child: Column(children: [
              _TrackStep(icon: '✅', label: 'Order Confirmed', done: true),
              _TrackDot(done: true),
              _TrackStep(icon: '👨‍🍳', label: 'Preparing your order', done: true),
              _TrackDot(done: false),
              _TrackStep(icon: '🛵', label: 'Out for delivery', done: false),
              _TrackDot(done: false),
              _TrackStep(icon: '🏠', label: 'Delivered', done: false),
            ]),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false),
            child: Container(
              width: double.infinity, height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [kPrimary, kPrimaryLight]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))]),
              child: const Center(child: Text('Back to Home',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
            ),
          ),
        ]),
      )),
    );
  }
}

class _TrackStep extends StatelessWidget {
  final String icon, label; final bool done;
  const _TrackStep({required this.icon, required this.label, required this.done});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(icon, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 12),
      Text(label, style: TextStyle(
        color: done ? kDark : kGrey,
        fontWeight: done ? FontWeight.w700 : FontWeight.w400, fontSize: 13)),
      const Spacer(),
      if (done) const Icon(Icons.check_circle, color: Colors.green, size: 18),
    ]);
  }
}

class _TrackDot extends StatelessWidget {
  final bool done;
  const _TrackDot({required this.done});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3),
      child: Column(children: List.generate(3, (_) => Container(
        width: 2, height: 5, margin: const EdgeInsets.only(bottom: 2),
        color: done ? kPrimary.withOpacity(0.5) : Colors.grey.shade200))),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// OTHER NAV SCREENS
// ══════════════════════════════════════════════════════════════════════════════

class _SearchScreen extends StatelessWidget {
  const _SearchScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBg,
      body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Search', style: TextStyle(color: kDark, fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            Container(
              height: 48,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)]),
              child: Row(children: [
                const SizedBox(width: 14),
                Icon(Icons.search, color: kGrey),
                const SizedBox(width: 8),
                Text('Search for food or restaurants...', style: TextStyle(color: kGrey, fontSize: 13)),
              ]),
            ),
          ]),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Popular Searches', style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 15, color: kDark))),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(spacing: 8, runSpacing: 8,
            children: ['🍔 Burgers', '🍕 Pizza', '🍜 Ramen', '🌮 Tacos',
              '🍣 Sushi', '🥗 Salad', '🍗 Chicken', '🧁 Desserts']
                .map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 5)]),
              child: Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            )).toList()),
        ),
        const SizedBox(height: 24),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('All Restaurants', style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 15, color: kDark))),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: sampleRestaurants.length,
          itemBuilder: (_, i) => _RestaurantTile(restaurant: sampleRestaurants[i]),
        )),
      ])),
    );
  }
}

class _OrdersScreen extends StatelessWidget {
  const _OrdersScreen();
  @override
  Widget build(BuildContext context) {
    final orders = [
      {'restaurant': 'Burger Palace', 'emoji': '🍔', 'items': '3 items', 'total': '\$38.97', 'date': 'Feb 28', 'status': 'Delivered'},
      {'restaurant': 'Sushi Zen', 'emoji': '🍱', 'items': '2 items', 'total': '\$35.98', 'date': 'Feb 20', 'status': 'Delivered'},
      {'restaurant': 'Pizza Roma', 'emoji': '🍕', 'items': '1 item', 'total': '\$17.99', 'date': 'Feb 14', 'status': 'Delivered'},
    ];
    return Scaffold(
      backgroundColor: kLightBg,
      body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Text('My Orders', style: TextStyle(color: kDark, fontSize: 28, fontWeight: FontWeight.w900))),
        Expanded(child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: orders.map((o) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
            child: Row(children: [
              Container(width: 54, height: 54,
                decoration: BoxDecoration(color: kLightBg, borderRadius: BorderRadius.circular(14)),
                child: Center(child: Text(o['emoji']!, style: const TextStyle(fontSize: 26)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(o['restaurant']!, style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 14, color: kDark)),
                const SizedBox(height: 3),
                Text('${o['items']} · ${o['total']}', style: const TextStyle(color: kGrey, fontSize: 12)),
                const SizedBox(height: 3),
                Text(o['date']!, style: const TextStyle(color: kGrey, fontSize: 11)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6)),
                  child: Text(o['status']!, style: TextStyle(
                    color: Colors.green.shade600, fontSize: 10, fontWeight: FontWeight.w700))),
                const SizedBox(height: 8),
                const Text('Reorder', style: TextStyle(
                  color: kPrimary, fontSize: 11, fontWeight: FontWeight.w700)),
              ]),
            ]),
          )).toList(),
        )),
      ])),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBg,
      body: SafeArea(child: ListView(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          color: Colors.white,
          child: Row(children: [
            Container(width: 64, height: 64,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [kPrimary, kPrimaryLight]),
                shape: BoxShape.circle),
              child: const Center(child: Text('👤', style: TextStyle(fontSize: 30)))),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Ahmed Al-Rashid', style: TextStyle(
                fontWeight: FontWeight.w900, fontSize: 17, color: kDark)),
              const SizedBox(height: 3),
              const Text('+971 50 123 4567', style: TextStyle(color: kGrey, fontSize: 13)),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: kGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6)),
                child: const Text('Gold Member', style: TextStyle(
                  color: Color(0xFFB8860B), fontSize: 10, fontWeight: FontWeight.w800))),
            ]),
            const Spacer(),
            const Icon(Icons.edit_outlined, color: kGrey, size: 20),
          ]),
        ),
        const SizedBox(height: 12),
        Container(color: Colors.white, child: Column(children: [
          _ProfileTile(icon: Icons.location_on_outlined, label: 'Saved Addresses', color: kPrimary),
          _ProfileTile(icon: Icons.payment_outlined, label: 'Payment Methods', color: Colors.blue),
          _ProfileTile(icon: Icons.favorite_outline, label: 'Favourites', color: Colors.red),
          _ProfileTile(icon: Icons.card_giftcard_outlined, label: 'Promo Codes', color: Colors.green),
          _ProfileTile(icon: Icons.notifications_outlined, label: 'Notifications', color: Colors.orange),
          _ProfileTile(icon: Icons.help_outline, label: 'Help and Support', color: Colors.purple),
        ])),
        const SizedBox(height: 12),
        Container(color: Colors.white,
          child: _ProfileTile(icon: Icons.logout_outlined, label: 'Log Out',
            color: Colors.red, showChevron: false)),
      ])),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon; final String label; final Color color; final bool showChevron;
  const _ProfileTile({required this.icon, required this.label,
    required this.color, this.showChevron = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14, color: kDark))),
        if (showChevron) Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
      ]),
    );
  }
}