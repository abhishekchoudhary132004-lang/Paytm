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

enum AvatarType { initials, groceries, food, travel, medical, shopping, services, misc }

class PaymentRecord {
  String id;
  String name;
  String date;
  double amount;
  bool isCredit; // false = Spent (-), true = Received (+)
  bool isFailed;
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
    this.isFailed = false,
    required this.categoryTag,
    this.bankName = 'From ♾️',
    this.avatarType = AvatarType.initials,
    this.avatarBgColor = const Color(0xFFFFD1D6),
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double currentBalance = 14250.50;

  void _openHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const HistoryScreen(),
      ),
    );
  }

  void _showPayDialog() {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pay / Transfer Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Payee Name / Mobile / UPI ID')),
            TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₹)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF002E6E)),
            onPressed: () {
              final amt = double.tryParse(amountCtrl.text) ?? 0.0;
              if (amt > 0 && nameCtrl.text.isNotEmpty) {
                setState(() => currentBalance -= amt);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Pay Now'),
          ),
        ],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(16)),
                          child: const Row(
                            children: [
                              Text('🪙 ', style: TextStyle(fontSize: 12)),
                              Text('Get 10,000\nGold Coins >', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(icon: const Icon(Icons.search, size: 26), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.notifications_none, size: 26), onPressed: () {}),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('UPI Money Transfer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _roundButton(Icons.qr_code_scanner, 'Scan any\nQR', _showPayDialog),
                        _roundButton(Icons.contact_phone_outlined, 'Pay\nAnyone', _showPayDialog),
                        _roundButton(Icons.account_balance_outlined, 'To Bank &\nSelf A/c', _showPayDialog),
                        _roundButton(Icons.receipt_long_outlined, 'Balance &\nHistory', _openHistory),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
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
                ],
              ),
            ),
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
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))],
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
}

// -------------------------------------------------------------
// History Screen with September and August Sections
// -------------------------------------------------------------
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // September 2026 Transactions (Includes the requested ₹600 debit below Deepak Kumar)
  List<PaymentRecord> septemberTransactions = [
    PaymentRecord(
      id: 'sep_1',
      name: 'Sangeeta Rani',
      date: 'Today, 07:56 PM',
      amount: 2000,
      isCredit: false,
      categoryTag: '💵 Money Transfer',
      avatarType: AvatarType.initials,
      avatarBgColor: const Color(0xFFFFD1D6),
    ),
    PaymentRecord(
      id: 'sep_2',
      name: 'Sajani',
      date: '04 Sep, 10:19 PM',
      amount: 30,
      isCredit: false,
      categoryTag: '🛒 Groceries',
      avatarType: AvatarType.groceries,
      avatarBgColor: const Color(0xFFD6F0FF),
    ),
    PaymentRecord(
      id: 'sep_3',
      name: 'Jay Prakash',
      date: '04 Sep, 10:09 PM',
      amount: 95,
      isCredit: false,
      categoryTag: '🛒 Groceries',
      avatarType: AvatarType.groceries,
      avatarBgColor: const Color(0xFFD6F0FF),
    ),
    PaymentRecord(
      id: 'sep_4',
      name: 'Deepak Kumar',
      date: '03 Sep, 09:43 PM',
      amount: 120,
      isCredit: false,
      categoryTag: '💵 Money Transfer',
      avatarType: AvatarType.initials,
      avatarBgColor: const Color(0xFFFFE0B2),
    ),
    PaymentRecord(
      id: 'sep_custom',
      name: 'Money Transfer',
      date: 'Thursday, 08:30 PM',
      amount: 600,
      isCredit: false,
      categoryTag: '💵 Money Transfer',
      bankName: 'From ♾️',
      avatarType: AvatarType.initials,
      avatarBgColor: const Color(0xFFFFD1D6),
    ),
    PaymentRecord(
      id: 'sep_5',
      name: 'Jay Prakash',
      date: '02 Sep, 07:43 AM',
      amount: 20,
      isCredit: false,
      categoryTag: '🛒 Groceries',
      avatarType: AvatarType.groceries,
      avatarBgColor: const Color(0xFFD6F0FF),
    ),
    PaymentRecord(
      id: 'sep_6',
      name: 'AKHLESH',
      date: '01 Sep, 10:07 PM',
      amount: 30,
      isCredit: false,
      categoryTag: '🛒 Groceries',
      avatarType: AvatarType.groceries,
      avatarBgColor: const Color(0xFFD6F0FF),
    ),
    PaymentRecord(
      id: 'sep_7',
      name: 'Ms Rani Kumari',
      date: '01 Sep, 04:36 PM',
      amount: 20,
      isCredit: false,
      categoryTag: '💵 Money Transfer',
      avatarType: AvatarType.initials,
      avatarBgColor: const Color(0xFFFFCDD2),
    ),
    PaymentRecord(
      id: 'sep_8',
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

  // Complete August 2026 Transactions from your screenshots
  List<PaymentRecord> augustTransactions = [
    PaymentRecord(id: 'aug_1', name: 'Nijam', date: '31 Aug, 07:31 PM', amount: 20, isCredit: false, categoryTag: '💵 Money Transfer', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFE1BEE7)),
    PaymentRecord(id: 'aug_2', name: 'Uber India Systems Private Limited', date: '31 Aug, 05:48 PM', amount: 64, isCredit: false, categoryTag: '✈️ Travel', avatarType: AvatarType.travel),
    PaymentRecord(id: 'aug_3', name: 'Uber India Systems Private Limited', date: '31 Aug, 08:41 AM', amount: 54, isCredit: false, categoryTag: '✈️ Travel', avatarType: AvatarType.travel),
    PaymentRecord(id: 'aug_4', name: 'माँ 🌍 ❤️', date: '31 Aug, 08:40 AM', amount: 200, isCredit: true, categoryTag: '💵 Money Received', bankName: 'To 🟡', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFC8E6C9)),
    PaymentRecord(id: 'aug_5', name: 'Anshika all in one stationary', date: '29 Aug, 09:26 PM', amount: 15, isCredit: false, categoryTag: '🛍️ Shopping', avatarType: AvatarType.shopping),
    PaymentRecord(id: 'aug_6', name: 'Jay Prakash', date: '29 Aug, 08:14 AM', amount: 40, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_7', name: 'Mahesh Singh', date: '27 Aug, 09:07 PM', amount: 950, isCredit: false, categoryTag: '💵 Money Transfer', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFFFF9C4)),
    PaymentRecord(id: 'aug_8', name: 'Fathersahb', date: '27 Aug, 09:04 PM', amount: 1000, isCredit: true, categoryTag: '💵 Money Received', bankName: 'To 🟡', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFFFD1D6)),
    PaymentRecord(id: 'aug_9', name: 'Om Medicos', date: '27 Aug, 08:49 AM', amount: 13, isCredit: false, categoryTag: '🏥 Medical', avatarType: AvatarType.medical),
    PaymentRecord(id: 'aug_10', name: 'JOGENDRA', date: '25 Aug, 07:26 PM', amount: 50, isCredit: false, categoryTag: '🍔 Food', avatarType: AvatarType.food),
    PaymentRecord(id: 'aug_11', name: 'Department of Posts', date: '25 Aug, 09:07 AM', amount: 169, isCredit: false, categoryTag: '🔄 Miscellaneous', avatarType: AvatarType.misc),
    PaymentRecord(id: 'aug_12', name: 'Mr Narender Prasad', date: '24 Aug, 06:07 PM', amount: 35, isCredit: false, categoryTag: '🛍️ Shopping', avatarType: AvatarType.shopping),
    PaymentRecord(id: 'aug_13', name: 'Dharmendra Kumar', date: '23 Aug, 10:17 AM', amount: 50, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_14', name: 'Kishan Dhaba', date: '22 Aug, 08:58 PM', amount: 150, isCredit: false, categoryTag: '🍔 Food', avatarType: AvatarType.food),
    PaymentRecord(id: 'aug_15', name: 'MURLIWALA', date: '22 Aug, 08:40 PM', amount: 60, isCredit: false, categoryTag: '🍔 Food', avatarType: AvatarType.food),
    PaymentRecord(id: 'aug_16', name: 'MURLIWALA', date: '22 Aug, 08:38 PM', amount: 140, isCredit: false, categoryTag: '🍔 Food', avatarType: AvatarType.food),
    PaymentRecord(id: 'aug_17', name: 'Jay Prakash', date: '22 Aug, 07:46 AM', amount: 75, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_18', name: 'Kirpa Rams', date: '21 Aug, 01:31 PM', amount: 70, isCredit: false, categoryTag: '🍔 Food', avatarType: AvatarType.food),
    PaymentRecord(id: 'aug_19', name: 'Sahesh Kumar Saket', date: '21 Aug, 10:38 AM', amount: 20, isCredit: false, categoryTag: '💵 Money Transfer', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFFFF9C4)),
    PaymentRecord(id: 'aug_20', name: 'Fathersahb', date: '21 Aug, 08:30 AM', amount: 1000, isCredit: true, categoryTag: '💵 Money Received', bankName: 'To 🟡', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFFFD1D6)),
    PaymentRecord(id: 'aug_21', name: 'Mr Ajay', date: '20 Aug, 09:27 PM', amount: 30, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_22', name: 'Dawn Corporation', date: '19 Aug, 03:38 PM', amount: 75, isCredit: false, categoryTag: '🍔 Food', avatarType: AvatarType.food),
    PaymentRecord(id: 'aug_23', name: 'Rama Nand Paswan', date: '18 Aug, 11:12 AM', amount: 240, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_24', name: 'Avenue Supermarts Ltd', date: '17 Aug, 06:06 PM', amount: 199, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_25', name: 'Ashish Saxena', date: '16 Aug, 09:26 PM', amount: 283, isCredit: false, categoryTag: '💵 Money Transfer', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFFFE0B2)),
    PaymentRecord(id: 'aug_26', name: 'Mr Tushar Tushar', date: '16 Aug, 09:14 PM', amount: 45, isCredit: false, categoryTag: '💵 Money Transfer', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFC8E6C9)),
    PaymentRecord(id: 'aug_27', name: 'माँ 🌍 ❤️', date: '16 Aug, 06:26 PM', amount: 100, isCredit: true, categoryTag: '💵 Money Received', bankName: 'To 🟡', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFFFCDD2)),
    PaymentRecord(id: 'aug_28', name: 'Veeru Malha', date: '16 Aug, 12:25 PM', amount: 70, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_29', name: 'Veeru Malha', date: '16 Aug, 12:25 PM', amount: 70, isCredit: false, isFailed: true, categoryTag: '', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_30', name: 'Jay Prakash', date: '15 Aug, 07:59 AM', amount: 20, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_31', name: 'Mr MANOJ KUMAR', date: '14 Aug, 08:33 PM', amount: 10, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_32', name: 'Mr MANOJ KUMAR', date: '14 Aug, 08:32 PM', amount: 90, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_33', name: 'Mohd Faijan', date: '14 Aug, 08:24 PM', amount: 25, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_34', name: 'Suraj', date: '14 Aug, 07:51 PM', amount: 45, isCredit: false, categoryTag: '🏦 Services', avatarType: AvatarType.services),
    PaymentRecord(id: 'aug_35', name: 'Suraj', date: '14 Aug, 07:50 PM', amount: 45, isCredit: false, isFailed: true, categoryTag: '', avatarType: AvatarType.services),
    PaymentRecord(id: 'aug_36', name: 'Department of Posts', date: '14 Aug, 09:53 AM', amount: 110, isCredit: false, categoryTag: '🔄 Miscellaneous', avatarType: AvatarType.misc),
    PaymentRecord(id: 'aug_37', name: 'Nitu Kumari', date: '13 Aug, 10:15 AM', amount: 5, isCredit: false, categoryTag: '🔄 Miscellaneous', avatarType: AvatarType.misc),
    PaymentRecord(id: 'aug_38', name: 'Jay Prakash', date: '11 Aug, 07:13 AM', amount: 80, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_39', name: 'Fathersahb', date: '10 Aug, 07:12 PM', amount: 1500, isCredit: true, categoryTag: '💵 Money Received', bankName: 'To 🟡', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFFFD1D6)),
    PaymentRecord(id: 'aug_40', name: 'Jay Prakash', date: '08 Aug, 09:26 PM', amount: 10, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_41', name: 'Ritu Thapa', date: '08 Aug, 12:52 PM', amount: 60, isCredit: false, categoryTag: '💵 Money Transfer', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFE1BEE7)),
    PaymentRecord(id: 'aug_42', name: 'Jay Prakash', date: '07 Aug, 07:27 PM', amount: 100, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_43', name: 'Aanchal', date: '07 Aug, 03:01 PM', amount: 100, isCredit: false, categoryTag: '💵 Money Transfer', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFFFD1D6)),
    PaymentRecord(id: 'aug_44', name: 'Ekart', date: '06 Aug, 06:00 PM', amount: 121, isCredit: false, categoryTag: '🏦 Services', avatarType: AvatarType.services),
    PaymentRecord(id: 'aug_45', name: 'Jay Prakash', date: '05 Aug, 09:40 PM', amount: 20, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_46', name: 'Vivekananda Institute Of Professional Technical Camps', date: '05 Aug, 11:28 AM', amount: 30470, isCredit: false, categoryTag: '📚 Education', avatarType: AvatarType.misc),
    PaymentRecord(id: 'aug_47', name: 'Fathersahb', date: '05 Aug, 11:26 AM', amount: 31000, isCredit: true, categoryTag: '💵 Money Received', bankName: 'To 🟡', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFFFD1D6)),
    PaymentRecord(id: 'aug_48', name: 'Uber India Systems Private Limited', date: '05 Aug, 09:34 AM', amount: 60.80, isCredit: false, categoryTag: '✈️ Travel', avatarType: AvatarType.travel),
    PaymentRecord(id: 'aug_49', name: 'Recharge for Delhi Metro Card Number 85714797', date: '05 Aug, 09:33 AM', amount: 100, isCredit: false, isFailed: true, categoryTag: '', avatarType: AvatarType.misc),
    PaymentRecord(id: 'aug_50', name: 'Rachna Goyal', date: '04 Aug, 08:55 PM', amount: 20, isCredit: false, categoryTag: '🛍️ Shopping', avatarType: AvatarType.shopping),
    PaymentRecord(id: 'aug_51', name: 'Mr Ajay', date: '04 Aug, 08:51 PM', amount: 20, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_52', name: 'Pramod Kumar', date: '04 Aug, 08:49 PM', amount: 70, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_53', name: 'Satish Saini', date: '04 Aug, 08:46 PM', amount: 25, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_54', name: 'Km Radha', date: '04 Aug, 08:13 PM', amount: 95, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_55', name: 'Anirudh Singh', date: '03 Aug, 09:05 PM', amount: 115, isCredit: false, categoryTag: '🏥 Medical', avatarType: AvatarType.medical),
    PaymentRecord(id: 'aug_56', name: 'Ars Group', date: '03 Aug, 08:23 PM', amount: 82, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_57', name: 'JioHotstar - Automatic Payment of ₹349 Setup', date: '03 Aug, 01:38 PM', amount: 56.64, isCredit: false, categoryTag: '📍 Entertainment', avatarType: AvatarType.misc),
    PaymentRecord(id: 'aug_58', name: 'BHATT_STORE_', date: '03 Aug, 12:29 PM', amount: 350, isCredit: false, categoryTag: '🛒 Groceries', avatarType: AvatarType.groceries),
    PaymentRecord(id: 'aug_59', name: 'Kishan Dhaba', date: '03 Aug, 12:27 PM', amount: 100, isCredit: false, categoryTag: '🍔 Food', avatarType: AvatarType.food),
    PaymentRecord(id: 'aug_60', name: 'Fathersahb', date: '03 Aug, 11:28 AM', amount: 1000, isCredit: true, categoryTag: '💵 Money Received', bankName: 'To 🟡', avatarType: AvatarType.initials, avatarBgColor: const Color(0xFFFFD1D6)),
  ];

  String _getInitials(String name) {
    List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '₹';
  }

  void _openEditDialog(PaymentRecord item, VoidCallback onSaved, VoidCallback onDeleted) {
    final nameCtrl = TextEditingController(text: item.name);
    final amtCtrl = TextEditingController(text: item.amount.toString());
    final dateCtrl = TextEditingController(text: item.date);
    final tagCtrl = TextEditingController(text: item.categoryTag);
    final bankCtrl = TextEditingController(text: item.bankName);
    bool isCredit = item.isCredit;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                    IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () {
                      onDeleted();
                      Navigator.pop(ctx);
                    }),
                  ],
                ),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name / Recipient')),
                TextField(controller: amtCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₹)')),
                TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Date / Timestamp')),
                TextField(controller: tagCtrl, decoration: const InputDecoration(labelText: 'Category Tag')),
                TextField(controller: bankCtrl, decoration: const InputDecoration(labelText: 'Subtext (e.g. From ♾️)')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Type: '),
                    ChoiceChip(label: const Text('Debit (-)'), selected: !isCredit, onSelected: (val) => setModalState(() => isCredit = false)),
                    const SizedBox(width: 8),
                    ChoiceChip(label: const Text('Credit (+)'), selected: isCredit, onSelected: (val) => setModalState(() => isCredit = true)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF002E6E), foregroundColor: Colors.white),
                    onPressed: () {
                      setState(() {
                        item.name = nameCtrl.text;
                        item.amount = double.tryParse(amtCtrl.text) ?? item.amount;
                        item.date = dateCtrl.text;
                        item.categoryTag = tagCtrl.text;
                        item.bankName = bankCtrl.text;
                        item.isCredit = isCredit;
                      });
                      onSaved();
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
        title: const Text('Payment History', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMonthBanner('September 2026', '₹2,315', hasArrow: true),
            _buildTransactionListContainer(septemberTransactions, (index) {
              setState(() => septemberTransactions.removeAt(index));
            }),

            const SizedBox(height: 10),

            _buildMonthBanner('August 2026', '₹35,177', isAugustStyle: true),
            _buildTransactionListContainer(augustTransactions, (index) {
              setState(() => augustTransactions.removeAt(index));
            }),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
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
      ),
    );
  }

  Widget _buildMonthBanner(String month, String total, {bool hasArrow = false, bool isAugustStyle = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(month, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isAugustStyle ? 'Total Spent\nRefresh ↻' : 'Total Spent',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: isAugustStyle ? Colors.blue.shade700 : Colors.grey,
                      fontSize: 10,
                      fontWeight: isAugustStyle ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  Text(total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              if (hasArrow) ...[
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFFE8F2FF),
                  child: Icon(Icons.chevron_right, size: 16, color: Colors.blueAccent),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionListContainer(List<PaymentRecord> list, ValueChanged<int> onDelete) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 70, endIndent: 16),
        itemBuilder: (context, index) {
          final item = list[index];
          return InkWell(
            onTap: () => _openEditDialog(item, () => setState(() {}), () => onDelete(index)),
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
                        Text(
                          item.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(item.date, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                        if (item.categoryTag.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F4F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(item.categoryTag, style: const TextStyle(fontSize: 10, color: Colors.black87)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.isFailed
                            ? '₹${item.amount.toInt()}'
                            : '${item.isCredit ? '+ ₹' : '- ₹'}${item.amount == item.amount.roundToDouble() ? item.amount.toInt().toString() : item.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: item.isCredit ? const Color(0xFF1E8E3E) : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (item.isFailed)
                        const Row(
                          children: [
                            Text('Failed ', style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.w600)),
                            Icon(Icons.error, size: 12, color: Colors.red),
                          ],
                        )
                      else
                        Text(item.bankName, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
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
    if (item.avatarType == AvatarType.travel) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(color: Color(0xFFFFF4E5), shape: BoxShape.circle),
        child: const Center(child: Icon(Icons.local_taxi_outlined, size: 20, color: Color(0xFFE65100))),
      );
    }
    if (item.avatarType == AvatarType.food) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(color: Color(0xFFFFF3E0), shape: BoxShape.circle),
        child: const Center(child: Icon(Icons.fastfood_outlined, size: 20, color: Color(0xFFEF6C00))),
      );
    }
    if (item.avatarType == AvatarType.medical) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(color: Color(0xFFE0F7FA), shape: BoxShape.circle),
        child: const Center(child: Icon(Icons.local_hospital_outlined, size: 20, color: Color(0xFF00838F))),
      );
    }
    if (item.avatarType == AvatarType.shopping) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(color: Color(0xFFF1F8E9), shape: BoxShape.circle),
        child: const Center(child: Icon(Icons.shopping_bag_outlined, size: 20, color: Color(0xFF558B2F))),
      );
    }
    if (item.avatarType == AvatarType.services) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(color: Color(0xFFEDE7F6), shape: BoxShape.circle),
        child: const Center(child: Icon(Icons.person_outline, size: 20, color: Color(0xFF512DA8))),
      );
    }
    if (item.avatarType == AvatarType.misc) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(color: Color(0xFFE0F2F1), shape: BoxShape.circle),
        child: const Center(child: Icon(Icons.storefront_outlined, size: 20, color: Color(0xFF00695C))),
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
