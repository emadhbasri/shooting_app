
List<Post> posts = [
  Post(1, 'images/158023.png', 'images/unnamed.png', 'Mason Moreno', 'masonmoreno', 2, '@liverpool What is the loop of #YNWA ? How is there something from nothing? In spite of the fact that it is impossible to prove that anything', null, null, null, null, 1, 1),
  Post(2, 'images/158023.png', 'images/unnamed.png', 'Mason Moreno', 'masonmoreno', 2, 'What is the loop of #Creation ? How is there something from nothing? '
      'In spite of the fact that it is impossible to prove that anythin...', 'images/1668011.jpg', null, null, null, 1, 1),
  Post(3, 'images/158023.png', 'images/unnamed.png', 'Mason Moreno', 'masonmoreno', 2,
      'What is the loop of Creation? How is there something from nothing?', null, 'images/1668011.jpg', 'Complex Mag News!', 'What is the loop of #Creation ? How is there something from nothing? '
          'In spite of the fact that it is impossible to prove that anythin...', 1, 1),

  Post(4, 'images/158023.png', 'images/unnamed.png', 'Mason Moreno', 'masonmoreno', 2, 'What is the loop of #Creation ? How is there something from nothing? '
      'In spite of the fact that it is impossible to prove that anythin...', null, null, null, null, 1, 1),
  Post(5, 'images/158023.png', 'images/unnamed.png', 'Mason Moreno', 'masonmoreno', 2, 'What is the loop of #Creation ? How is there something from nothing? '
      'In spite of the fact that it is impossible to prove that anythin...', 'images/1668011.jpg', null, null, null, 1, 1),
  Post(6, 'images/158023.png', 'images/unnamed.png', 'Mason Moreno', 'masonmoreno', 2,
      'What is the loop of Creation? How is there something from nothing?', null, 'images/1668011.jpg', 'Complex Mag News!', 'What is the loop of #Creation ? How is there something from nothing? '
          'In spite of the fact that it is impossible to prove that anythin...', 1, 1),
];
class Post{
  final int id;
  final String imageProfile;
  final String imageTeam;
  final String name;
  final String username;
  final int sec;
  final String text;
  final String? videoImage;
  final String? image;
  final String? topic;
  final String? desc;
  final int commentCount;
  final int likeCount;
  bool isLiked=false;

  Post(this.id, this.imageProfile, this.imageTeam, this.name,
      this.username, this.sec, this.text, this.videoImage,
      this.image, this.topic, this.desc, this.commentCount, this.likeCount);
}