import 'package:objectbox/objectbox.dart';
import 'package:abou/objectbox.g.dart';
import 'package:abou/providers/models/factures.dart';

@Entity()
class Produits {
  @Id()
  int id;
  String code;
  String nom;
  double prix;
  int quantite;

  final ToOne<Categorie> categorie = ToOne<Categorie>();
  final ToMany<Facture> produit = ToMany<Facture>();

  Produits({
    required this.code,
    required this.nom,
    required this.prix,
    required this.quantite,
    this.id = 0
  });


}

@Entity()
class Categorie {
  @Id()
  int id;
  String nom;

  @Backlink() 
  final ToMany<Produits> produit = ToMany<Produits>();

  Categorie({
    required this.nom,
    this.id = 0
  });
}