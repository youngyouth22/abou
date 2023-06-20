import 'package:abou/helpers/produits.dart';
import 'package:abou/providers/data/facture_data.dart';
import 'package:abou/screens/produits.dart';
import 'package:abou/screens/Commande.dart';
import 'package:abou/widgets/custom_title_bar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:path_provider/path_provider.dart';
import './windowtitlebar.dart';
import './functions/preferencesmanager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:abou/helpers/objectbox_interfaces.dart';

late ObjectBox objectbox;
void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    objectbox = await ObjectBox.create();
  await Window.initialize();
  await WindowManager.instance.ensureInitialized();

  PreferencesManager.init();
  //GlobalData.gAppDocDir = await getApplicationDocumentsDirectory();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setSize(const Size(755, 545));
    await windowManager.setMinimumSize(const Size(750, 600));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
    await Window.setEffect(
      effect: WindowEffect.mica,
      color: Color(0xCC222222),
    );
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers :[
       ChangeNotifierProvider(
          create: (ctx) => AddProduits(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FactureData(),
        ),
      ],
      child: FluentApp(
        title: 'Abou',
        debugShowCheckedModeBanner: false,
        theme: FluentThemeData(accentColor: Colors.blue, brightness: Brightness.dark),
          themeMode: ThemeMode.dark,
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationPaneTheme(
      data: const NavigationPaneThemeData(backgroundColor: Colors.transparent),
      child: Stack(
        children: [
          NavigationView(
            // appBar: const NavigationAppBar(
            //   title: 
            // ),
            contentShape: RoundedRectangleBorder(),
            pane: NavigationPane(
            selected: currentTabIndex,
            onChanged: (index) => setState(() => currentTabIndex = index),
            displayMode: PaneDisplayMode.open,
              header: const SizedBox(
                    height: 30,
                  ),
                  
              items: [
                    PaneItem(
                      icon: const Icon(Iconsax.home5,
                      size: 18),
                      title: const Text("Acceuil"),
                      body: const Icon(Iconsax.setting5),
                    ),
                    PaneItem(
                      icon: const Icon(Iconsax.receipt_2_15,
                      size: 18),
                      title: const Text("Facture"),
                      body: const Commande(),
                    ),
                    PaneItem(
                      icon: const Icon(Iconsax.shop5,
                      size: 18),
                      title: const Text("Produits"),
                      body: const Produit(),
                    ),
                    PaneItem(
                      icon: const Icon(Iconsax.profile_2user5,
                      size: 18),
                      title: const Text("Fournisseurs"),
                      body: const Icon(Iconsax.user_search5),
                    ),
                    PaneItem(
                      icon: const Icon(Iconsax.clipboard5,
                      size: 18),
                      title: const Text("Stock"),
                      body: const Icon(Iconsax.user_search5),
                    ),
                    PaneItem(
                      icon: const Icon(Iconsax.chart_215,
                      size: 18),
                      title: const Text("Statistique"),
                      body: const Icon(Iconsax.user_search5),
                    ),
                    PaneItem(
                      icon: const Icon(Iconsax.menu_board5,
                      size: 18),
                      title: const Text("Historique"),
                      body: const Icon(Iconsax.user_search5),
                    ),
                  

                  ],
                  footerItems: [
                    PaneItemSeparator(),
                    PaneItem(
                      icon: const Icon(Iconsax.setting4,
                      size: 18),
                      title: const Text("Setting"),
                      body: const Icon(Iconsax.user_search5),
                    ),
                    PaneItem(
                      icon: const Icon(Iconsax.info_circle4,
                      size: 18),
                      title: const Text("A propos"),
                      body: const Icon(Iconsax.user_search4),
                    ),
                  
                  ],
            ),
          ),
          CustomTitleBar(),
        ],
      ),
    );
  }
}
