class Student {
  late int id;
   late String name;
   late num mark1;
   late num mark2;
   late num mark3;

   num total() {
     return mark1 + mark2 + mark3;
   }

   num average(){
     return total() / 3;
   }
}