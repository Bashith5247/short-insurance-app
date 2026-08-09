
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const ShortInsuranceApp());

class AppSettings {
  String tplSaloon = '600', tplSuv = '800', compSaloon = '1300', compSuv = '1600';
  String whatsapp = '0525851696', phone = '0554130100', email = 'mohammedbashith@gmail.com';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    tplSaloon = p.getString('tplSaloon') ?? tplSaloon;
    tplSuv = p.getString('tplSuv') ?? tplSuv;
    compSaloon = p.getString('compSaloon') ?? compSaloon;
    compSuv = p.getString('compSuv') ?? compSuv;
    whatsapp = p.getString('whatsapp') ?? whatsapp;
    phone = p.getString('phone') ?? phone;
    email = p.getString('email') ?? email;
  }
  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    for (final e in {
      'tplSaloon': tplSaloon, 'tplSuv': tplSuv, 'compSaloon': compSaloon,
      'compSuv': compSuv, 'whatsapp': whatsapp, 'phone': phone, 'email': email
    }.entries) {
      await p.setString(e.key, e.value);
    }
  }
}
final settings = AppSettings();

class ShortInsuranceApp extends StatefulWidget {
  const ShortInsuranceApp({super.key});
  @override State<ShortInsuranceApp> createState() => _AppState();
}
class _AppState extends State<ShortInsuranceApp> {
  @override void initState() { super.initState(); settings.load().then((_) => setState((){})); }
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SHORT INSURANCE',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0759B8)),
      scaffoldBackgroundColor: const Color(0xFFF4F8FC), useMaterial3: true),
    home: const HomePage(),
  );
}

Future<void> openExternal(String url) async {
  final u = Uri.parse(url);
  if (await canLaunchUrl(u)) await launchUrl(u, mode: LaunchMode.externalApplication);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context) {
    const vehicles = ['CAR','BIKE','VAN','PICKUP','TRUCK','BUS'];
    return Scaffold(
      appBar: AppBar(title: const Text('SHORT INSURANCE', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [IconButton(icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPage()))) ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(colors: [Color(0xFF063B7A), Color(0xFF0878E8)])),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('YOUR SAFETY, OUR PRIORITY', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('GET THE BEST\nMOTOR INSURANCE', style: TextStyle(color: Colors.white, fontSize: 28, height: 1.05, fontWeight: FontWeight.w900)),
            SizedBox(height: 8),
            Text('Comprehensive & Third Party (TPL)', style: TextStyle(color: Colors.white)),
          ])),
        const SizedBox(height: 18),
        const Text('Choose Vehicle', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: vehicles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (_, i) => Card(child: Center(child: Text(vehicles[i], style: const TextStyle(fontWeight: FontWeight.w800))))),
        const SizedBox(height: 14),
        PriceCard('Third Party (TPL)', 'Saloon AED ${settings.tplSaloon}  •  SUV AED ${settings.tplSuv}'),
        const SizedBox(height: 10),
        PriceCard('Comprehensive', 'Saloon AED ${settings.compSaloon}  •  SUV AED ${settings.compSuv}'),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotePage())),
          icon: const Icon(Icons.request_quote_outlined), label: const Padding(padding: EdgeInsets.all(12), child: Text('GET A QUOTE'))),
        const SizedBox(height: 10),
        OutlinedButton.icon(onPressed: () => openExternal('https://wa.me/${settings.whatsapp.replaceAll(RegExp(r"[^0-9]"), "")}'),
          icon: const Icon(Icons.chat), label: const Text('CHAT ON WHATSAPP')),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () => openExternal('tel:${settings.phone}'), icon: const Icon(Icons.phone), label: const Text('CALL'))),
          const SizedBox(width: 10),
          Expanded(child: OutlinedButton.icon(onPressed: () => openExternal('mailto:${settings.email}'), icon: const Icon(Icons.email_outlined), label: const Text('EMAIL'))),
        ]),
      ]),
    );
  }
}

class PriceCard extends StatelessWidget {
  final String title, prices;
  const PriceCard(this.title, this.prices, {super.key});
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16),
    child: Row(children: [const CircleAvatar(backgroundColor: Color(0xFFE5F0FF), child: Icon(Icons.shield_outlined)),
      const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const Text('Starting From + VAT', style: TextStyle(fontSize: 11, color: Colors.grey)),
        Text(prices, style: const TextStyle(fontWeight: FontWeight.w700)),
      ]))])));
}

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});
  @override State<QuotePage> createState() => _QuoteState();
}
class _QuoteState extends State<QuotePage> {
  final name = TextEditingController(), mobile = TextEditingController(), vehicleNo = TextEditingController(), chassis = TextEditingController();
  String vehicle = 'Car', cover = 'Comprehensive';
  XFile? mulkiya;

  Future<void> pick() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (x != null) setState(() => mulkiya = x);
  }
  Future<void> send() async {
    final msg = 'Hello SHORT INSURANCE,\n\nI would like a motor insurance quote.\n\n'
      'Name: ${name.text}\nMobile: ${mobile.text}\nVehicle Type: $vehicle\n'
      'Vehicle No: ${vehicleNo.text}\nChassis No: ${chassis.text}\nInsurance: $cover\n'
      'Mulkiya: ${mulkiya == null ? "Not attached" : "Selected in app"}\n\nPlease provide the best available price.';
    final n = settings.whatsapp.replaceAll(RegExp(r'[^0-9]'), '');
    final u = Uri.parse('https://wa.me/$n?text=${Uri.encodeComponent(msg)}');
    if (await canLaunchUrl(u)) await launchUrl(u, mode: LaunchMode.externalApplication);
  }

  InputDecoration d(String label, IconData icon) => InputDecoration(labelText: label, prefixIcon: Icon(icon));
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Get a Quote', style: TextStyle(fontWeight: FontWeight.w800))),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      TextField(controller: name, decoration: d('Full Name', Icons.person_outline)),
      const SizedBox(height: 10),
      TextField(controller: mobile, keyboardType: TextInputType.phone, decoration: d('Mobile / WhatsApp', Icons.phone_outlined)),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(value: vehicle, decoration: d('Vehicle Type', Icons.directions_car_outlined),
        items: ['Car','Bike','Van','Pickup','Truck','Bus'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => setState(() => vehicle = v!)),
      const SizedBox(height: 10),
      TextField(controller: vehicleNo, decoration: d('Vehicle Number', Icons.pin_outlined)),
      const SizedBox(height: 10),
      TextField(controller: chassis, decoration: d('Chassis Number', Icons.tag_outlined)),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(value: cover, decoration: d('Insurance Type', Icons.shield_outlined),
        items: ['Comprehensive','Third Party (TPL)'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => setState(() => cover = v!)),
      const SizedBox(height: 14),
      OutlinedButton.icon(onPressed: pick, icon: const Icon(Icons.upload_file),
        label: Text(mulkiya == null ? 'UPLOAD MULKIYA' : 'MULKIYA SELECTED')),
      const SizedBox(height: 14),
      FilledButton.icon(onPressed: send, icon: const Icon(Icons.chat),
        label: const Padding(padding: EdgeInsets.all(13), child: Text('SEND QUOTE REQUEST ON WHATSAPP'))),
      const SizedBox(height: 10),
      const Text('Final premium depends on vehicle and customer details. Displayed prices are starting prices + VAT.',
        textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey)),
    ]),
  );
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  @override State<AdminPage> createState() => _AdminState();
}
class _AdminState extends State<AdminPage> {
  final pin = TextEditingController();
  bool unlocked = false;
  final t1=TextEditingController(), t2=TextEditingController(), c1=TextEditingController(), c2=TextEditingController(),
      wa=TextEditingController(), ph=TextEditingController(), em=TextEditingController();

  void login() {
    if (pin.text == '2585') {
      setState(() { unlocked=true; t1.text=settings.tplSaloon; t2.text=settings.tplSuv; c1.text=settings.compSaloon; c2.text=settings.compSuv;
        wa.text=settings.whatsapp; ph.text=settings.phone; em.text=settings.email; });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect admin PIN')));
    }
  }
  Future<void> save() async {
    settings.tplSaloon=t1.text.trim(); settings.tplSuv=t2.text.trim(); settings.compSaloon=c1.text.trim(); settings.compSuv=c2.text.trim();
    settings.whatsapp=wa.text.trim(); settings.phone=ph.text.trim(); settings.email=em.text.trim();
    await settings.save();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved on this device')));
  }
  Widget f(TextEditingController c, String l) => Padding(padding: const EdgeInsets.only(bottom: 10), child: TextField(controller:c, decoration:InputDecoration(labelText:l)));
  @override Widget build(BuildContext context) {
    if (!unlocked) return Scaffold(appBar: AppBar(title: const Text('Admin Login')),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children:[
        const Icon(Icons.admin_panel_settings_outlined,size:64,color:Color(0xFF0759B8)),
        const SizedBox(height:18), TextField(controller:pin,obscureText:true,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Admin PIN')),
        const SizedBox(height:14), FilledButton(onPressed:login,child:const Text('LOGIN'))
      ])));
    return Scaffold(appBar:AppBar(title:const Text('Admin Panel')),body:ListView(padding:const EdgeInsets.all(16),children:[
      const Text('Starting Prices (AED)',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800)),
      const SizedBox(height:10), f(t1,'TPL Saloon'),f(t2,'TPL SUV'),f(c1,'Comprehensive Saloon'),f(c2,'Comprehensive SUV'),
      const SizedBox(height:8), const Text('Contact Details',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800)),
      const SizedBox(height:10),f(wa,'WhatsApp'),f(ph,'Call Number'),f(em,'Email'),
      const SizedBox(height:8),FilledButton.icon(onPressed:save,icon:const Icon(Icons.save_outlined),label:const Text('SAVE CHANGES')),
      const SizedBox(height:14),const Text('MVP note: settings are stored locally. For live updates on every customer phone, connect this admin panel to a cloud database before publishing.',
        style:TextStyle(fontSize:12,color:Colors.grey))
    ]));
  }
}
