class ApiPath {
  static const baseURL = 'https://8751-14-139-162-2.ngrok-free.app';

  static login() => '$baseURL/user/login/';

  static signup() => '$baseURL/user/signup/';

  static createPost() => '$baseURL/post/create/';

  static listPost() => '$baseURL/post/';

  static getPost(int id) => '$baseURL/post/$id';

  static updatePost() => '$baseURL/post/update/';

  static deletePost() => '$baseURL/post/delete';

  static uploadImage() => '$baseURL/azure/upload';

  static getProfiles() => '$baseURL/match/get';

  static swipeResult() => '$baseURL/match/swipe';
}
