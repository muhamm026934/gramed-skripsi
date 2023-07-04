import 'package:flutter/material.dart';
import 'package:gramed/drawer.dart';
import 'package:gramed/service.dart';
import 'package:gramed/web_custom_scroll_behavior.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.session}) : super(key: key);
  final String session;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPref();
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
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(),
      body: CustomScrollView(
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
                  label: Text("Pencarian Judul Buku, Pengarang dan Penerbit",style: TextStyle(fontSize: 10,color: Colors.white),),
                ),                
              ),
            ),
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top:60.0),
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
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                        items: [1,2,3,4,5].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.orange
                                ),
                                child: Text('text $i', style: TextStyle(fontSize: 16.0),)
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
                      children: [1,2,3,4,5].asMap().entries.map((entry) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Expanded(
                              flex: 1,
                              child: Container(
                                width: 10.0,
                                height: 10.0,
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
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
              child: Container(
                height: 150.0,
                child: ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index)=> 
                  Card(
                    color: Colors.blue,
                    child: Container(
                      width: 100.0,
                      margin: const EdgeInsets.all(10),
                      child: Center(
                        child: Text("Buku $index"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                tileColor: (index % 2 == 0) ? Colors.white : Colors.green[50],
                title: Center(
                  child: Text('$index',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 50,
                          color: Colors.greenAccent[400])
                      ), //Text
                ),
              ), 
              childCount: 51,
            ),
          )
        ],
      ),
    );
  }
}