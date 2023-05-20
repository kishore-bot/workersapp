extension StringExtentions on String{
   bool emailValid (){
   return  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(this);
  }
  bool isWhitespace()=>trim().isEmpty;
  bool isValidDouble()=>double.tryParse(this)!=null;
  bool isValidInt()=>int.tryParse(this)!=null;
}