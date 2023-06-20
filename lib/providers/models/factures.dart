import 'package:abou/providers/models/produits.dart';
import 'package:objectbox/objectbox.dart';
import 'package:abou/objectbox.g.dart';

@Entity()
class Facture {
  @Id()
  int id;
  //String designation;
  int qte;
  //double pu;
  double pt;
  bool isreduced;
  double reduction;
  DateTime dateHour;

  final ToMany<Produits> products = ToMany<Produits>();

  Facture({
    //required this.designation,
    required this.qte,
    //required this.pu,
    required this.pt,
    required this.isreduced,
    this.reduction = 0,
    required this.dateHour,
    this.id = 0,
  });
}