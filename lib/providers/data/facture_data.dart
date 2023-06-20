import 'package:abou/providers/data/local_facture.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FactureData with ChangeNotifier {
  List<LocalFacture> _factureItems = [];

  List<LocalFacture> get factureItems{
    return[..._factureItems];
  }

   void addItemsFacture(LocalFacture invoice) {
    _factureItems.add(invoice);
    notifyListeners();
  }
}