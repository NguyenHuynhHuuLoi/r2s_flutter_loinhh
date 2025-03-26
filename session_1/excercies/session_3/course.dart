class Course {
  late String code;
  late String name;
  late double duration;
  late String status;
  late String flag;

  // Default constructor
  Course() {}

  // Named constructor to initialize properties
  Course.initial(this.code, this.name, this.duration, this.status, this.flag);

  // Method to display course details
  void output() {
    print('Course Code: $code');
    print('Course Name: $name');
    print('Course Duration: $duration hours');
    print('Course Status: $status');
    print('Course Flag: $flag');
  }

  // Static method to find courses based on an attribute and its value
  static List<Course> find(List<Course> courses, String type, dynamic data) {
    return courses.where((course) {
      switch (type) {
        case 'code':
          return course.code == data;
        case 'name':
          return course.name == data;
        case 'status':
          return course.status == data;
        case 'flag':
          return course.flag == data;
        default:
          return false;
      }
    }).toList();
  }
}
