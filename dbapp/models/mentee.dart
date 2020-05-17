
class Mentee{
  String name;
  int year;
  String email;
  int rollNo;
  String branch;
  int contact;
  String linkedInURL;
  String githubURL;
  String profilePic;
  List<String> domains = List<String>();
  bool hosteller;
  List<String> languages=List<String>();

  Mentee({this.name,this.year,this.email,this.rollNo,this.branch,this.contact,this.linkedInURL,this.githubURL,this.domains,this.hosteller,this.languages});
}