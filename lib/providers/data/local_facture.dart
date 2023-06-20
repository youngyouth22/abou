import 'package:fluent_ui/fluent_ui.dart';

class LocalFacture with ChangeNotifier {
  final int id;
  final String nom;
  final int qte;
  final double pu;

  LocalFacture({
    required this.id,
    required this.nom,
    required this.qte,
    required this.pu,
  });
}