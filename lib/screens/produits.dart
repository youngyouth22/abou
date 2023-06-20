import 'package:abou/main.dart';
import 'package:abou/objectbox.g.dart';
import 'package:abou/providers/models/produits.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'dart:async';


class Produit extends StatefulWidget {
  const Produit({super.key});

  @override
  State<Produit> createState() => _ProduitState();
}

class _ProduitState extends State<Produit> {


bool isProduct = true;
bool isCategorie= false;
bool isSideShow = false;

  Box<Produits> ProduitBox = objectbox.store.box<Produits>(); 
  Box<Produits>? ProduitBox2;
  Stream<List<Produits>>? fetchAllProduits;

  Box<Categorie> CategorieBox = objectbox.store.box<Categorie>(); 
  Box<Categorie>? CategorieBox2;
  Stream<List<Categorie>>? fetchAllCategorie;

  TextEditingController codeController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController qteController = TextEditingController();
  TextEditingController catController = TextEditingController();


  Categorie? selectedCategory;
   List <Categorie>? categoriesta;
  @override
  void initState() {
    super.initState();
    ProduitBox2 = objectbox.store.box<Produits>();
    CategorieBox2 = objectbox.store.box<Categorie>();
    print(ProduitBox2!.count());
    print(CategorieBox2!.count());
    setState(() {
      fetchAllProduits = ProduitBox2!.query().watch(triggerImmediately: true).map((event) => 
    event.find());
    fetchAllCategorie = CategorieBox2!.query().watch(triggerImmediately: true).map((event) => 
    event.find());
    categoriesta = CategorieBox.query().build().find();
print(categoriesta);
    });
  }

  bool isCodeUnique(String code) {
  final query = ProduitBox2!.query(Produits_.code.equals(code)).build();
  final count = query.count();
  query.close();
  return count == 0;
}

bool isNomUnique(String nom) {
  final query = CategorieBox2!.query(Categorie_.nom.equals(nom)).build();
  final count = query.count();
  query.close();
  return count == 0;
}

  // @override
  // void dispose() {
  //   objectbox.store.close();
  //   super.dispose();
  // }

  void changeProductScreen(){
    setState(() {
      isProduct = false;
      isCategorie = true;
    });
  }

  void changeCategorieScreen(){
    setState(() {
      isProduct = true;
      isCategorie = false;
    });
  }

  Future<List<Produits>> _getProducts(Categorie category) async {
    return ProduitBox2!.query(Produits_.categorie.equals(category.id)).build().find();
  }


ValueNotifier<bool> isQuantite = ValueNotifier<bool>(false);
ValueNotifier<bool> isCats = ValueNotifier<bool>(false);
List<String> cats= ['salut','dance','reconnaissance'];
ValueNotifier<String> setCats = ValueNotifier<String>('');
void onDropdownChanged(String? selectedValue) {
  print('Nouvelle valeur sélectionnée : $selectedValue');
  setState(() {
    setCats.value = selectedValue!;
  });
  
}

  void showAddProductDialog(BuildContext context) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      constraints: BoxConstraints(
        maxWidth: 600,
      ),
      title: const Text('Ajouter un produit'),
      content: SingleChildScrollView(
        child: Column(
          children: [
           
      
            const SizedBox(height: 15,),
      
            InfoLabel(
              label: 'Entrer le code du Produit :',
              labelStyle: TextStyle(
                fontSize: 16,
              ),
              child: TextBox(
                controller: codeController,
                placeholder: 'code',
                style: TextStyle(
                  fontSize: 18,
                ),
                keyboardType: TextInputType.name,
              )
              ),
      
              const SizedBox(height: 10,),
              InfoLabel(
              label: 'Entrer le Nom :',
              labelStyle: TextStyle(
                fontSize: 16,
              ),
              child: TextBox(
                controller: nomController,
                placeholder: 'nom',
                style: TextStyle(
                  fontSize: 18,
                ),
                keyboardType: TextInputType.name,
              )
              ),
      
              const SizedBox(height: 10,),
              InfoLabel(
              label: 'Entrer le Prix :',
              labelStyle: TextStyle(
                fontSize: 16,
              ),
              child: TextBox(
                controller: prixController,
                placeholder: 'prix',
                style: TextStyle(
                  fontSize: 18,
                ),
                keyboardType: TextInputType.number,
              )
              ),
      
              const SizedBox(height: 10,),
              InfoLabel(
              label: 'Entrer la quantité :',
              labelStyle: TextStyle(
                fontSize: 16,
              ),
              child: ValueListenableBuilder<bool>(
              valueListenable: isQuantite,
              builder: (context, value, child) {
                return TextBox(
                controller: qteController,
                enabled: isQuantite.value,
                placeholder: 'quantité',
                style: TextStyle(
                  fontSize: 18,
                ),
                keyboardType: TextInputType.number,
              );
               },
            ),
          ),
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                     ValueListenableBuilder<bool>(
                        valueListenable: isQuantite,
                        builder: (context, value, child) {
                          return Checkbox(
                            checked: value,
                            onChanged: (v) {
                              setState(() {
                                isQuantite.value = v!;
                              });
                            },
                          );
                        },
                      ),
                    const SizedBox(width: 8,),
                    const Text('Entrer la quantité ?')
                  ],
                ),
              ),
      
              Container(
                width: double.infinity,
                child: InfoLabel(
                  label: 'Choisir une catégorie',
                  labelStyle:  const TextStyle(
                   fontSize: 16,
                   ),
                  child: Container(
                    width: double.infinity,
                    child: ValueListenableBuilder<String>(
          valueListenable: setCats,
          builder: (BuildContext context, String value, Widget? child) {
        return  FutureBuilder<List<Categorie>>(
  future: Future.value(categoriesta),
  builder: (context, snapshot) {
    
    if (snapshot.hasData) {
      final categories = snapshot.data!;

      return ComboBox(
                      value: setCats.value,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      items: categories.map<ComboBoxItem<String>>((e) {
                      return ComboBoxItem<String>(
                        child: Text(e.nom),
                        value: e.id.toString(),
                      );
                    }).toList(),
                    placeholder: const Text ('Catégorie',
                              style: TextStyle(
                    fontSize: 16,
                              ),),
                    onChanged: onDropdownChanged,            
        );
        }
         else if (snapshot.hasError) {
      return Text('Erreur lors de la récupération des catégories.');
    } else {
      return ProgressRing();
    }
        }
        );
    
          }
                    )
      
                  ),
                ),
              ),
      
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                     ValueListenableBuilder<bool>(
                        valueListenable: isCats,
                        builder: (context, value, child) {
                          return Checkbox(
                            checked: value,
                            onChanged: (v) {
                              setState(() {
                                isCats.value = v!;
                              });
                            },
                          );
                        },
                      ),
                    const SizedBox(width: 8,),
                    const Text('Choisir la catégorie ?')
                  ],
                ),
              ),
      
          ],
        ),
      ),
      actions: [
        Button(
          style: ButtonStyle(
            padding: ButtonState.all(const EdgeInsets.all(16))
          ),
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.pop(context, 'User deleted file');
            // Delete file here
          },
        ),
        FilledButton(
          style: ButtonStyle(
            padding: ButtonState.all(const EdgeInsets.all(16))
          ),
          child: const Text('Ajouter'),
          onPressed: () async {
          Produits model = Produits(code: codeController.text, nom: nomController.text, prix: double.parse(prixController.text), quantite: int.parse(qteController.text),);
          model.categorie.targetId = int.parse(setCats.value);
          
          if (isCodeUnique(codeController.text))
         { try
          {ProduitBox.put(model);
          codeController.clear();
          nomController.clear();
          prixController.clear();
          qteController.clear();

          displayInfoBar(context, builder: (context, close) {
  return InfoBar(
    title: const Text('Bravo'),
    content: const Text(
        'Votre produit a été ajouté avec success '),
    action: IconButton(
      icon: const Icon(FluentIcons.clear),
      onPressed: close,
    ),
    severity: InfoBarSeverity.success,
  );
} );
          } catch (error) {
            displayInfoBar(context, builder: (context, close) {
  return InfoBar(
    title: const Text('Une erreur est survenue :/'),
    content: const Text(
        'Oooouuuups un problème inconnue est survenue veuillez réessayer :/'),
    action: IconButton(
      icon: const Icon(FluentIcons.clear),
      onPressed: close,
    ),
    severity: InfoBarSeverity.warning,
  );
});
          }}
          else{
            displayInfoBar(context, builder: (context, close) {
  return InfoBar(
    title: const Text('Le code éxiste déja :/'),
    content: const Text(
        'Entrer un autre code ou vérifier si le produit existe déja :/'),
    action: IconButton(
      icon: const Icon(FluentIcons.clear),
      onPressed: close,
    ),
    severity: InfoBarSeverity.warning,
  );
});
          }
          
          Navigator.pop(context);
          
          },
        ),
      ],
    ),
  );
  setState(() {});
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

void showCatAdd(BuildContext context) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text('Ajouter une catégorie'),
      content: InfoLabel(
              label: 'Entrer le nom de la catégorie :',
              labelStyle: TextStyle(
                fontSize: 16,
              ),
              child: TextBox(
                controller: catController,
                placeholder: 'Catégorie',
                style: TextStyle(
                  fontSize: 18,
                ),
                keyboardType: TextInputType.number,
              )
              ),
      actions: [
        Button(
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.pop(context, 'User deleted file');
            // Delete file here
          },
        ),
        FilledButton(
          child: const Text('Ajouter'),
          onPressed: () async {
          Categorie model = Categorie(nom: catController.text);
          if (isNomUnique(catController.text))
         { try
          {CategorieBox.put(model);
          catController.clear();

          displayInfoBar(context, builder: (context, close) {
  return InfoBar(
    title: const Text('Bravo'),
    content: const Text(
        'Votre Catégorie a été ajouté avec success '),
    action: IconButton(
      icon: const Icon(FluentIcons.clear),
      onPressed: close,
    ),
    severity: InfoBarSeverity.success,
  );
} );
          } catch (error) {
            displayInfoBar(context, builder: (context, close) {
  return InfoBar(
    title: const Text('Une erreur est survenue :/'),
    content: const Text(
        'Oooouuuups un problème inconnue est survenue veuillez réessayer :/'),
    action: IconButton(
      icon: const Icon(FluentIcons.clear),
      onPressed: close,
    ),
    severity: InfoBarSeverity.warning,
  );
});
          }}
          else{
            displayInfoBar(context, builder: (context, close) {
  return InfoBar(
    title: const Text('La catégorie éxiste déja :/'),
    content: const Text(
        'Entrer un autre nom ou vérifier si la catégorie existe déja :/'),
    action: IconButton(
      icon: const Icon(FluentIcons.clear),
      onPressed: close,
    ),
    severity: InfoBarSeverity.warning,
  );
});
          }
          
          Navigator.pop(context);
          
          },
        ),
      ],
    ),
  );
  setState(() {});
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        width: double.infinity,
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            
            FilledButton(
              style: ButtonStyle(
                padding: ButtonState.all( const EdgeInsets.all(10))
              ),
            child: const Text('Ajouter un Produit', style: TextStyle(color: Colors.white),),
            onPressed: () => showAddProductDialog(context),
            ),
            const SizedBox(width: 20,),
            Button(
              style: ButtonStyle(
                padding: ButtonState.all( const EdgeInsets.all(10))
              ),
            child: const Text('Liste des Catégories'),
            onPressed: isCategorie == false? changeProductScreen : null,

           ),
          ],
        ),
      ),
      content: BodyWithSideSheet(
        sheetBody: FutureBuilder<List<Produits>>(
        future: _getProducts(selectedCategory??Categorie(nom: '')),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data;
            return ListView.builder(
              itemCount: products!.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.nom),
                  // Vous pouvez afficher d'autres informations du produit ici
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Une erreur s\'est produite');
          }
          return ProgressRing();
        },
      ),
        //////////////// Side show part/////////////////////////  ////////////////////////////////////////////////////////////////
        show: isSideShow,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: isCategorie,
                maintainState: true,
                child: Column(
                  children: [
                     Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 90,
                            height: 90,
                            child: Tooltip(
                              message: 'Ajouter une catégorie',
                              child: Button(
                               child: const Icon(FluentIcons.add,
                               size: 20,),
                                onPressed: () => showCatAdd(context),
                                ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 90,
                            height: 90,
                            child: Tooltip(
                              message: 'Voir la liste de produits',
                              child: Button(
                               child: const Icon(FluentIcons.database_view,
                               size: 20,),
                                onPressed: () {
                                  changeCategorieScreen();
                                  setState(() {
                                    isSideShow = false;
                                  });
                                  },
                                ),
                            ),
                          ),
                        ),
                      ],
                     ),///////////////////////////
      
      
         StreamBuilder<List<Categorie>>(
        stream: fetchAllCategorie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
        final categoryList = snapshot.data!;
      
        return Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        height: 400,
        //height: double.infinity,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent: 140,
                maxCrossAxisExtent: 140,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemCount: CategorieBox2!.count(),
            itemBuilder: ((context, index) {
              final category = categoryList[index];
              final produitCount = category.produit.length;
              return Button(
                onPressed: () {
                  setState(() {
                selectedCategory = category;
                isSideShow = true;
              });
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Expanded(
                          child: Center(
                            child: AutoSizeText(
                                               '$produitCount',
                                               style: const TextStyle(fontSize: 40),
                                                maxLines: 1,
                                                ),
                          )),
                      Text(
                        category.nom,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              );
            })),
          );
          } else if (snapshot.hasError) {
        return Text('Erreur lors de la récupération des catégories.');
          } else {
        return ProgressRing();
          }
        },
      )
      
                  ],
                )),
                //////////////////////////////////////////////////////////////////////////
              Visibility(
                visible: isProduct,
                maintainState: true,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                    ),
                    
                    Table(
                     border: TableBorder.all(
                      width: 1,
                      color: Colors.grey.withOpacity(0.6),
                      ),
                     children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          backgroundBlendMode: BlendMode.darken,
                          shape: BoxShape.rectangle,
                        ),
                       children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                          child: Text('Code', style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                          child: Text('Nom', style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                          child: Text('Prix en Fcfa', style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                          child: Text('Quantité/Stock', style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                          child: Text('Catégorie', style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                          child: Text('Fournisseur', style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                       ],
                      ),
                    
                      // snapshot.data.map((e) => TableRow(
                      //   children: [
                      //    Padding(
                      //     padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                      //     child: Text(e.code, style: TextStyle(fontWeight: FontWeight.bold),),
                      //   ), 
                      //   ]
                      // )).toList()
                      
                     ],
                    ),
                    StreamBuilder <List<Produits>> (
                stream: fetchAllProduits,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                return ProgressRing();
                  } else if (snapshot.hasError) {
                return Text('Une erreur s\'est produite : ${snapshot.error}');
                  } else {
                final prod = snapshot.data ?? [];
                    
                return
                    Table(
                      border: TableBorder.all(
                      width: 1,
                      color: Colors.grey.withOpacity(0.6),
                      ),
                      children: snapshot.data!.reversed.toList().map(
                      (e) => TableRow(
                         decoration: const BoxDecoration(
                          //color: Colors.grey.withOpacity(0.2),
                          //backgroundBlendMode: BlendMode.darken,
                          shape: BoxShape.rectangle, ),
                        children: 
                         [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                            child: Text(e.code),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                            child: Text(e.nom),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                            child: Text(e.prix.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                            child: Text(e.quantite.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                            child: Text(e.categorie.target?.nom ?? 'Inconnue'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                            child: Text('Aucun'),
                          ),
                          ]
                      )
                      ).toList()
                    );
                 }
                },
                    ),
                    
                    ///////////////////////////////////////////////////////////////////////
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
