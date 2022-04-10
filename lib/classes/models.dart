import 'live_match_model.dart';

class DataRefreshRequest {
  DataRefreshRequest.fromJson(Map<String, dynamic> data) {
    accessToken = convertData(data, 'accessToken', DataType.string);
    refreshToken = convertData(data, 'refreshToken', DataType.string);
  }

  String? accessToken;
  String? refreshToken;
}

class DataProfileMediaType {
  DataProfileMediaType.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    media = convertData(data, 'media', DataType.string);
    personalInformationId = convertData(data, 'personalInformationId', DataType.string);
  }

  late String id;
  String? media;
  late String personalInformationId;
}

class DataTeam {
  DataTeam.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    team_key = convertData(data, 'team_key', DataType.string);
    team_name = convertData(data, 'team_name', DataType.string);
    team_badge = convertData(data, 'team_badge', DataType.string);
    team_country = convertData(data, 'team_country', DataType.string);
  }

  late String id;
  String? team_badge;
  String? team_country;
  String? team_key;
  String? team_name;
}

class DataPostLike {
  DataPostLike.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    userId = convertData(data, 'userId', DataType.string);
  }
  DataPostLike(this.id, this.userId);
  late String id;
  late String userId;
}

class DataCommentLike {
  DataCommentLike.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    personalInformationId = convertData(data, 'personalInformationId', DataType.string);
  }

  DataCommentLike(this.id, this.personalInformationId);

  late String id;
  late String personalInformationId;
}

//0 9938284270
class DataReplyLike {
  DataReplyLike.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    personalInformationId = convertData(data, 'personalInformationId', DataType.string);
  }
  DataReplyLike(this.id, this.personalInformationId);
  late String id;
  late String personalInformationId;
}

class DataPersonalInformationViewModel {
  DataPersonalInformationViewModel.fromJson(Map<String, dynamic> data) {
    personalInformationId = convertData(data, 'personalInformationId', DataType.string);
    userName = convertData(data, 'userName', DataType.string);
    fullName = convertData(data, 'fullName', DataType.string);
    team = convertData(data, 'team', DataType.clas, classType: 'DataTeam');
    notificationToken = convertData(data, 'notificationToken', DataType.string);
    profilePhoto = convertData(data, 'profilePhoto', DataType.string);
  }

  String? fullName;
  String? profilePhoto;
  String? notificationToken;
  late String personalInformationId;
  DataTeam? team;
  late String userName;
}

class DataCommentReply {
  DataCommentReply.fromJson(Map<String, dynamic> data) {
    createdAt = convertData(data, 'createdAt', DataType.datetime);
    editeddAt = convertData(data, 'editeddAt', DataType.datetime);
    id = convertData(data, 'id', DataType.string);
    personalInformationId = convertData(data, 'personalInformationId', DataType.string);
    personalInformationViewModel =
        convertData(data, 'personalInformationViewModel', DataType.clas, classType: 'DataPersonalInformationViewModel');
    postCommentId = convertData(data, 'postCommentId', DataType.string);
    replyDetail = convertData(data, 'replyDetail', DataType.string);
    replyLikeCount = convertData(data, 'replyLikeCount', DataType.int);
    replyLikedBythisUser = convertData(data, 'replyLikedBythisUser', DataType.bool);
    replyLikes = convertDataList<DataReplyLike>(data, 'replyLikes', 'DataReplyLike');
  }

  late DateTime createdAt;
  DateTime? editeddAt;
  late String id;
  late String personalInformationId;
  late DataPersonalInformationViewModel personalInformationViewModel;
  late String postCommentId;
  String? replyDetail;
  late int replyLikeCount;
  late bool replyLikedBythisUser;
  List<DataReplyLike> replyLikes = [];
}

class DataPostComment {
  DataPostComment.fromJson(Map<String, dynamic> data) {
    comment = convertData(data, 'comment', DataType.string);
    commentLikeCount = convertData(data, 'commentLikeCount', DataType.int);
    commentLikedBythisUser = convertData(data, 'commentLikedBythisUser', DataType.bool);
    commentLikes = convertDataList<DataCommentLike>(data, 'commentLikes', 'DataCommentLike');
    commentReplies = convertDataList<DataCommentReply>(data, 'commentReplies', 'DataCommentReply');
    commentReplyCount = convertData(data, 'commentReplyCount', DataType.int);
    createdAt = convertData(data, 'createdAt', DataType.datetime);
    editedAt = convertData(data, 'editedAt', DataType.datetime);
    id = convertData(data, 'id', DataType.string);
    personalInformationId = convertData(data, 'personalInformationId', DataType.string);
    personalInformationViewModel =
        convertData(data, 'personalInformationViewModel', DataType.clas, classType: 'DataPersonalInformationViewModel');
    postId = convertData(data, 'postId', DataType.string);
  }

  String? comment;
  late int commentLikeCount;
  late bool commentLikedBythisUser;
  late List<DataCommentLike> commentLikes;
  late List<DataCommentReply> commentReplies;
  late int commentReplyCount;
  late DateTime createdAt;
  DateTime? editedAt;
  late String id;
  late String personalInformationId;
  late DataPersonalInformationViewModel personalInformationViewModel;
  late String postId;
}

class DataMediaType {
  DataMediaType.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    media = convertData(data, 'media', DataType.string);
    postId = convertData(data, 'postId', DataType.string);
  }

  late String id;
  late String media;
  late String postId;
}

class DataPost {
  DataPost.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    details = convertData(data, 'details', DataType.string);
    engagement = convertData(data, 'engagement', DataType.int);
    reach = convertData(data, 'reach', DataType.int);
    shares = convertData(data, 'shares', DataType.int);
    profileClicks = convertData(data, 'profileClicks', DataType.int);
    createdAt = convertData(data, 'createdAt', DataType.datetime);
    postLikes = convertDataList<DataPostLike>(data, 'postLikes', 'DataPostLike');
    postComments = convertDataList<DataPostComment>(data, 'postComments', 'DataPostComment');
    mediaTypes = convertDataList<DataMediaType>(data, 'mediaTypes', 'DataMediaType');
    isEdited = convertData(data, 'isEdited', DataType.bool);
    postLikeCount = convertData(data, 'postLikeCount', DataType.int);
    postCommentCount = convertData(data, 'postCommentCount', DataType.int);
    person =
        convertData(data, 'personalInformationViewModel', DataType.clas, classType: 'DataPersonalInformationViewModel');
    postLikedBythisUser = convertData(data, 'postLikedBythisUser', DataType.bool);
  }

  late DateTime createdAt;
  String? details;
  late int engagement;
  late String id;
  late bool isEdited;
  late List<DataMediaType> mediaTypes;
  DataPersonalInformationViewModel? person;
  late int postCommentCount;
  late List<DataPostComment> postComments;
  late int postLikeCount;
  late bool postLikedBythisUser;
  late List<DataPostLike> postLikes;
  late int profileClicks;
  late int reach;
  late int shares;
}

class DataUserFollower {
  DataUserFollower.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    followingId = convertData(data, 'followingId', DataType.string);
    personalInformationViewModel =
        convertData(data, 'personalInformationViewModel', DataType.clas, classType: 'DataPersonalInformationViewModel');
    followByMe = convertData(data, 'followByMe', DataType.bool);
  }

  late String followingId;
  late bool followByMe;
  late String id;
  late DataPersonalInformationViewModel personalInformationViewModel;
}

class DataUserFollowing {
  DataUserFollowing.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    personalInformationViewModel =
        convertData(data, 'personalInformationViewModel', DataType.clas, classType: 'DataPersonalInformationViewModel');
    followedByMe = convertData(data, 'followedByMe', DataType.bool);
  }

  late bool? followedByMe;
  late String id;
  late DataPersonalInformationViewModel personalInformationViewModel;
}

class DataNotification {
  DataNotification.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    personalInformationId = convertData(data, 'personalInformationId', DataType.string);
    notificationMessage = convertData(data, 'notificationMessage', DataType.string);
    notificationMedia = convertData(data, 'notificationMedia', DataType.string);
    notificationTitle = convertData(data, 'notificationTitle', DataType.string);
    timeStamp = convertData(data, 'timeStamp', DataType.string);
    event = convertData(data, 'event', DataType.string);
    personalInformationViewModel =
        convertData(data, 'personalInformationViewModel', DataType.clas, classType: 'DataPersonalInformationViewModel');
  }

  String? event;
  late String id;
  String? notificationMedia;
  String? notificationMessage;
  String? notificationTitle;
  late String personalInformationId;
  late DataPersonalInformationViewModel personalInformationViewModel;
  late String timeStamp;

  String? kind; //'privateChat',  'shot',  'user',  null
  String? data; //'privateChatId','shotId','userId',null
}

class DataShortVideoStory {
  DataShortVideoStory.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    mediaURL = convertData(data, 'mediaURL', DataType.string);
    mimeType = convertData(data, 'mimeType', DataType.string);
    personalInformationViewModel =
        convertData(data, 'personalInformationViewModel', DataType.clas, classType: 'DataPersonalInformationViewModel');
    seenStatus = convertData(data, 'seenStatus', DataType.bool);
  }

  late String id;
  String? mediaURL;
  String? mimeType;
  late DataPersonalInformationViewModel personalInformationViewModel;
  late bool seenStatus;
}

class DataPersonalInformation {
  DataPersonalInformation.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    userName = convertData(data, 'userName', DataType.string);
    fullName = convertData(data, 'fullName', DataType.string);
    email = convertData(data, 'email', DataType.string);
    phoneNumber = convertData(data, 'phoneNumber', DataType.string);
    profilePhoto = convertData(data, 'profilePhoto', DataType.string);
    isOnline = convertData(data, 'isOnline', DataType.bool);
    is2FA = convertData(data, 'is2FA', DataType.bool);
    team = convertData(data, 'team', DataType.clas, classType: 'DataTeam');
    followersCount = convertData(data, 'followersCount', DataType.int);
    followingCount = convertData(data, 'followingCount', DataType.int);
    postCount = convertData(data, 'postCount', DataType.int);
    followingMe = convertData(data, 'followingMe', DataType.bool);
    followedByMe = convertData(data, 'followedByMe', DataType.bool);
    posts = convertDataList<DataPost>(data, 'posts', 'DataPost');
    userFollowers = convertDataList<DataUserFollower>(data, 'userFollowers', 'DataUserFollower');
    // userFollowings = convertDataList<DataUserFollowing>(
    //     data, 'userFollowings', 'DataUserFollowing');
  }

  String? email;
  late bool followedByMe;
  late int followersCount;
  late int followingCount;
  late bool followingMe;
  String? fullName;
  late String id;
  late bool is2FA;
  late bool isOnline;
  String? phoneNumber;
  late int postCount;
  List<DataPost> posts = [];
  String? profilePhoto;
  DataTeam? team;
  List<DataUserFollower> userFollowers = [];
  // List<DataUserFollowing?> userFollowings = [];
  late String userName;
}

class DataChatMessage {
  DataChatMessage.fromJson(Map<String, dynamic> data) {
    chatRoom = convertData(data, 'chatRoom', DataType.clas, classType: 'DataChatRoom');
    // chatRoomId=convertData(data, 'chatRoomId', DataType.string);
    id = convertData(data, 'id', DataType.string);
    name = convertData(data, 'name', DataType.string);
    text = convertData(data, 'text', DataType.string);
    timeStamp = convertData(data, 'timeStamp', DataType.datetime);
  }

  DataChatRoom? chatRoom;
  late String id;
  String? name;
  String? text;
  late DateTime timeStamp;
}

class DataChatRoom {
  DataChatRoom.fromJson(Map<String, dynamic> data) {
    chatMessages = convertDataList<DataChatMessage>(data, 'chatMessages', 'DataChatMessage');
    id = convertData(data, 'id', DataType.string);
    personalInformations = convertDataList<DataChatRoomUser>(data, 'personalInformations', 'DataChatRoomUser');
  }

  List<DataChatMessage> chatMessages = [];
  late String id;
  List<DataChatRoomUser> personalInformations = [];
}

class DataChatRoomUser {
  DataChatRoomUser.fromJson(Map<String, dynamic> data) {
    personalInformation = convertData(data, 'personalInformation', DataType.clas, classType: 'DataPersonalInformation');
  }

  DataPersonalInformation? personalInformation;
}

///---------------------------------------------

class DataStoryUser {
  late DataPersonalInformationViewModel person;
  List<DataStory> seen = [];
  List<DataStory> notSeen = [];
  late bool isAllSeen;

  DataStoryUser.fromList(List<DataStoryMain> data) {
    person = data.first.person;
    for (int j = 0; j < data.length; j++) {
      if (data[j].person.userName == 'emadhbasri') {
        print('id ${data[j].id} ${data[j].seenStatus}');
      }
      if (data[j].seenStatus) {
        seen.add(DataStory.fromStoryMain(data[j]));
      } else {
        notSeen.add(DataStory.fromStoryMain(data[j]));
      }
    }
    isAllSeen = notSeen.isEmpty;
  }
}

class DataStoryMain {
  late DataPersonalInformationViewModel person;
  late String id;
  late String mediaURL;
  late String mimeType;
  late bool seenStatus;
  DataStoryMain.fromJson(Map<String, dynamic> data) {
    person =
        convertData(data, 'personalInformationViewModel', DataType.clas, classType: 'DataPersonalInformationViewModel');
    id = convertData(data, 'id', DataType.string);
    mediaURL = convertData(data, 'mediaURL', DataType.string);
    mimeType = convertData(data, 'mimeType', DataType.string);
    seenStatus = convertData(data, 'seenStatus', DataType.bool);
  }
}

class DataStory {
  late String id;
  late String mediaURL;
  late String mimeType;
  late bool seenStatus;
  DataStory.fromStoryMain(DataStoryMain data) {
    id = data.id;
    mediaURL = data.mediaURL;
    mimeType = data.mimeType;
    seenStatus = data.seenStatus;
  }
}

enum DataType { datetime, int, double, string, bool, boolint, clas }

dynamic makeClass(Map<String, dynamic> data, String type) {
  switch (type) {
    case 'String':
      return data.toString();
    case 'DataRefreshRequest':
      return DataRefreshRequest.fromJson(data);
    case 'DataProfileMediaType':
      return DataProfileMediaType.fromJson(data);
    case 'DataTeam':
      return DataTeam.fromJson(data);
    case 'DataPostLike':
      return DataPostLike.fromJson(data);
    case 'DataCommentLike':
      return DataCommentLike.fromJson(data);
    case 'DataReplyLike':
      return DataReplyLike.fromJson(data);
    case 'DataPersonalInformationViewModel':
      return DataPersonalInformationViewModel.fromJson(data);
    case 'DataCommentReply':
      return DataCommentReply.fromJson(data);
    case 'DataPostComment':
      return DataPostComment.fromJson(data);
    case 'DataMediaType':
      return DataMediaType.fromJson(data);
    case 'DataPost':
      return DataPost.fromJson(data);
    case 'DataUserFollower':
      return DataUserFollower.fromJson(data);
    case 'DataUserFollowing':
      return DataUserFollowing.fromJson(data);
    case 'DataNotification':
      return DataNotification.fromJson(data);
    case 'DataShortVideoStory':
      return DataShortVideoStory.fromJson(data);
    case 'DataPersonalInformation':
      return DataPersonalInformation.fromJson(data);
    case 'DataChatMessage':
      return DataChatMessage.fromJson(data);
    case 'DataChatRoom':
      return DataChatRoom.fromJson(data);
    case 'DataChatRoomUser':
      return DataChatRoomUser.fromJson(data);
    case 'DataStoryMain':
      return DataStoryMain.fromJson(data);

    ///------------------------------------------
    case 'DataCountry':
      return DataCountry.fromJson(data);
    case 'DataLeague':
      return DataLeague.fromJson(data);
    case 'DataLeagueMain':
      return DataLeagueMain.fromJson(data);
    case 'DataMatch1':
      return DataMatch1.fromJson(data);
    case 'DataFixture':
      return DataFixture.fromJson(data);
    case 'DataMatchTeam':
      return DataMatchTeam.fromJson(data);
    case 'DataStatistics':
      return DataStatistics.fromJson(data);
    case 'DataEvent':
      return DataEvent.fromJson(data);
    case 'DataLineUps':
      return DataLineUps.fromJson(data);
    case 'DataPlayer':
      return DataPlayer.fromJson(data);
  }
}

List<Type> convertDataList<Type>(Map<String, dynamic> data, String key, String classType) {
  if (data.containsKey(key) == false || data[key] == null || data[key].isEmpty) {
    return [];
  } else {
    List<Type> temp = [];
    for (int j = 0; j < data[key].length; j++) {
      temp.add(makeClass(data[key][j], classType));
    }
    return temp;
  }
}

dynamic convertData<Type>(Map<String, dynamic> data, String key, DataType type,
    {bool haveTo = false, String? classType}) {
  switch (type) {
    case DataType.clas:
      if (data.containsKey(key) == false || data[key] == null) {
        return null;
      } else {
        return makeClass(data[key], classType!);
      }
    case DataType.datetime:
      if (data.containsKey(key) == false || data[key] == null) {
        return !haveTo ? null : DateTime.now();
      } else {
        DateTime? dd = DateTime.tryParse(data[key].toString());
        return dd ?? DateTime.now();
      }
    case DataType.int:
      if (data.containsKey(key) == false || data[key] == null) {
        return !haveTo ? null : 0;
      } else {
        return int.parse(data[key].toString());
      }
    case DataType.double:
      if (data.containsKey(key) == false || data[key] == null) {
        return !haveTo ? null : 0.0;
      } else {
        return double.parse(data[key].toString());
      }
    case DataType.string:
      if (data.containsKey(key) == false || data[key] == null) {
        return !haveTo ? null : '';
      } else {
        return data[key].toString();
      }
    case DataType.bool:
      if (data.containsKey(key) == false || data[key] == null) {
        return !haveTo ? null : false;
      } else {
        return data[key];
      }
    case DataType.boolint:
      if (data.containsKey(key) == false || data[key] == null) {
        return !haveTo ? null : false;
      } else {
        return int.parse(data[key].toString()) == 1 ? true : false;
      }
  }
}
