class Note{
  String? note , id , img;
  Note({ this.note ,  this.id,this.img});
  Note.fromJSON ({Map<String,dynamic>? note}){}

  toJSON(){
    return ({"id": id, "note" : note , "img" :img });
  }
}