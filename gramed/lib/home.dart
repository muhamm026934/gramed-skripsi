import 'package:flutter/material.dart';
import 'package:gramed/api/api.dart';
import 'package:gramed/api/postlist.dart';
import 'package:gramed/drawer.dart';
import 'package:gramed/page_routes.dart';
import 'package:gramed/service.dart';
import 'package:gramed/web_custom_scroll_behavior.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.session}) : super(key: key);
  final String session;

  @override
  State<Home> createState() => _HomeState();
}
class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}

class _HomeState extends State<Home> {

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPref();
    _getDataBuku("","","","","");
  }

  late String value = "";
  late String idUsersApp = "";
  late String name = "";
  late String username = "";
  late String password = "";
  late String address = "";
  late String level = "";
  late String email = "";
  late String noTelp = "";
  late String token = "";

  Future<void> _getPref() async {
    Service.getPref().then((preferences) {
      setState(() {
        value = preferences.getString('value');
        idUsersApp = preferences.getString('idUsersApp');
        name = preferences.getString('name');
        username = preferences.getString('username');
        password = preferences.getString('password');
        address = preferences.getString('address');
        level = preferences.getString('level');
        email = preferences.getString('email');
        noTelp = preferences.getString('noTelp');
        token = preferences.getString('token');
      });
    });
  }
  
  List<PostList?> _listBuku = [];
  bool _loading = false;
  _getDataBuku(action,idBuku,judulBuku,penerbit,tahun) async{
    setState(() {
      _loading = true;
    });
    Service.getDataBuku(action,idBuku,judulBuku,penerbit,tahun,idUsersApp).then((value) async {
      setState(() {
        _listBuku = value;
        _loading = false;
      });
    });
  }

 bool _openFormAdds = false;
 String tags = "",images ="",juduls ="",deskripsis = "",hargas ="",diskons ="",netHargas ="",potonganHargas = "";
 int qtyBeli = 1;
 String hargaJuals = "0";
 late int jmlBayar = qtyBeli * int.parse(hargaJuals);
 var jmlBayars = "";
  _openFormAdd(tag,openFormAdds,image,judul,deskripsi,harga, diskon, netHarga,potonganHarga,hargaJual){
    setState(() {
      _openFormAdds = openFormAdds;
      tags = tag;
      images = image;
      juduls = judul;
      deskripsis = deskripsi;
      hargas = harga;
      diskons = diskon;
      netHargas = netHarga;
      potonganHargas = potonganHarga;
      hargaJuals = hargaJual;
      qtyBeli = 1;
      jmlBayar = qtyBeli * int.parse(hargaJuals);
    });
  }

  _addFuntion(){
    setState(() {
      qtyBeli = qtyBeli + 1;
      jmlBayar = qtyBeli * int.parse(hargaJuals);
    });
  }
  _deductFuntion(){
    setState(() {
      if (qtyBeli > 1) {
       qtyBeli = qtyBeli - 1; 
       jmlBayar = qtyBeli * int.parse(hargaJuals);
      }else{
        qtyBeli;
        jmlBayar = qtyBeli * int.parse(hargaJuals);
      }
    });
  }
  _formAdd(){
    return GestureDetector(
      onTap: (){
        _openFormAdd(tags,false,images,juduls,deskripsis,hargas, diskons, netHargas,potonganHargas,hargaJuals);
      },
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height* 0.9,  
          color: Colors.black12,
          child: Card(
            child: Card(
                  color: Colors.blue,
                  child: Hero(tag: tags,
                  child: ListView(
                    children: [
                      Image.network(ApiUrl.viewImageBuku+images),
                      Text("Harga : $hargas",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                      Text("Diskon : $diskons % / $potonganHargas",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                      Text("Harga Setelah Diskon : $netHargas",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                      Text("Judul : $juduls",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                      Text("Deskripsi : $deskripsis",textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [                          
                          Card(
                            color: Colors.white,
                            child: IconButton(onPressed: (){
                              _deductFuntion();
                            }, icon: const Icon(Icons.remove),color: Colors.black,)),
                          Text("$qtyBeli",style: const TextStyle(fontSize: 18,color: Colors.white),),
                          Card(
                            color: Colors.white,
                            child: IconButton(onPressed: (){
                              _addFuntion();
                            }, icon: const Icon(Icons.add),color: Colors.black))
                        ],
                      ),           
                      Text(CurrencyFormat.convertToIdr(jmlBayar, 2),textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),           
                      Card(child: OutlinedButton.icon(onPressed: (){
                        PageRoutes.routeToWebViewPay(context);
                      }, icon: Icon(Icons.monetization_on), label: Text("Pembayaran"))),                   
                      Card(child: OutlinedButton.icon(onPressed: (){}, icon: Icon(Icons.add_shopping_cart_outlined), label: Text("Keranjang")))
                    ],
                  )),
                )
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.blue,
                shadowColor: Colors.blue,
                title: Container(
                  color: Colors.blue,
                  child: const TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      label: Text("Pencarian Judul Buku",style: TextStyle(fontSize: 10,color: Colors.white),),
                    ),                
                  ),
                ),
                expandedHeight: 300,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.only(top:100.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                                height: 400,
                                aspectRatio: 2.0,
                                viewportFraction: 0.8,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 5),
                                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                enlargeFactor: 0.3,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason){
                                  setState(() {
                                    _current = index;
                                  });
                                }
                            ),
                            items: _listBuku.map((index) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,                                    
                                        decoration: const BoxDecoration(
                                          color: Colors.blue
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(child: Padding(
                                              padding: const EdgeInsets.only(top:8.0),
                                              child: Image.network(ApiUrl.viewImageBuku+index!.imageBook),
                                            )),
                                            Align(
                                              child: Text(index.judul.toString(),textAlign: TextAlign.center, style:  const TextStyle(fontSize: 13.0,color: Colors.white),),
                                            )
                                          ],
                                        )
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _listBuku.asMap().entries.map((entry) {
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 10.0,
                                    height: 10.0,
                                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.black)
                                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                                        ),
                        ),
                      ],
                    ),
                  )
                ),
              ),
              SliverToBoxAdapter(
                child: ScrollConfiguration(
                  behavior: WebCustomScrollBehavior(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150.0,
                        child: ListView.builder(
                          itemCount: _listBuku.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index)=> 
                          Hero(
                            tag: _listBuku[index]!.idBook.toString(),
                            child: Card(
                              color: Colors.white,
                              child: Card(
                                color: Colors.blue,
                                child: Container(
                                  width: 150.0,
                                  margin: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Expanded(child: Image.network(ApiUrl.viewImageBuku+_listBuku[index]!.imageBook)),
                                        Text(_listBuku[index]!.judul.toString(),textAlign: TextAlign.center,style:const TextStyle(color: Colors.white,fontSize: 12.0)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),                  
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    tileColor: (index % 2 == 0) ? Colors.white : Colors.green[50],
                    title: Center(
                      child: Card(
                         color: Colors.blue,
                        child: 
                        GestureDetector(
                          onTap: (){
                            _openFormAdd(
                              _listBuku[index]!.idBook
                              ,true,
                              _listBuku[index]!.imageBook,
                              _listBuku[index]!.judul,
                              _listBuku[index]!.description,
                              _listBuku[index]!.price,
                              _listBuku[index]!.diskon,
                              _listBuku[index]!.netPrice,
                              _listBuku[index]!.potonganHarga,
                              _listBuku[index]!.hargaJual,
                              );
                          },
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(ApiUrl.viewImageBuku+_listBuku[index]!.imageBook),
                            ),
                            title: Text(_listBuku[index]!.hargaJual.toString(),
                              style: const TextStyle(
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ), //Text
                    ),
                  ), 
                  childCount: _listBuku.length,
                ),
              )
            ],
          ),
          _openFormAdds == true
          ?_formAdd()
          :Container(),
        ],
      ),
    );
  }
}