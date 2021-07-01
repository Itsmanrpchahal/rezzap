class ValidConstants {
  ValidConstants._();

  //PADDINGS
  static const double padding = 20;
  static const double avatarRadius = 45;

//TEXT FILED VALIDATIONS REGEX
  static bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool isUrl(String em) {
    String p = r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool isYouTubeUrl(String em) {
    String p =
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$";
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }
}

class Constant {
  // BASE URLS
  static var baseFolderUrl =
      "https://www.rezzap.com/uploads/personal-documents/";
  static var webBase = "https://www.rezzap.com/";
  static var imageUrl = "https://www.rezzap.com/uploads/profile-photo/";
  static var videoUrl = baseFolderUrl + "activity-videos/";
  static var activityPdfUrl = baseFolderUrl + "activity-pdfs/";
  static var activityWordUrl = baseFolderUrl + "activity-words/";
  static var pdfResumeD = webBase + "resume/download/";
  static var wordResumeD = webBase + "resume/download-word?id=";
  static var interestImageUrl = "https://www.rezzap.com/uploads/group-icon/";
  static var audioUrl = baseFolderUrl + "activity-audios/";

  static var personal = baseFolderUrl + "personal/";
  static var prefessional = baseFolderUrl + "professional/";
  static var academics = baseFolderUrl + "academic/";
  static var awards = baseFolderUrl + "awards/";
  static var other = baseFolderUrl + "other/";

  static var activityImageUrl =
      "https://www.rezzap.com/uploads/activity-images/";
  static var baseUrl = "https://www.rezzap.com/app/api/";
  static var placeHolderImage =
      "https://herbalforlife.co.uk/wp-content/uploads/2019/08/user-placeholder.png";
  static var nullImage =
      "https://burmunk.am/themes/burmunk/assets/no-product-image.png";
  static var braintreeNonce = "sandbox_v2mmss65_hphc259stpd35mhf";
  //POP UPS VALUE CONSTANTS
  static const String FirstItem = 'Facebook';
  static const String SecondItem = 'twitter';
  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
  ];

  static var accessToken = "";
  static const List<String> accountType = ["Individual", "The Spin"];
  static const List<String> designations = [
    "Student",
    "Parent",
    "College Counselor",
    "Admission-College",
    "Recruitor",
    "Company",
    "Coach"
  ];

  static const List<String> gender = ["Male", "Female", "Other"];

  static const List<String> colleges = [
    "All Colleges",
    "Dream Colleges",
  ];

  static const List<String> visibily = [
    "Public",
    "Private",
  ];

  static const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
}

class KeyConstants {
  // KEYS FOR PREFRENCES
  static const String userLoggedIn = 'userLoggedIn';
  static const String flowStarted = 'flowStarted';
  static const String token = 'access_token';
  static const String emailVerified = 'emailVerified';
  static const String email = 'email';
  static const String password = 'password';
  static const String rememberMe = 'rememberMe';
  static const String username = 'username';
  static const String account = 'account';
  static const String userId = 'userId';
  static const String resumeId = 'resumeId';
  static const String profilePic = 'profilePic';
  static const String subscriptions = 'subscriptions';
}
