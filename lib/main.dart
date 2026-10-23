
import 'package:flutter/material.dart';

void main() {
  runApp(const CenterApp());
}

class CenterApp extends StatelessWidget {
  const CenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سنتر الجملة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
      ),
      home: const ShopPage(),
    );
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int tab = 0;
  final List<String> cart = [];

  final categories = [
    ['📱', 'الموبايلات'],
    ['🎧', 'الإكسسوارات'],
    ['🔌', 'الشواحن'],
    ['💳', 'الأرصدة'],
  ];

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            children: [
              Text(
                'أهلاً بكم في سنتر الجملة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'موبايلات وإكسسوارات وأرصدة',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'تسوق حسب القسم',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...categories.map(
          (item) => Card(
            child: ListTile(
              leading: Text(
                item[0],
                style: const TextStyle(fontSize: 30),
              ),
              title: Text(item[1]),
              trailing: const Icon(Icons.arrow_back_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryPage(
                      name: item[1],
                      onAdd: () {
                        setState(() {
                          cart.add(item[1]);
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text('تمت الإضافة للسلة'),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget cartPage() {
    return Column(
      children: [
        Expanded(
          child: cart.isEmpty
              ? const Center(
                  child: Text('سلة التسوق فارغة'),
                )
              : ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cart[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            cart.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
        ),
        if (cart.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('إتمام الطلب'),
                    content: const Text(
                      'الدفع عند الاستلام أو الدفع الإلكتروني '
                      'سيتم تفعيله بعد ربط نظام الطلبات.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('حسناً'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('إتمام الطلب'),
            ),
          ),
      ],
    );
  }

  Widget accountPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 75),
          SizedBox(height: 15),
          Text(
            'حسابي',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          Text('تسجيل الدخول برقم الهاتف قريباً'),
          Text('يمكنك تصفح الأقسام كزائر'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: const Text('سنتر الجملة'),
          centerTitle: true,
        ),
        body: IndexedStack(
          index: tab,
          children: [
            homePage(),
            cartPage(),
            accountPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (value) {
            setState(() => tab = value);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'السلة',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String name;
  final VoidCallback onAdd;

  const CategoryPage({
    super.key,
    required this.name,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(name)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(height: 15),
              const Text('المنتجات التجريبية'),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onAdd,
                child: const Text('إضافة تجريبية للسلة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
