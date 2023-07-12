
class PostList {
  late String idBuku ;
  late String judul;
  late String penerbit;
  late String pengarang;
  late String price;
  late String priceBuku;
  late String diskon;
  late String netPrice;
  late String potonganHarga;
  late String hargaJual;
  late String tahun;
  late String description; 
  late String imageBook;
  late String idUserInputBuku;
  late String dateUserInputBuku;
  late String message;
  late String value;  
  late String valueImage;  

  late String idStock; 
  late String idBook; 
  late String qtyGr; 
  late String dateGr; 
  late String noNote; 
  late String idUserInputStock; 
  late String dateUserInputStock; 

  late String idUser;
  late String name;
  late String username;
  late String password;
  late String address;  
  late String level;    
  late String email; 
  late String noTelp;    
  late String token; 

  late String totalQtyGr;

  late String idTransaction;
  late String qtyPick; 
  late String codeTransaction; 
  late String dateTransaction;
  late String totalPayment;      
  late String stateTransaction;     
  late String alamat;     

  PostList({
    required this.idBuku,
    required this.judul,
    required this.penerbit,
    required this.pengarang,
    required this.price,
    required this.priceBuku,
    required this.diskon,
    required this.netPrice,
    required this.potonganHarga,
    required this.hargaJual,
    required this.tahun,
    required this.description,
    required this.imageBook,
    required this.idUserInputBuku,
    required this.dateUserInputBuku,
    required this.message,
    required this.value,    
    required this.valueImage, 

    required this.idStock,
    required this.idBook,
    required this.qtyGr,
    required this.dateGr,
    required this.noNote,  
    required this.idUserInputStock,    
    required this.dateUserInputStock, 

    required this.idUser,
    required this.name,
    required this.username,
    required this.password,
    required this.address,  
    required this.level,    
    required this.email, 
    required this.noTelp,    
    required this.token, 

    required this.totalQtyGr, 

    required this.idTransaction,
    required this.qtyPick, 
    required this.codeTransaction, 
    required this.dateTransaction,
    required this.totalPayment,      
    required this.stateTransaction,     
    required this.alamat,     
  });

  factory PostList.fromJsons(Map<String,dynamic> json){
    return PostList(
      idBuku:json['id_buku'] ?? "", 
      judul: json['judul'] ?? "", 
      penerbit: json['penerbit'] ?? "",
      pengarang: json['pengarang'] ?? "",
      price: json['price'] ?? "",
      priceBuku: json['price_buku'] ?? "",
      diskon: json['diskon'] ?? "",
      netPrice: json['net_price'] ?? "",
      potonganHarga: json['potongan_harga'] ?? "",
      hargaJual: json['harga_jual'] ?? "",
      tahun: json['tahun'] ?? "",
      description: json['description'] ?? "",
      imageBook: json['image_book'] ?? "",
      idUserInputBuku: json['id_user_input_buku'] ?? "", 
      dateUserInputBuku: json['date_user_input_buku'] ?? "",
      message: json['message'] ?? "", 
      value: json['value'] ?? "",
      valueImage: json['value_image'] ?? "",

      idStock: json['id_stock'] ?? "",
      idBook: json['id_book'] ?? "", 
      qtyGr: json['qty_gr'] ?? "",
      dateGr: json['date_gr'] ?? "", 
      noNote: json['no_note'] ?? "",
      idUserInputStock: json['id_user_input_stock'] ?? "",      
      dateUserInputStock: json['date_user_input_stock'] ?? "",     

      idUser: json['id_user'] ?? "",
      name: json['name'] ?? "", 
      username: json['username'] ?? "",
      password: json['password'] ?? "", 
      address: json['address'] ?? "",
      level: json['level'] ?? "",      
      email: json['email'] ?? "",     
      noTelp: json['no_telp'] ?? "",  
      token: json['token'] ?? "",   

      totalQtyGr: json['total_qty_gr'] ?? "",   

      idTransaction: json['id_transaction'] ?? "",
      qtyPick: json['qty_pick'] ?? "", 
      codeTransaction: json['code_transaction'] ?? "", 
      dateTransaction: json['date_transaction'] ?? "",
      totalPayment: json['total_payment'] ?? "",      
      stateTransaction: json['state_transaction'] ?? "",     
      alamat: json['alamat'] ?? "",         

      );
  }
  
}