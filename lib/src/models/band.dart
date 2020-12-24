

class Band {

  String id;
  String name;
  int votes;

  Band({
    this.id,
    this.name,
    this.votes
  });

  //Crear objetos a partir del map recibido del backend
  factory Band.fromMap( Map<String, dynamic> obj) 
    => Band(
      id: obj["id"],
      name: obj["name"],
      votes: obj["votes"],
    );

}