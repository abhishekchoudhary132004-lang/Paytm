import 'package:flutter/material.dart';

void main() {
  runApp(const PaytmCloneApp());
}

class PaytmCloneApp extends StatelessWidget {
  const PaytmCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paytm UI Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorSchemeSeed: const Color(0xFF002E6E),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// -------------------------------------------------------------
// Transaction Data Model
// -------------------------------------------------------------
enum AvatarType { initials, groceries }

class PaymentRecord {
  String id;
  String name;
  String date;
  double amount;
  bool isCredit; // false = Spent (-), true = Received (+)
  String categoryTag;
  String bankName;
  AvatarType avatarType;
  Color avatarBgColor;

  PaymentRecord({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.categoryTag,
    this.bankName = 'From ♾️',
    this.avatarType = AvatarType.initials,
    this.avatarBgColor = const Color(0xFFFFD1D6),
  });
}

// -------------------------------------------------------------
// Screen 1: Home Dashboard
// -------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double currentBalance = 14250.50;

  // Master Transaction List seeded from your screenshots
  List<PaymentRecord> transactions = [
    PaymentRecord(
      id: '1',
      name: 'Sangeeta Rani',
      date: 'Today, 07:56 PM',
      amount: 2000,
      isCredit: false,
      categoryTag: '💵 Money Transfer',
      avatarType: AvatarType.initials,
      avatarBgColor: const Color(0xFFFFD1D6),
    ),
    PaymentRecord(
      id: '2',
      name: 'Sajani',
      date: '04 Sep, 10:19 PM',
      amount: 30,
      isCredit: false,
      categoryTag: '🛒 Groceries',
      avatarType: AvatarType.groceries,
      avatarBgColor: const Color(0xFFD6F0FF),
    ),
    PaymentRecord(
      id: '3',
      name: 'Jay Prakash',
      date: '04 Sep, 10:09 PM',
      amount: 95,
      isCredit: false,
      categoryTag: '🛒 Groceries',
      avatarType: AvatarType.groceries,
      avatarBgColor: const Color(0xFFD6F0FF),
    ),
    PaymentRecord(
      id: '4',
      name: 'Deepak Kumar',
      date: '03 Sep, 09:43 PM',
      amount: 120,
      isCredit: false,
      categoryTag: '💵 Money Transfer',
      avatarType: AvatarType.initials,
      avatarBgColor: const Color(0xFFFFE0B2),
    ),
    PaymentRecord(
      id: '5',
      name: 'Jay Prakash',
      date: '02 Sep, 07:43 AM',
      amount: 20,
      isCredit: false,
      categoryTag: '🛒 Groceries',
      avatarType: AvatarType.groceries,
      avatarBgColor: const Color(0xFFD6F0FF),
    ),
    PaymentRecord(
      id: '6',
      name: 'AKHLESH',
      date: '01 Sep, 10:07 PM',
      amount: 30,
      isCredit: false,
      categoryTag: '🛒 Groceries',
      avatarType: AvatarType.groceries,
      avatarBgColor: const Color(0xFFD6F0FF),
    ),
    PaymentRecord(
      id: '7',
      name: 'Ms Rani Kumari',
      date: '01 Sep, 04:36 PM',
      amount: 20,
      isCredit: false,
      categoryTag: '💵 Money Transfer',
      avatarType: AvatarType.initials,
      avatarBgColor: const Color(0xFFFFCDD2),
    ),
    PaymentRecord(
      id: '8',
      name: 'Fathersahb',
      date: '01 Sep, 08:07 AM',
      amount: 1000,
      isCredit: true,
      categoryTag: '💵 Money Received',
      bankName: 'To 🟡',
      avatarType: AvatarType.initials,
      avatarBgColor: const Color(0xFFFFE1F3),
    ),
  ];

  // Quick Pay Modal
  void _showPayDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pay / Transfer Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Payee Name / Mobile / UPI ID',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF002E6E)),
            onPressed: () {
              final amt = double.tryParse(amountController.text) ?? 0.0;
              final name = nameController.text.trim();
              if (amt > 0 && name.isNotEmpty) {
                setState(() {
                  currentBalance -= amt;
                  transactions.insert(
                    0,
                    PaymentRecord(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      amount: amt,
                      isCredit: false,
                      date: 'Today, 08:30 PM',
                      categoryTag: '💵 Money Transfer',
                      avatarType: AvatarType.initials,
                      avatarBgColor: const Color(0xFFFFD1D6),
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Paid ₹$amt successfully to $name')),
                );
              }
            },
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  void _openHistoryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => HistoryScreen(
          balance: currentBalance,
          transactions: transactions,
          onUpdateBalance: (newBal) => setState(() => currentBalance = newBal),
          onUpdateList: () => setState(() {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Profile Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Text('🪙 ', style: TextStyle(fontSize: 12)),
                              Text(
                                'Get 10,000\nGold Coins >',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(icon: const Icon(Icons.search, size: 26), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.notifications_none, size: 26), onPressed: () {}),
                      ],
                    ),
                  ),

                  // UPI Money Transfer Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'UPI Money Transfer',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Circular UPI Options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _roundButton(Icons.qr_code_scanner, 'Scan any\nQR', _showPayDialog),
                        _roundButton(Icons.contact_phone_outlined, 'Pay\nAnyone', _showPayDialog),
                        _roundButton(Icons.account_balance_outlined, 'To Bank &\nSelf A/c', _showPayDialog),
                        _roundButton(Icons.receipt_long_outlined, 'Balance &\nHistory', _openHistoryScreen),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Recharge & Bills Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Recharge & Bills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('View All →', style: TextStyle(fontSize: 13, color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _serviceItem(Icons.phone_android, 'Mobile\nRecharge'),
                            _serviceItem(Icons.credit_card, 'Credit Card\nBill'),
                            _serviceItem(Icons.lightbulb_outline, 'Electricity\nBill'),
                            _serviceItem(Icons.directions_car, 'FASTag\nRecharge'),
                            _serviceItem(Icons.request_quote_outlined, 'Loan\nPaym...'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Insurance Alert Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_car_filled, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Insurance - DL3CCM7491', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              Text('Expiring on 21 Sep', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          ),
                          child: const Text('Renew', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Bottom Grid Tiles
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 140,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.calendar_today_outlined, color: Colors.grey),
                                Spacer(),
                                Text('Paytm Postpaid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                SizedBox(height: 4),
                                Text('Tap to activate — Up to ₹60,000 limit', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              _infoCardTile(Icons.shield_outlined, 'Car Insurance'),
                              const SizedBox(height: 8),
                              _infoCardTile(Icons.group_outlined, 'Refer & Win ₹80'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Scan QR Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: GestureDetector(
                  onTap: _showPayDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF003366), Color(0xFF0066CC)]),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Scan QR', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(color: Color(0xFF002E6E), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _serviceItem(IconData icon, String title) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF002E6E), size: 22),
        ),
        const SizedBox(height: 6),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _infoCardTile(IconData icon, String title) {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// Screen 2: Balance & Editable Payment History
// -------------------------------------------------------------
class HistoryScreen extends StatefulWidget {
  final double balance;
  final List<PaymentRecord> transactions;
  final ValueChanged<double> onUpdateBalance;
  final VoidCallback onUpdateList;

  const HistoryScreen({
    super.key,
    required this.balance,
    required this.transactions,
    required this.onUpdateBalance,
    required this.onUpdateList,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  double get totalSpent {
    return widget.transactions
        .where((item) => !item.isCredit)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  String _getInitials(String name) {
    List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '₹';
  }

  void _openEditDialog(PaymentRecord item, int index) {
    final nameController = TextEditingController(text: item.name);
    final amountController = TextEditingController(text: item.amount.toInt().toString());
    final dateController = TextEditingController(text: item.date);
    final tagController = TextEditingController(text: item.categoryTag);
    final bankController = TextEditingController(text: item.bankName);
    bool isCredit = item.isCredit;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: verticalBorder),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Transaction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() => widget.transactions.removeAt(index));
                        widget.onUpdateList();
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name / Recipient')),
                TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₹)')),
                TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Date / Timestamp')),
                TextField(controller: tagController, decoration: const InputDecoration(labelText: 'Category Tag')),
                TextField(controller: bankController, decoration: const InputDecoration(labelText: 'Subtext (From / To)')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Type: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ChoiceChip(
                      label: const Text('Debit (-)'),
                      selected: !isCredit,
                      onSelected: (val) => setModalState(() => isCredit = false),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Credit (+)'),
                      selected: isCredit,
                      onSelected: (val) => setModalState(() => isCredit = true),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF002E6E), foregroundColor: Colors.white),
                    onPressed: () {
                      setState(() {
                        item.name = nameController.text;
                        item.amount = double.tryParse(amountController.text) ?? item.amount;
                        item.date = dateController.text;
                        item.categoryTag = tagController.text;
                        item.bankName = bankController.text;
                        item.isCredit = isCredit;
                      });
                      widget.onUpdateList();
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openAddNewDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController(text: 'Today, 08:30 PM');
    final tagController = TextEditingController(text: '💵 Money Transfer');
    bool isCredit = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: verticalBorder),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Add Custom Entry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name / Store')),
                TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₹)')),
                TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Date / Timestamp')),
                TextField(controller: tagController, decoration: const InputDecoration(labelText: 'Tag (e.g. 🛒 Groceries)')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Type: '),
                    ChoiceChip(
                      label: const Text('Debit (-)'),
                      selected: !isCredit,
                      onSelected: (val) => setModalState(() => isCredit = false),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Credit (+)'),
                      selected: isCredit,
                      onSelected: (val) => setModalState(() => isCredit = true),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF002E6E), foregroundColor: Colors.white),
                    onPressed: () {
                      final amt = double.tryParse(amountController.text) ?? 0;
                      if (nameController.text.isNotEmpty && amt > 0) {
                        setState(() {
                          widget.transactions.insert(
                            0,
                            PaymentRecord(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: nameController.text,
                              date: dateController.text,
                              amount: amt,
                              isCredit: isCredit,
                              categoryTag: tagController.text,
                              bankName: isCredit ? 'To 🟡' : 'From ♾️',
                              avatarType: AvatarType.initials,
                              avatarBgColor: const Color(0xFFFFD1D6),
                            ),
                          );
                        });
                        widget.onUpdateList();
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Add Entry'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const verticalBorder = BorderRadius.vertical(top: Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Balance & History', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Text('Payment History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.search, size: 22), onPressed: () {}),
                IconButton(icon: const Icon(Icons.tune, size: 22), onPressed: _openAddNewDialog),
                IconButton(icon: const Icon(Icons.file_download_outlined, size: 22), onPressed: () {}),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('September 2026', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Total Spent', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text('₹${totalSpent.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFFE8F2FF),
                      child: Icon(Icons.chevron_right, size: 16, color: Colors.blueAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.transactions.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 70, endIndent: 16),
                itemBuilder: (context, index) {
                  final item = widget.transactions[index];
                  return InkWell(
                    onTap: () => _openEditDialog(item, index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAvatar(item),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
                                const SizedBox(height: 4),
                                Text(item.date, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFF1F4F6), borderRadius: BorderRadius.circular(6)),
                                  child: Text(item.categoryTag, style: const TextStyle(fontSize: 10, color: Colors.black87)),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${item.isCredit ? '+ ₹' : '- ₹'}${item.amount.toInt()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: item.isCredit ? const Color(0xFF1E8E3E) : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(item.bankName, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Paytm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                SizedBox(width: 6),
                Text('|', style: TextStyle(color: Colors.grey, fontSize: 10)),
                SizedBox(width: 6),
                Text('UPI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blueGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(PaymentRecord item) {
    if (item.avatarType == AvatarType.groceries) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(color: Color(0xFFE2F4FF), shape: BoxShape.circle),
        child: const Center(child: Icon(Icons.local_grocery_store_outlined, size: 20, color: Color(0xFF007ACC))),
      );
    }
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: item.avatarBgColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          _getInitials(item.name),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF7A1B30)),
        ),
      ),
    );
  }
}
