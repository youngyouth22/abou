import 'package:abou/main.dart';
import 'package:abou/providers/data/facture_data.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:iconsax/iconsax.dart';
import 'package:abou/objectbox.g.dart';
import 'package:provider/provider.dart';

import '../providers/data/local_facture.dart';
import '../providers/models/factures.dart';
import '../providers/models/produits.dart';

class Commande extends StatefulWidget {
  const Commande({Key? key}) : super(key: key);

  @override
  State<Commande> createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {

  Box<Produits> produitBox = objectbox.store.box<Produits>(); 
  Box<Produits>? produitBox2;
  Box<Facture> factureBox = objectbox.store.box<Facture>(); 
  Box<Produits>? factureBox2;
  
TextEditingController searchProduct = TextEditingController();
TextEditingController qteProduct = TextEditingController();
TextEditingController reduite = TextEditingController();
bool checked = false;


  
  String enteredCode = "";
  Produits? selectedProduct;
  Box<Produits>? ProduitBox;
 FocusNode? _focusNode;
 bool productFound = false;

 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProduitBox = objectbox.store.box<Produits>();
    _focusNode = FocusNode();
  }

   void _onKeyPressed(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      setState(() {
        productFound = false; // Réinitialiser la variable productFound à false
      });
      _focusNode?.requestFocus(); 
      searchProduct.clear(); // Effacer le texte du TextField
      
    }
  }

  void _cancelIcon() {
    
      setState(() {
        productFound = false; // Réinitialiser la variable productFound à false
      });
      _focusNode?.requestFocus(); 
      searchProduct.clear(); // Effacer le texte du TextField
  }

 
  Produits? getProductByCode(String code) {
    final product = ProduitBox?.query(Produits_.code.equals(code)).build().findFirst();
    if (product != null){setState(() {
      selectedProduct = product;
      productFound = true;
    });}
    else {
    setState(() {
      productFound = false; // Masquer les informations du produit
    });
  }

  return selectedProduct;
     
  }

  void addProduitTofacture(Facture facture, String code) {
  final produit = getProductByCode(code);
  if (produit != null) {
    facture.products.add(produit);
    factureBox.put(facture);
    print('Produit ajouté à la facture');
  } else {
    print('Aucun produit trouvé avec le code $code');
  }
}

  


  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: BodyWithSideSheet(
        sheetBody: ListCommande (),
        show: true,
        sheetWidth: 350,
        body: Center(
          child: SingleChildScrollView(
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: _onKeyPressed,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: productFound == false? true: false,
                    child: Padding(
                      padding: const EdgeInsets.all(78.0),
                      child: InfoLabel(
                        label: "Entrez le code du Produit",
                        labelStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        child: TextBox(
                          focusNode: _focusNode,
                          controller: searchProduct,
                          maxLength: 40,
                          keyboardType: TextInputType.name,
                          placeholder: 'Entrer le code',
                          onChanged: (value) {
                          enteredCode = value;
                         getProductByCode(searchProduct.text);
                         },
                          suffix: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Iconsax.search_normal,
                            color: Colors.white.withOpacity(0.7),),
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
            
              //     FilledButton(
              //   onPressed: () {
              //     setState(() {
              //       FocusScope.of(context).requestFocus(_focusNode);
              //     });
              //   },
              //   child: Text('Focus'),
              // ),
            
              //if(productFound == true)Text('trouve...'),
                      
                   SizedBox(height: 20.0),
                if(selectedProduct != null && productFound == true)
                    Container(
                      width: 450,
                      // child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text('Nom du produit: ${selectedProduct!.nom}'),
                      //       Text('Prix: ${selectedProduct!.prix}'),
                      //     ],
                      //   ),
                      child: Column(
                        children: [
                          
                          Container(
                            width: double.infinity,
                            color: Colors.blue.light,
                            height: 50,
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                IconButton(icon: const Icon(FluentIcons.calculator_multiply,
                                size: 24), 
                                onPressed: _cancelIcon),
                              ],
                            ),
                          ),

                          Table(
                            children: [
                              TableRow(
                                children: [
                                 const Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text('Nom :',
                                    style:  TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:20.0, left:0, top: 20),
                                    child: Text('${selectedProduct!.nom}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400
                                    ),),
                                  ),
                                ]
                              ),

                              TableRow(
                                children: [
                                 const Padding(
                                   padding: EdgeInsets.only(left:20.0),
                                   child: Text('Prix :',
                                   style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.only(left:0.0),
                                   child: Text('${selectedProduct!.prix}',
                                   style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400
                                    ),),
                                 ),

                                ]
                              ),

                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 20.0, left: 20),
                                    child: Text('Quantité :',
                                    style:  TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0, left: 0),
                                    child: TextBox(
                                      controller: qteProduct,
                                      keyboardType: TextInputType.number,
                                      placeholder: '1',
                                    ),
                                  ),

                                ]
                              ),

                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 20.0, left: 20),
                                    child: Text('Réduire le prix :',
                                    style:  TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0, left: 0, ),
                                    child: Row(
                                      children: [
                                        ToggleSwitch(
                                        checked: checked,
                                         onChanged: (v) {
                                        setState(() {
                                          checked = v;
                                        });
                                         },
                                        ),
                                      ],
                                    ),
                                  )
                                 
                                ]
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:20.0, top: 20),
                            child: TextBox(
                              controller: reduite,
                              placeholder: 'Entrer la somme réduite',
                              enabled: checked,
                              style: const TextStyle(
                                fontSize: 18
                              ),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.only(top: 35),
                            child: FilledButton(
                            child: const Padding(
                              padding:  EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                              child:  Text('Entrer le produit',
                              style: TextStyle(
                                color: Colors.white
                              ),),
                            ),
                             onPressed: () {
                              LocalFacture invoice = LocalFacture(id: selectedProduct!.id, nom: selectedProduct!.nom, qte: qteProduct.text == ''? 1 : int.parse(qteProduct.text) , pu: checked ? double.parse(reduite.text) : selectedProduct!.prix,);
                              Provider.of<FactureData>(context, listen: false).
                              addItemsFacture(invoice);
                              print(Provider.of<FactureData>(context, listen: false).factureItems);
                              qteProduct.clear();
                              reduite.clear();
                              _cancelIcon();
                             },
                             ),
                          ),

                          Container(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('ou',
                                  style: TextStyle(
                                    fontSize: 16
                                  ),),
                                ),

                                Container(
                                  alignment: Alignment.center,
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                     const Text('Appuyer sur Entrer',
                                     style: TextStyle(
                                      fontSize: 18,
                                     ),),

                                     const SizedBox(width: 10,),

                                     Image.asset('assets/images/icons8-touche-entrée-50.png',
                                     width: 30,)
                                  ],)
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                    else const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class ListCommande extends StatelessWidget {
  const ListCommande({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15,),
          Table(
            columnWidths: const {
           0: FixedColumnWidth(120),
            1: FixedColumnWidth(60),
            2: FixedColumnWidth(94),
  },
            children: const [
              TableRow(
                children: 
                [Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text('Désignation',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                ),),
                ),

                Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text('Qté',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                ),),
                ),

                Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text('Pu',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                ),),
                ),

                Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text('Pt',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                ),),
                ),
                ]
              )
            ],
          ),

          Consumer<FactureData>(
                builder: (context, factureData, child) {
                  final factureItems = factureData.factureItems;
                  double totalAmount = factureItems.fold(0, (sum, facture) => sum + facture.pu);
                  return Column(
                    children: [
                      Table(
                        border: TableBorder.all(width: 1,
                        color: Colors.grey.withOpacity(0.7)),
                        columnWidths: const {
            0: FixedColumnWidth(120),
            1: FixedColumnWidth(60),
            2: FixedColumnWidth(94),
               },
                        children: factureItems.map((facture) {
                          return TableRow(
                            children: [
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(facture.nom,
                style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16
                ),),
                ),

                Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(facture.qte.toString(),
                style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16
                ),),
                ),

                Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(facture.pu.toString(),
                style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16
                ),),
                ),

                Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text('${facture.pu * facture.qte}',
                style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16
                ),),
                ),
                            ]
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 15,),

                      Consumer<FactureData>(
  builder: (context, factureData, child) {
    final factureItems = factureData.factureItems;
    double totalAmount = factureItems.fold(0, (sum, facture) => sum + (facture.pu * facture.qte));

    return Table(
      border: TableBorder.all(width: 1,
      color: Colors.grey.withOpacity(0.7)),
      children: [
        
        TableRow(
          children: [
            
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text('Prix total : $totalAmount Fcfa',
                style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20
                ),),
                ),
          ],
        ), // Affiche le prix total des produits
      ],
    );
  },
),

                    ],
                  );
                },
              ),
        ],
      ),
    );
  }
}