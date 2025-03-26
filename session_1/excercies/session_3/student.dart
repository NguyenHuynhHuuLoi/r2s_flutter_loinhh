class Student {
  late int id;
   late String name;
   late num mark1;
   late num mark2;
   late num mark3;

   Student() {}
   Student.intial(this.id, this.name, this.mark1, this.mark2, this.mark3);

   num total() {
     return mark1 + mark2 + mark3;
   }

   num average(){
     return total() / 3;
   }
}