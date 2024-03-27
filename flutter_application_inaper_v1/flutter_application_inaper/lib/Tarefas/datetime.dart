class Time {

final day = DateTime.now().day;
  final month = DateTime.now().month;
  final year = DateTime.now().year;
  final hora = DateTime.now().hour;
  final minuto = DateTime.now().minute;
 
 getminuto(){
  if (minuto <= 9) {
    return '0$minuto';
  } else {
    return '$minuto';
  }
 }

getdatetime(){
  return '$day/$month/$year Hora: $hora:${getminuto()}';
}
  
  }