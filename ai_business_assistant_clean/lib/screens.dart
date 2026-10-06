
import 'package:flutter/material.dart';

const primary = Color(0xFF5B5CE2);
const green = Color(0xFF18A56A);
const red = Color(0xFFE05252);
const bg = Color(0xFFF7F8FC);

class App {
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  static void replace(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const AppBarTitle(this.title, {this.subtitle, super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          if (subtitle != null)
            Text(subtitle!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  const PrimaryButton(this.label, {required this.onPressed, this.icon, super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: icon == null ? const SizedBox.shrink() : Icon(icon),
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      );
}

class Field extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  const Field(this.label, this.hint, {this.icon = Icons.edit_outlined, this.obscure = false, super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon),
          ),
        ),
      );
}

class PageShell extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool back;
  const PageShell({
    required this.title,
    required this.child,
    this.actions,
    this.back = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: back,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          actions: actions,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) App.replace(context, const Onboarding1Screen());
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6C63E8), Color(0xFF8C7CF7)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(Icons.smart_toy_rounded, size: 64, color: primary),
                ),
                const SizedBox(height: 24),
                const Text(
                  'AI Business\nAssistant',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your AI employee for smarter business',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 48),
                const SizedBox(width: 160, child: LinearProgressIndicator(minHeight: 5)),
              ],
            ),
          ),
        ),
      );
}

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});
  @override
  Widget build(BuildContext context) => OnboardingPage(
        title: 'Run Your\nBusiness Smarter',
        body: 'Create invoices, manage customers, track payments and get business insights with AI.',
        icon: Icons.storefront_rounded,
        page: 1,
        onNext: () => App.push(context, const Onboarding2Screen()),
      );
}

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});
  @override
  Widget build(BuildContext context) => OnboardingPage(
        title: 'Save Time.\nGrow Faster.',
        body: 'Let AI help with reports, reminders, follow-ups and everyday business decisions.',
        icon: Icons.auto_graph_rounded,
        page: 2,
        onNext: () => App.push(context, const ChooseBusinessTypeScreen()),
      );
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final int page;
  final VoidCallback onNext;
  const OnboardingPage({
    required this.title,
    required this.body,
    required this.icon,
    required this.page,
    required this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => App.push(context, const ChooseBusinessTypeScreen()),
                    child: const Text('Skip'),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEEFF),
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Icon(icon, size: 92, color: primary),
                ),
                const SizedBox(height: 36),
                Text(title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                Text(body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.5)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (i) => Container(
                        width: i == page - 1 ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: i == page - 1 ? primary : const Color(0xFFD9DBE8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ),
                const SizedBox(height: 20),
                PrimaryButton('Next', onPressed: onNext),
              ],
            ),
          ),
        ),
      );
}

class ChooseBusinessTypeScreen extends StatelessWidget {
  const ChooseBusinessTypeScreen({super.key});
  final types = const [
    ('Retail Shop', Icons.storefront),
    ('Service Business', Icons.handyman),
    ('Restaurant', Icons.restaurant),
    ('Salon', Icons.content_cut),
    ('Automobile', Icons.directions_car),
    ('Wholesale', Icons.warehouse),
    ('Freelancer', Icons.laptop_mac),
    ('Agency', Icons.groups),
    ('Other', Icons.more_horiz),
  ];

  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Choose Business Type',
        back: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What type of business do you have?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('This helps us personalize your experience.',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: types.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .9,
              ),
              itemBuilder: (_, i) => Card(
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => App.push(context, const RegisterScreen()),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(types[i].$2, color: primary, size: 30),
                        const SizedBox(height: 8),
                        Text(types[i].$1, textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton('Next', onPressed: () => App.push(context, const RegisterScreen())),
          ],
        ),
      );
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Create Account',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Let’s get your account started',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            const Field('Full Name', 'Enter your name', icon: Icons.person_outline),
            const Field('Mobile Number', '+91 Enter mobile number', icon: Icons.phone_outlined),
            const Field('Email (optional)', 'Enter email', icon: Icons.email_outlined),
            const Field('Password', 'Create a password', icon: Icons.lock_outline, obscure: true),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: true,
              onChanged: (_) {},
              title: const Text('I agree to Terms & Privacy Policy', style: TextStyle(fontSize: 13)),
            ),
            const SizedBox(height: 8),
            PrimaryButton('Create Account', onPressed: () => App.push(context, const OtpScreen())),
            Center(
              child: TextButton(
                onPressed: () => App.push(context, const LoginScreen()),
                child: const Text('Already have an account? Sign In'),
              ),
            ),
          ],
        ),
      );
}

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Verify Your Mobile',
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.verified_user_rounded, size: 70, color: primary),
            const SizedBox(height: 18),
            const Text('We sent a 6-digit code to +91 98765 43210',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (_) => SizedBox(
                    width: 48,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(counterText: ''),
                    ),
                  )),
            ),
            const SizedBox(height: 18),
            const Text('Resend code in 00:30', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            PrimaryButton('Verify', onPressed: () => App.push(context, const LoginScreen())),
          ],
        ),
      );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Welcome Back',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sign in to continue',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            const Field('Mobile Number', '+91 Enter mobile number', icon: Icons.phone_outlined),
            const Field('Password', 'Enter your password', icon: Icons.lock_outline, obscure: true),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {}, child: const Text('Forgot Password?')),
            ),
            PrimaryButton('Sign In', onPressed: () => App.replace(context, const DashboardScreen())),
            const SizedBox(height: 14),
            Row(children: const [
              Expanded(child: Divider()),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('or continue with')),
              Expanded(child: Divider()),
            ]),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.g_mobiledata), label: const Text('Google'))),
                const SizedBox(width: 10),
                Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.email_outlined), label: const Text('Email'))),
              ],
            ),
            Center(
              child: TextButton(
                onPressed: () => App.push(context, const RegisterScreen()),
                child: const Text('Don’t have an account? Register'),
              ),
            ),
          ],
        ),
      );
}

class BusinessSetupScreen extends StatelessWidget {
  const BusinessSetupScreen({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Set Up Your Business',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tell us about your business',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            Center(
              child: Column(children: [
                CircleAvatar(radius: 42, backgroundColor: const Color(0xFFEDEEFF),
                    child: const Icon(Icons.storefront, size: 42, color: primary)),
                TextButton(onPressed: () {}, child: const Text('Add Logo')),
              ]),
            ),
            const Field('Business Name', 'Enter business name', icon: Icons.business),
            const Field('Business Type', 'Retail Shop', icon: Icons.category_outlined),
            const Field('GSTIN (optional)', 'Enter GSTIN', icon: Icons.receipt_long_outlined),
            const Field('Address', 'Enter address', icon: Icons.location_on_outlined),
            PrimaryButton('Complete Setup', onPressed: () => App.replace(context, const DashboardScreen())),
          ],
        ),
      );
}

class BottomNav extends StatelessWidget {
  final int index;
  const BottomNav({required this.index, super.key});

  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          final pages = [
            const DashboardScreen(),
            const CustomersScreen(),
            const ProductsScreen(),
            const ReportsScreen(),
            const ProfileMoreScreen(),
          ];
          App.replace(context, pages[i]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Customers'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Products'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.more_horiz), selectedIcon: Icon(Icons.more_horiz), label: 'More'),
        ],
      );
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const AppBarTitle('Good Morning, Rajesh 👋', subtitle: 'ABC Electricals'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Today, 15 Oct 2024', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: const [
                StatCard('Today’s Sales', '₹24,500', '+12%', Icons.trending_up, green),
                StatCard('This Month', '₹4,82,000', '+18%', Icons.show_chart, green),
                StatCard('Receivables', '₹84,500', 'Due', Icons.payments_outlined, red),
                StatCard('Expenses', '₹2,10,000', '+8%', Icons.money_off, red),
              ],
            ),
            const SizedBox(height: 22),
            const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              children: [
                QuickAction('Invoice', Icons.receipt_long, () => App.push(context, const CreateInvoiceScreen())),
                QuickAction('Customer', Icons.person_add, () => App.push(context, const AddCustomerScreen())),
                QuickAction('Products', Icons.inventory_2, () => App.push(context, const ProductsScreen())),
                QuickAction('Expense', Icons.money_off, () => App.push(context, const AddExpenseScreen())),
                QuickAction('Payments', Icons.payments, () => App.push(context, const PaymentsScreen())),
                QuickAction('Reports', Icons.bar_chart, () => App.push(context, const ReportsScreen())),
                QuickAction('AI Assistant', Icons.smart_toy, () => App.push(context, const AiAssistantScreen())),
                QuickAction('More', Icons.more_horiz, () => App.push(context, const ProfileMoreScreen())),
              ],
            ),
          ],
        ),
        bottomNavigationBar: const BottomNav(index: 0),
        floatingActionButton: FloatingActionButton(
          onPressed: () => App.push(context, const AiAssistantScreen()),
          child: const Icon(Icons.auto_awesome),
        ),
      );
}

class StatCard extends StatelessWidget {
  final String title, value, change;
  final IconData icon;
  final Color iconColor;
  const StatCard(this.title, this.value, this.change, this.icon, this.iconColor, {super.key});
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Icon(icon, size: 20, color: iconColor), const Spacer(), Text(change, style: TextStyle(color: iconColor, fontSize: 11))]),
            const Spacer(),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          ]),
        ),
      );
}

class QuickAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const QuickAction(this.title, this.icon, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: const Color(0xFFEDEEFF), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(height: 5),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        ]),
      );
}

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});
  final customers = const [
    ('Rajesh Kumar', '₹84,500 due'),
    ('Priya Sharma', '₹12,000 due'),
    ('Kumar Enterprises', '₹0 All cleared'),
    ('Sunil Verma', '₹5,200 due'),
    ('Anita Traders', '₹18,000 due'),
    ('Global Solutions', '₹0 All cleared'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Customers', style: TextStyle(fontWeight: FontWeight.w800)),
          actions: [IconButton(onPressed: () => App.push(context, const AddCustomerScreen()), icon: const Icon(Icons.add))],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(decoration: InputDecoration(hintText: 'Search customers...', prefixIcon: const Icon(Icons.search))),
            const SizedBox(height: 12),
            ...customers.map((c) => Card(
                  elevation: 0,
                  child: ListTile(
                    onTap: () => App.push(context, CustomerDetailsScreen(name: c.$1)),
                    leading: CircleAvatar(backgroundColor: const Color(0xFFEDEEFF), child: Text(c.$1[0], style: const TextStyle(color: primary))),
                    title: Text(c.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(c.$2),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                )),
          ],
        ),
        bottomNavigationBar: const BottomNav(index: 1),
      );
}

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});
  @override
  Widget build(BuildContext context) => FormPage(
        title: 'Add Customer',
        fields: const [
          ('Customer Name', 'Enter name', Icons.person_outline),
          ('Phone Number', '+91 Enter phone number', Icons.phone_outlined),
          ('Email (optional)', 'Enter email', Icons.email_outlined),
          ('Address', 'Enter address', Icons.location_on_outlined),
          ('GSTIN (optional)', 'Enter GSTIN', Icons.receipt_long_outlined),
          ('Customer Type', 'Regular', Icons.category_outlined),
        ],
        button: 'Save Customer',
        onSave: () => App.replace(context, const CustomersScreen()),
      );
}

class CustomerDetailsScreen extends StatelessWidget {
  final String name;
  const CustomerDetailsScreen({required this.name, super.key});
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Customer Details',
        child: Column(
          children: [
            CircleAvatar(radius: 42, backgroundColor: const Color(0xFFEDEEFF), child: Text(name[0], style: const TextStyle(fontSize: 28, color: primary))),
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: StatCard('Total Invoice', '₹48,500', '12', Icons.receipt_long, primary)),
              const SizedBox(width: 10),
              Expanded(child: StatCard('Outstanding', '₹8,500', 'Due', Icons.payments, red)),
            ]),
            const SizedBox(height: 18),
            PrimaryButton('Record Payment', onPressed: () => App.push(context, const PaymentsScreen())),
          ],
        ),
      );
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});
  final products = const [
    ('LED Bulb 10W', '₹150', '50'),
    ('Ceiling Fan', '₹2,400', '20'),
    ('Switch Board', '₹350', '40'),
    ('Tube Light', '₹250', '30'),
    ('MCB 32A', '₹480', '20'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Products', style: TextStyle(fontWeight: FontWeight.w800)),
          actions: [IconButton(onPressed: () => App.push(context, const AddProductScreen()), icon: const Icon(Icons.add))],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(decoration: InputDecoration(hintText: 'Search products...', prefixIcon: const Icon(Icons.search))),
            const SizedBox(height: 12),
            ...products.map((p) => Card(
                  elevation: 0,
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Color(0xFFEDEEFF), child: Icon(Icons.inventory_2, color: primary)),
                    title: Text(p.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${p.$2} • Stock: ${p.$3}'),
                    trailing: const Icon(Icons.more_vert),
                  ),
                )),
          ],
        ),
        bottomNavigationBar: const BottomNav(index: 2),
      );
}

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});
  @override
  Widget build(BuildContext context) => FormPage(
        title: 'Add Product',
        fields: const [
          ('Product Name', 'Enter product name', Icons.inventory_2_outlined),
          ('Category', 'Select category', Icons.category_outlined),
          ('Price', '₹ Enter price', Icons.currency_rupee),
          ('Quantity', 'Enter stock quantity', Icons.numbers),
        ],
        button: 'Save Product',
        onSave: () => App.replace(context, const ProductsScreen()),
      );
}

class CreateInvoiceScreen extends StatelessWidget {
  const CreateInvoiceScreen({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Create Invoice',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepHeader(),
            const SizedBox(height: 16),
            const Field('Customer', 'Select customer', icon: Icons.person_outline),
            Card(
              elevation: 0,
              child: Column(children: [
                ListTile(title: const Text('LED Bulb 10W'), subtitle: const Text('₹150 × 10'), trailing: const Text('₹1,500')),
                const Divider(height: 1),
                ListTile(title: const Text('Ceiling Fan'), subtitle: const Text('₹1,200 × 2'), trailing: const Text('₹2,400')),
              ]),
            ),
            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Add Item')),
            const SummaryRow('Subtotal', '₹3,900'),
            const SummaryRow('GST (18%)', '₹702'),
            const SummaryRow('Total', '₹4,602', bold: true),
            const SizedBox(height: 16),
            PrimaryButton('Preview Invoice', onPressed: () => App.push(context, const InvoicePreviewScreen())),
          ],
        ),
      );
}

class StepHeader extends StatelessWidget {
  const StepHeader({super.key});
  @override
  Widget build(BuildContext context) => Row(
        children: const [
          Expanded(child: StepDot('1', 'Customer', true)),
          Expanded(child: StepDot('2', 'Items', true)),
          Expanded(child: StepDot('3', 'Preview', false)),
        ],
      );
}

class StepDot extends StatelessWidget {
  final String n, label;
  final bool active;
  const StepDot(this.n, this.label, this.active, {super.key});
  @override
  Widget build(BuildContext context) => Column(children: [
        CircleAvatar(radius: 16, backgroundColor: active ? primary : const Color(0xFFD9DBE8), child: Text(n, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 11)),
      ]);
}

class SummaryRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const SummaryRow(this.label, this.value, {this.bold = false, super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Expanded(child: Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.normal))),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w600)),
        ]),
      );
}

class InvoicePreviewScreen extends StatelessWidget {
  const InvoicePreviewScreen({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Invoice Preview',
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('ABC Electricals', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const Text('123 Main Street, Chennai\nGSTIN: 33ABCDE1234F1Z5\n+91 98765 43210'),
              const Divider(height: 30),
              const Text('INVOICE  INV-0012', style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              const Text('Bill To: Rajesh Kumar\nChennai - 600001'),
              const SizedBox(height: 18),
              const SummaryRow('LED Bulb 10W × 10', '₹1,500'),
              const SummaryRow('Ceiling Fan × 2', '₹2,400'),
              const Divider(),
              const SummaryRow('Subtotal', '₹3,900'),
              const SummaryRow('GST (18%)', '₹702'),
              const SummaryRow('Total', '₹4,602', bold: true),
              const SummaryRow('Amount Paid', '₹2,000'),
              const SummaryRow('Balance Due', '₹2,602', bold: true),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.share), label: const Text('Share'))),
                const SizedBox(width: 10),
                Expanded(child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.download), label: const Text('Download'))),
              ]),
            ]),
          ),
        ),
      );
}

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});
  final expenses = const [
    ('Purchase', '₹25,000', '10 Oct 2024'),
    ('Rent', '₹15,000', '05 Oct 2024'),
    ('Salary', '₹12,000', '03 Oct 2024'),
    ('Transport', '₹5,000', '02 Oct 2024'),
    ('Electricity', '₹3,200', '20 Sep 2024'),
    ('Other', '₹2,500', '15 Sep 2024'),
  ];
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Expenses',
        actions: [IconButton(onPressed: () => App.push(context, const AddExpenseScreen()), icon: const Icon(Icons.add))],
        child: Column(children: [
          TextField(decoration: InputDecoration(hintText: 'Search expenses...', prefixIcon: const Icon(Icons.search))),
          const SizedBox(height: 10),
          ...expenses.map((e) => Card(elevation: 0, child: ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFFFFF0F0), child: Icon(Icons.money_off, color: red)),
            title: Text(e.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(e.$3),
            trailing: Text(e.$2, style: const TextStyle(fontWeight: FontWeight.w800)),
          ))),
        ]),
      );
}

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});
  @override
  Widget build(BuildContext context) => FormPage(
        title: 'Add Expense',
        fields: const [
          ('Category', 'Select category', Icons.category_outlined),
          ('Amount (₹)', 'Enter amount', Icons.currency_rupee),
          ('Date', '15 Oct 2024', Icons.calendar_today_outlined),
          ('Description', 'Enter description', Icons.notes_outlined),
        ],
        button: 'Save Expense',
        onSave: () => App.replace(context, const ExpensesScreen()),
      );
}

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});
  final people = const [
    ('Rajesh Kumar', '₹84,500', 'Due 10 Oct 2024'),
    ('Priya Sharma', '₹12,000', 'Due 05 Oct 2024'),
    ('Kumar Enterprises', '₹24,000', 'Due 28 Oct 2024'),
    ('Sunil Verma', '₹5,200', 'Due 15 Oct 2024'),
  ];
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Payments',
        child: Column(children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'receivable', label: Text('Receivables')),
              ButtonSegment(value: 'history', label: Text('Payment History')),
            ],
            selected: const {'receivable'},
            onSelectionChanged: (_) {},
          ),
          const SizedBox(height: 12),
          ...people.map((p) => Card(elevation: 0, child: ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFFEDEEFF), child: Icon(Icons.person, color: primary)),
            title: Text(p.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('${p.$2} • ${p.$3}'),
            trailing: TextButton(onPressed: () {}, child: const Text('Remind')),
          ))),
        ]),
      );
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Reports', style: TextStyle(fontWeight: FontWeight.w800))),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: 'This Month',
              items: const [DropdownMenuItem(value: 'This Month', child: Text('This Month')), DropdownMenuItem(value: 'This Year', child: Text('This Year'))],
              onChanged: (_) {},
              decoration: const InputDecoration(labelText: 'Period'),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: const [
                StatCard('Sales', '₹4,82,000', '+18%', Icons.trending_up, green),
                StatCard('Expenses', '₹2,10,000', '-12%', Icons.trending_down, red),
                StatCard('Profit', '₹2,72,000', '+24%', Icons.account_balance_wallet, green),
                StatCard('Receivables', '₹84,500', '-6%', Icons.payments, red),
              ],
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Sales Overview', style: TextStyle(fontWeight: FontWeight.w800)),
                  const Text('₹4,82,000', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 20),
                  SizedBox(height: 180, child: CustomPaint(painter: BarChartPainter())),
                ]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNav(index: 3),
      );
}

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = primary;
    final values = [0.45, 0.62, 0.5, 0.78, 0.92, 0.68];
    final labels = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
    final width = size.width / values.length;
    for (var i = 0; i < values.length; i++) {
      final h = size.height * values[i];
      final x = i * width + width * .22;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, size.height - h - 24, width * .56, h), const Radius.circular(8)),
        paint,
      );
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: const TextStyle(fontSize: 10, color: Colors.grey)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x + width * .18, size.height - 18));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});
  @override
  State<AiAssistantScreen> createState() => _AiAssistantState();
}

class _AiAssistantState extends State<AiAssistantScreen> {
  final controller = TextEditingController();
  final messages = <String>['Hi! I’m your AI Business Assistant. I can help with invoices, reports, customers, payments and business insights.'];

  void ask(String text) {
    setState(() {
      messages.add(text);
      messages.add('Based on your business data, I found the answer. This demo is ready to connect to your AI API.');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('AI Assistant', style: TextStyle(fontWeight: FontWeight.w800))),
        body: Column(children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) => Align(
                alignment: i.isEven ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  constraints: const BoxConstraints(maxWidth: 330),
                  decoration: BoxDecoration(
                    color: i.isEven ? Colors.white : primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(messages[i], style: TextStyle(color: i.isEven ? Colors.black87 : Colors.white)),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(children: [
              'How much did I sell this month?',
              'Who owes me money?',
              'Create an invoice',
              'What is my profit?',
            ].map((q) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(label: Text(q), onPressed: () => ask(q)),
            )).toList()),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Type your question...'))),
              const SizedBox(width: 8),
              IconButton.filled(onPressed: () { if (controller.text.trim().isNotEmpty) { ask(controller.text.trim()); controller.clear(); } }, icon: const Icon(Icons.send)),
            ]),
          ),
        ]),
      );
}

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Choose Your Plan',
        child: Column(children: [
          const Text('Unlock more features with AI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          const PlanCard('Free', '₹0', ['25 customers', '25 invoices/month', 'Basic reports', 'AI limited'], 'Current Plan'),
          const PlanCard('Pro', '₹299/month', ['Unlimited customers', 'Unlimited invoices', 'AI assistant', 'Advanced reports', 'Payment reminders'], 'Upgrade'),
          const PlanCard('Business', '₹699/month', ['Multiple employees', 'Inventory', 'Advanced analytics', 'Priority support'], 'Upgrade'),
        ]),
      );
}

class PlanCard extends StatelessWidget {
  final String name, price, button;
  final List<String> features;
  const PlanCard(this.name, this.price, this.features, this.button, {super.key});
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            Text(price, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: primary)),
            const SizedBox(height: 8),
            ...features.map((f) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [const Icon(Icons.check_circle, size: 17, color: green), const SizedBox(width: 7), Text(f)]))),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () {}, child: Text(button))),
          ]),
        ),
      );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  final items = const [
    ('Business Profile', Icons.business),
    ('Employees', Icons.people),
    ('Notifications', Icons.notifications_none),
    ('Currency & Tax', Icons.currency_rupee),
    ('Backup & Restore', Icons.backup),
    ('Subscription', Icons.workspace_premium),
    ('Security', Icons.lock_outline),
    ('Help & Support', Icons.help_outline),
  ];
  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Settings',
        child: Column(children: [
          ...items.map((x) => Card(elevation: 0, child: ListTile(leading: Icon(x.$2, color: primary), title: Text(x.$1), trailing: const Icon(Icons.chevron_right)))),
          Card(elevation: 0, child: ListTile(leading: const Icon(Icons.logout, color: red), title: const Text('Logout', style: TextStyle(color: red)), onTap: () => App.replace(context, const LoginScreen()))),
        ]),
      );
}

class ProfileMoreScreen extends StatelessWidget {
  const ProfileMoreScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Profile & More', style: TextStyle(fontWeight: FontWeight.w800))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
            const CircleAvatar(radius: 32, backgroundColor: Color(0xFFEDEEFF), child: Text('RK', style: TextStyle(color: primary, fontWeight: FontWeight.w900))),
            const SizedBox(width: 14),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Rajesh Kumar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              Text('ABC Electricals'),
              Text('rajesh@example.com', style: TextStyle(color: Colors.grey)),
            ]),
          ]))),
          const SizedBox(height: 10),
          ListTileCard('View Profile', Icons.person_outline, () {}),
          ListTileCard('Manage Business', Icons.business, () => App.push(context, const BusinessSetupScreen())),
          ListTileCard('Subscription', Icons.workspace_premium, () => App.push(context, const SubscriptionScreen())),
          ListTileCard('Settings', Icons.settings_outlined, () => App.push(context, const SettingsScreen())),
          ListTileCard('AI Assistant', Icons.smart_toy, () => App.push(context, const AiAssistantScreen())),
        ]),
        bottomNavigationBar: const BottomNav(index: 4),
      );
}

class ListTileCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const ListTileCard(this.title, this.icon, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: ListTile(onTap: onTap, leading: Icon(icon, color: primary), title: Text(title), trailing: const Icon(Icons.chevron_right)));
}

class FormPage extends StatelessWidget {
  final String title, button;
  final List<(String, String, IconData)> fields;
  final VoidCallback onSave;
  const FormPage({required this.title, required this.fields, required this.button, required this.onSave, super.key});
  @override
  Widget build(BuildContext context) => PageShell(
        title: title,
        child: Column(children: [
          ...fields.map((f) => Field(f.$1, f.$2, icon: f.$3)),
          const SizedBox(height: 8),
          PrimaryButton(button, onPressed: onSave),
        ]),
      );
}
