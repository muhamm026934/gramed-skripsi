
class PostList {
  late String idBuku ;
  late String judul;
  late String penerbit;
  late String tahun;
  late String description; 
  late String imageBook;
  late String idUserInputBuku;
  late String dateUserInputBuku;
  late String message;
  late String value;  
  late String valueImage;  
  PostList({
    required this.idBuku,
    required this.judul,
    required this.penerbit,
    required this.tahun,
    required this.description,
    required this.imageBook,
    required this.idUserInputBuku,
    required this.dateUserInputBuku,
    required this.message,
    required this.value,    
    required this.valueImage, 
  });

  factory PostList.fromJsons(Map<String,dynamic> json){
    return PostList(
      idBuku:json['id_buku'] ?? "", 
      judul: json['judul'] ?? "", 
      penerbit: json['penerbit'] ?? "",
      tahun: json['tahun'] ?? "",
      description: json['description'] ?? "",
      imageBook: json['image_book'] ?? "",
      idUserInputBuku: json['id_user_input_buku'] ?? "", 
      dateUserInputBuku: json['date_user_input_buku'] ?? "",
      message: json['message'] ?? "", 
      value: json['value'] ?? "",
      valueImage: json['value_image'] ?? "",
      );
  }
  
}