import 'package:flutter/material.dart';

import 'live_match_model.dart';

///
///
///
///
///

class DataCreateRoleDTO {
  DataCreateRoleDTO.fromJson(Map<String, dynamic> data) {
    roleName = convertData(data, 'roleName', DataType.string);
  }

  late String roleName;
}

class DataEditUserDTO {
  DataEditUserDTO.fromJson(Map<String, dynamic> data) {
    userName = convertData(data, 'userName', DataType.string);
    fullName = convertData(data, 'fullName', DataType.string);
    email = convertData(data, 'email', DataType.string);
    bio = convertData(data, 'bio', DataType.string);
    location = convertData(data, 'location', DataType.string);
    dob = convertData(data, 'dob=', DataType.datetime);
  }

  String? bio;
  late DateTime dob;
  late String email;
  String? fullName;
  String? location;
  late String userName;
}

class DataUpdateIsProfileLock {
  DataUpdateIsProfileLock.fromJson(Map<String, dynamic> data) {
    isProfileLocked = convertData(data, 'isProfileLocked', DataType.bool);
  }

  late bool isProfileLocked;
}

class DataUpdateProfileBlock {
  DataUpdateProfileBlock.fromJson(Map<String, dynamic> data) {
    isBlockedByAdmin = convertData(data, 'isBlockedByAdmin', DataType.bool);
  }

  late bool isBlockedByAdmin;
}

class DataUpdate2FADTO {
  DataUpdate2FADTO.fromJson(Map<String, dynamic> data) {
    is2FA = convertData(data, 'is2FA', DataType.bool);
  }

  late bool is2FA;
}

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
    personalInformationId =
        convertData(data, 'personalInformationId', DataType.string);
  }

  late String id; //($uuid)
  String? media;
  late String personalInformationId; //($uuid)
}

class DataTeam {
  DataTeam.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    team_key = convertData(data, 'team_key', DataType.string);
    team_name = convertData(data, 'team_name', DataType.string);
    team_badge = convertData(data, 'team_badge', DataType.string);
    team_country = convertData(data, 'team_country', DataType.string);
  }

  late String id; //;
  String? team_badge;
  String? team_country;
  String? team_key;
  String? team_name;
}

class DataPostLike {
  DataPostLike.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    userId = convertData(data, 'userId', DataType.string);
    postId = convertData(data, 'postId', DataType.string);
  }

  late String id; //($uuid)
  late String postId; //($uuid)
  late String userId; //($uuid)
}

class DataCommentLike {
  DataCommentLike.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    personalInformationId =
        convertData(data, 'personalInformationId', DataType.string);
    postCommentId = convertData(data, 'postCommentId', DataType.string);
  }

  late String id; //($uuid)
  late String personalInformationId; //($uuid)
  late String postCommentId; //($uuid)
}

class DataReplyLike {
  DataReplyLike.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    personalInformationId =
        convertData(data, 'personalInformationId', DataType.string);
    commentReplyId = convertData(data, 'commentReplyId', DataType.string);
  }

  late String commentReplyId; //($uuid)
  late String id; //($uuid)
  late String personalInformationId; //($uuid)
}

class DataCommentReplyMediaType {
  DataCommentReplyMediaType.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    media = convertData(data, 'media', DataType.string);
    commentReplyId = convertData(data, 'commentReplyId', DataType.string);
  }

  late String commentReplyId; //($uuid)
  late String id; //($uuid)
  String? media;
}

class DataPersonalInformationViewModel {
  DataPersonalInformationViewModel.fromJson(Map<String, dynamic> data) {
    personalInformationId =
        convertData(data, 'personalInformationId', DataType.string);
    userName = convertData(data, 'userName', DataType.string);
    fullName = convertData(data, 'fullName', DataType.string);
    team = convertData(data, 'team', DataType.clas, classType: 'DataTeam');
    notificationToken = convertData(data, 'notificationToken', DataType.string);
    profilePhoto = convertData(data, 'profilePhoto', DataType.string);
  }

  String? fullName;
  String? profilePhoto;
  String? notificationToken;
  String? personalInformationId; //($uuid)
  DataTeam? team;
  String? userName;
}

class DataCommentReply {
  DataCommentReply.fromJson(Map<String, dynamic> data) {
    createdAt=convertData(data, 'createdAt', DataType.datetime);
    editeddAt=convertData(data, 'editeddAt', DataType.datetime);
    id=convertData(data, 'id', DataType.string);
    mediaTypes=convertDataList<DataCommentReplyMediaType>(data, 'mediaTypes', 'DataCommentReplyMediaType');
    personalInformationId=convertData(data, 'personalInformationId', DataType.string);
    personalInformationViewModel=convertData(data, 'personalInformationViewModel', DataType.clas,classType: 'DataPersonalInformationViewModel');
    postCommentId=convertData(data, 'postCommentId', DataType.string);
    replyDetail=convertData(data, 'replyDetail', DataType.string);
    replyLikeCount=convertData(data, 'replyLikeCount', DataType.int);
    replyLikedBythisUser=convertData(data, 'replyLikedBythisUser', DataType.bool);
    replyLikes=convertDataList<DataReplyLike>(data, 'replyLikes', 'DataReplyLike');
  }



  late DateTime createdAt;
  DateTime? editeddAt;
  late String id; //($uuid)
  List<DataCommentReplyMediaType> mediaTypes = [];
  late String personalInformationId; //($uuid)
  late DataPersonalInformationViewModel personalInformationViewModel;
  late String postCommentId; //($uuid)
  String? replyDetail;
  late int replyLikeCount;
  late bool replyLikedBythisUser;
  List<DataReplyLike> replyLikes = [];
}

class DataCommentMediaType {
  DataCommentMediaType.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    media = convertData(data, 'media', DataType.string);
    postCommentId = convertData(data, 'postCommentId', DataType.string);
  }

  late String id; //($uuid)
  String? media;
  late String postCommentId; //($uuid)
}

class DataPostComment {
  DataPostComment.fromJson(Map<String, dynamic> data) {
    comment=convertData(data, 'comment', DataType.string);
    commentLikeCount=convertData(data, 'commentLikeCount', DataType.int);
    commentLikedBythisUser=convertData(data, 'commentLikedBythisUser', DataType.bool);
    commentLikes=convertDataList<DataCommentLike>(data, 'commentLikes', 'DataCommentLike');
    commentReplies=convertDataList<DataCommentReply>(data, 'commentReplies', 'DataCommentReply');
    commentReplyCount=convertData(data, 'commentReplyCount', DataType.int);
    createdAt=convertData(data, 'createdAt', DataType.datetime);
    editedAt=convertData(data, 'editedAt', DataType.datetime);
    id=convertData(data, 'id', DataType.string);
    mediaTypes=convertDataList<DataCommentMediaType>(data, 'mediaTypes', 'DataCommentMediaType');
    personalInformationId=convertData(data, 'personalInformationId', DataType.string);
    personalInformationViewModel=convertData(data, 'personalInformationViewModel', DataType.clas,classType: 'DataPersonalInformationViewModel');
    postId=convertData(data, 'postId', DataType.string);
  }



  String? comment;
  late int commentLikeCount;
  late bool commentLikedBythisUser;
  late List<DataCommentLike> commentLikes;
  late List<DataCommentReply> commentReplies;
  late int commentReplyCount;
  late DateTime createdAt;
  DateTime? editedAt;
  late String id; //($uuid)
  late List<DataCommentMediaType> mediaTypes;
  late String personalInformationId; //($uuid)
  late DataPersonalInformationViewModel personalInformationViewModel;
  late String postId; //($uuid)
}

class DataMediaType {
  DataMediaType.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    media = convertData(data, 'media', DataType.string);
    postId = convertData(data, 'postId', DataType.string);
  }

  late String id; //($uuid)
  String? media;
  late String postId; //($uuid)
}

class DataPost {
  DataPost.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    personalInformationId =
        convertData(data, 'personalInformationId', DataType.string);
    details = convertData(data, 'details', DataType.string);
    engagement = convertData(data, 'engagement', DataType.int);
    reach = convertData(data, 'reach', DataType.int);
    shares = convertData(data, 'shares', DataType.int);
    profileClicks = convertData(data, 'profileClicks', DataType.int);
    createdAt = convertData(data, 'createdAt', DataType.datetime);
    editedAt = convertData(data, 'editedAt', DataType.datetime);
    isFriend = convertData(data, 'isFriend', DataType.bool);
    friendsIds = convertData(data, 'friendsIds', DataType.string);
    selectedFriendIds = convertData(data, 'selectedFriendIds', DataType.string);
    isPublic = convertData(data, 'isPublic', DataType.bool);
    postLikes = convertDataList<DataPostLike>(data, 'postLikes', 'DataPostLike');
    postComments = convertDataList<DataPostComment>(data, 'postComments', 'DataPostComment');
    print('datamediaTypes ${data['mediaTypes']}');
    mediaTypes = convertDataList<DataMediaType>(data, 'mediaTypes', 'DataMediaType');
    isEdited = convertData(data, 'isEdited', DataType.bool);
    postLikeCount = convertData(data, 'postLikeCount', DataType.int);
    postCommentCount = convertData(data, 'postCommentCount', DataType.int);
    person = convertData(data, 'personalInformationViewModel', DataType.clas,
        classType: 'DataPersonalInformationViewModel');
    postLikedBythisUser =
        convertData(data, 'postLikedBythisUser', DataType.bool);
    blockedByMe = convertData(data, 'blockedByMe', DataType.bool);
    blockedMe = convertData(data, 'blockedMe', DataType.bool);
  }
//postId: c355e671-1d7f-4d06-eee7-08da0b5c8158, id: b8392f1e-8da6-4b1e-073a-08da0b5db436
  late bool blockedByMe;
  late bool blockedMe;
  late DateTime createdAt;
  String? details;
  DateTime? editedAt;
  late int engagement;
  String? friendsIds;
  late String id; //($uuid)
  late bool isEdited;
  late bool isFriend;
  late bool isPublic;
  late List<DataMediaType> mediaTypes;
  DataPersonalInformationViewModel? person;
  late String personalInformationId; //($uuid)
  late int postCommentCount;
  late List<DataPostComment> postComments;
  late int postLikeCount;
  late bool postLikedBythisUser;
  late List<DataPostLike> postLikes;
  late int profileClicks;
  late int reach;
  String? selectedFriendIds;
  late int shares;
}

class DataUserFollower {
  DataUserFollower.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    personalInformationId =
        convertData(data, 'personalInformationId', DataType.string);
    followerId = convertData(data, 'followerId', DataType.string);
    personalInformationViewModel =
        convertData(data, 'personalInformationViewModel', DataType.clas,classType: 'DataPersonalInformationViewModel');
    followingMe = convertData(data, 'followingMe', DataType.bool);
  }

  late String followerId;
  late bool followingMe;
  late String id; //($uuid)
  late String personalInformationId;
  late DataPersonalInformationViewModel personalInformationViewModel;
}

class DataUserFollowing {
  DataUserFollowing.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    personalInformationId =
        convertData(data, 'personalInformationId', DataType.string);
    followingId = convertData(data, 'followingId', DataType.string);
    personalInformationViewModel =
        convertData(data, 'personalInformationViewModel', DataType.clas,classType: 'DataPersonalInformationViewModel');
    followedByMe = convertData(data, 'followedByMe', DataType.bool);
  }

  late bool followedByMe;
  late String followingId;
  late String id;
  late String personalInformationId;
  late DataPersonalInformationViewModel personalInformationViewModel;
}

class DataNotification {
  DataNotification.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    personalInformationId =
        convertData(data, 'personalInformationId', DataType.string);
    notificationMessage =
        convertData(data, 'notificationMessage', DataType.string);
    notificationMedia = convertData(data, 'notificationMedia', DataType.string);
    notificationTitle = convertData(data, 'notificationTitle', DataType.string);
    timeStamp = convertData(data, 'timeStamp', DataType.string);
    event = convertData(data, 'event', DataType.string);
    personalInformationViewModel =
        convertData(data, 'personalInformationViewModel', DataType.clas,classType: 'DataPersonalInformationViewModel');
  }

  String? event;
  late String id;
  String? notificationMedia;
  String? notificationMessage;
  String? notificationTitle;
  late String personalInformationId;
  late DataPersonalInformationViewModel personalInformationViewModel;
  String? timeStamp;
}

class DataShortVideoStory {
  DataShortVideoStory.fromJson(Map<String, dynamic> data) {
    caption=convertData(data, 'caption', DataType.string);
    color=convertData(data, 'color=', DataType.string);
    content=convertData(data, 'content', DataType.string);
    createdAt=convertData(data, 'createdAt', DataType.string);
    dateTimeForDb=convertData(data, 'dateTimeForDb', DataType.datetime);
    editedAt=convertData(data, 'editedAt=convertData', DataType.string);
    engagement=convertData(data, 'engagement', DataType.int);
    font=convertData(data, 'font', DataType.string);
    id=convertData(data, 'id', DataType.string);
    mediaURL=convertData(data, 'mediaURL', DataType.string);
    mimeType=convertData(data, 'mimeType', DataType.string);
    personalInformationId=convertData(data, 'personalInformationId', DataType.string);
    personalInformationViewModel=convertData(data, 'personalInformationViewModel', DataType.clas,classType: 'DataPersonalInformationViewModel');
    profileClicks=convertData(data, 'profileClicks', DataType.int);
    reach=convertData(data, 'reach', DataType.int);
    seenStatus=convertData(data, 'seenStatus', DataType.bool);
    shares=convertData(data, 'shares', DataType.int);
  }

  String? caption;
  String? color;
  String? content;
  String? createdAt;
  late DateTime dateTimeForDb;
  String? editedAt;
  late int engagement;
  String? font;
  late String id;
  String? mediaURL;
  String? mimeType;
  late String personalInformationId;
  late DataPersonalInformationViewModel personalInformationViewModel;
  late int profileClicks;
  late int reach;
  late bool seenStatus;
  late int shares;
}

class DataRefreshToken {
  DataRefreshToken.fromJson(Map<String, dynamic> data) {
    expiryDate = convertData(data, 'expiryDate', DataType.string);
    personalInformationId =
        convertData(data, 'personalInformationId', DataType.string);
    token = convertData(data, 'token', DataType.string);
    tokenId = convertData(data, 'tokenId', DataType.string);
  }

  late DateTime expiryDate;
  late String personalInformationId;
  String? token;
  late String tokenId;
}

class DataFriendsBlock {
  DataFriendsBlock.fromJson(Map<String, dynamic> data) {
    blockedUserId = convertData(data, 'blockedUserId', DataType.string);
    id = convertData(data, 'id', DataType.string);
    personalInformationId =
        convertData(data, 'personalInformationId', DataType.string);
  }

  late String blockedUserId;
  late String id;
  late String personalInformationId;
}

class DataApplicationUser {
  DataApplicationUser.fromJson(Map<String, dynamic> data) {
    accessFailedCount=convertData(data, 'accessFailedCount', DataType.int);
    concurrencyStamp=convertData(data, 'concurrencyStamp', DataType.string);
    email=convertData(data, 'email', DataType.string);
    emailConfirmed=convertData(data, 'emailConfirmed', DataType.bool);
    id=convertData(data, 'id', DataType.string);
    lockoutEnabled=convertData(data, 'lockoutEnabled', DataType.bool);
    lockoutEnd=convertData(data, 'lockoutEnd', DataType.datetime);
    normalizedEmail=convertData(data, 'normalizedEmail', DataType.string);
    normalizedUserName=convertData(data, 'normalizedUserName', DataType.string);
    passwordHash=convertData(data, 'passwordHash=', DataType.string);
    personalInformation=convertData(data, 'personalInformation', DataType.string);
    phoneNumber=convertData(data, 'phoneNumber', DataType.string);
    phoneNumberConfirmed=convertData(data, 'phoneNumberConfirmed', DataType.bool);
    securityStamp=convertData(data, 'securityStamp', DataType.string);
    twoFactorEnabled=convertData(data, 'twoFactorEnabled', DataType.bool);
    userName=convertData(data, 'userName', DataType.string);
  }



  late int accessFailedCount;
  String? concurrencyStamp;
  String? email;
  late bool emailConfirmed;
  String? id;
  late bool lockoutEnabled;
  DateTime? lockoutEnd;
  String? normalizedEmail;
  String? normalizedUserName;
  String? passwordHash;
  DataPersonalInformation? personalInformation;
  String? phoneNumber;
  late bool phoneNumberConfirmed;
  String? securityStamp;
  late bool twoFactorEnabled;
  String? userName;
}

class DataPersonalInformation {
  DataPersonalInformation.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    userName = convertData(data, 'userName', DataType.string);
    fullName = convertData(data, 'fullName', DataType.string);
    email = convertData(data, 'email', DataType.string);
    phoneNumber = convertData(data, 'phoneNumber', DataType.string);
    isProfileLocked = convertData(data, 'isProfileLocked', DataType.bool);
    isBlockedByAdmin = convertData(data, 'isBlockedByAdmin', DataType.bool);
    dateTemporaryBlocked =
        convertData(data, 'dateTemporaryBlocked', DataType.datetime);
    notificationToken = convertData(data, 'notificationToken', DataType.string);
    bio = convertData(data, 'bio', DataType.string);
    location = convertData(data, 'location', DataType.string);
    dob = convertData(data, 'dob', DataType.datetime);
    otpDate = convertData(data, 'otpDate', DataType.datetime);
    profilePhoto=convertData(data,'profilePhoto', DataType.string);//todo DataProfileMediaType
    isOnline = convertData(data, 'isOnline', DataType.bool);
    is2FA = convertData(data, 'is2FA', DataType.bool);
    roles=convertDataList<String>(data,'roles', 'String');
    otp = convertData(data, 'otp', DataType.string);
    teamId = convertData(data, 'teamId', DataType.string);
    team = convertData(data, 'team', DataType.clas, classType: 'DataTeam');
    followersCount = convertData(data, 'followersCount', DataType.int);
    followingCount = convertData(data, 'followingCount', DataType.int);
    postCount = convertData(data, 'postCount', DataType.int);
    followingMe = convertData(data, 'followingMe', DataType.bool);
    followedByMe = convertData(data, 'followedByMe', DataType.bool);
    blockedByMe = convertData(data, 'blockedByMe', DataType.bool);
    blockedMe = convertData(data, 'blockedMe', DataType.bool);
    posts=convertDataList<DataPost>(data,'posts', 'DataPost');
    userFollowers=convertDataList<DataUserFollower>(data,'userFollowers', 'DataUserFollower');
    userFollowings=convertDataList<DataUserFollowing>(data,'userFollowings', 'DataUserFollowing');
    notifications = convertDataList<DataNotification>(data, 'notifications', 'DataNotification');
    shortVideoStories=convertDataList<DataShortVideoStory>(data,'shortVideoStories', 'DataShortVideoStory');
    refreshTokens=convertDataList<DataRefreshToken>(data,'refreshTokens', 'DataRefreshToken');
    friendsBlocks=convertDataList<DataFriendsBlock>(data,'friendsBlocks', 'DataFriendsBlock');
    chatRooms=convertDataList<DataChatRoomUser>(data,'chatRooms', 'DataChatRoomUser');
    applicationUserId = convertData(data, 'applicationUserId', DataType.string);
    applicationUser=convertData(data,'applicationUser', DataType.clas,classType: 'DataApplicationUser');
  }

  DataApplicationUser? applicationUser;
  String? applicationUserId;
  String? bio;
  late bool blockedByMe;
  late bool blockedMe;
  List<DataChatRoomUser?> chatRooms = [];
  late DateTime dateTemporaryBlocked;
  late DateTime dob;
  String? email;
  late bool followedByMe;
  late int followersCount;
  late int followingCount;
  late bool followingMe;
  List<DataFriendsBlock?> friendsBlocks = [];
  String? fullName;
  late String id;
  late bool is2FA;
  late bool isBlockedByAdmin;
  late bool isOnline;
  late bool isProfileLocked;
  String? location;
  String? notificationToken;
  List<DataNotification?> notifications = [];
  String? otp;
  late DateTime otpDate;
  String? phoneNumber;
  late int postCount;
  List<DataPost> posts = [];
  String? profilePhoto;//todo
  List<DataRefreshToken?> refreshTokens = [];
  List<String?> roles = [];
  List<DataShortVideoStory?> shortVideoStories = [];
  DataTeam? team;
  String? teamId; //($uuid)
  List<DataUserFollower> userFollowers = [];
  List<DataUserFollowing?> userFollowings = [];
  String? userName;
}
class DataCreateMessageDTO {
  DataCreateMessageDTO.fromJson(Map<String, dynamic> data) {
    conversationKey=convertData(data, 'conversationKey', DataType.string);
    messageContent=convertData(data, 'messageContent', DataType.string);
    messageMedia=convertData(data, 'messageMedia', DataType.string);
    personalInformationReceivedId=convertData(data, 'personalInformationReceivedId', DataType.string);
    personalInformationSentId=convertData(data, 'personalInformationSentId', DataType.string);
    timeStamp=convertData(data, 'timeStamp', DataType.string);
    personalInformationSent=convertData(data, 'personalInformationSent', DataType.clas,classType: 'DataPersonalInformation');
    personalInformationReceived=convertData(data, 'personalInformationReceived', DataType.clas,classType: 'DataPersonalInformation');
    seen=convertData(data, 'seen', DataType.bool);
    sendByThisUser=convertData(data, 'sendByThisUser', DataType.bool);
    id=convertData(data, 'id', DataType.string);
  }

  String? conversationKey;
  String? messageContent;
  String? messageMedia;
  late String personalInformationReceivedId;
  late String personalInformationSentId;
  late DataPersonalInformation personalInformationSent;
  late DataPersonalInformation personalInformationReceived;
  String? timeStamp;
  late bool seen;
  bool? sendByThisUser;
  late String id;
}

class DataChatMessage {
  DataChatMessage.fromJson(Map<String, dynamic> data) {
    chatRoom=convertData(data, 'chatRoom', DataType.clas,classType: 'DataChatRoom');
    chatRoomId=convertData(data, 'chatRoomId', DataType.string);
    id=convertData(data, 'id', DataType.string);
    name=convertData(data, 'name', DataType.string);
    text=convertData(data, 'text', DataType.string);
    timeStamp=convertData(data, 'timeStamp', DataType.datetime);
  }


  DataChatRoom? chatRoom;//todo
  late String chatRoomId;
  late String id;
  String? name;
  String? text;
  late DateTime timeStamp;

}

// enum ChatTypeinteger{
//   one,two
// }

class DataChatRoom {
  DataChatRoom.fromJson(Map<String, dynamic> data) {
    chatMessages = convertDataList<DataChatMessage>(data, 'chatMessages', 'DataChatMessage');
    chatType = convertData(data, 'chatType', DataType.int);
    id = convertData(data, 'id', DataType.string);
    name = convertData(data, 'name', DataType.string);
    personalInformations = convertDataList<DataChatRoomUser>(data, 'personalInformations', 'DataChatRoomUser');
  }

  List<DataChatMessage> chatMessages = [];
  late int chatType;
  late String id;
  String? name;
  List<DataChatRoomUser> personalInformations = [];
}

// late int UserRoleInRoom;
// Enum:
// Array [ 2 ]

class DataChatRoomUser {
  DataChatRoomUser.fromJson(Map<String, dynamic> data) {
    chatRoom = convertData(data, 'chatRoom', DataType.clas,classType: 'DataChatRoom');
    chatRoomId = convertData(data, 'chatRoomId', DataType.string);
    personalInformation = convertData(data, 'personalInformation', DataType.clas,classType: 'DataPersonalInformation');
    personalInformationId = convertData(data, 'personalInformationId', DataType.string);
    userRole = convertData(data, 'userRole', DataType.int);
  }

  DataChatRoom? chatRoom;
  late String chatRoomId;
  DataPersonalInformation? personalInformation;
  late String personalInformationId;
  late int userRole;
}

class DataUserWithToken {
  DataUserWithToken.fromJson(Map<String, dynamic> data) {
    accessToken = convertData(data, 'accessToken', DataType.string);
    applicationUser=convertData(data,'applicationUser', DataType.clas,classType: 'DataApplicationUser');
    applicationUserId = convertData(data, 'applicationUserId', DataType.string);
    bio = convertData(data, 'bio', DataType.string);
    blockedByMe = convertData(data, 'blockedByMe', DataType.bool);
    blockedMe = convertData(data, 'blockedMe', DataType.bool);
    chatRooms=convertDataList<DataChatRoomUser>(data,'chatRooms', 'DataChatRoomUser');
    dateTemporaryBlocked =
        convertData(data, 'dateTemporaryBlocked', DataType.datetime);
    dob = convertData(data, 'dob', DataType.datetime);
    email = convertData(data, 'email', DataType.string);
    followedByMe = convertData(data, 'followedByMe', DataType.bool);
    followersCount = convertData(data, 'followersCount', DataType.int);
    followingCount = convertData(data, 'followingCount', DataType.int);
    followingMe = convertData(data, 'followingMe', DataType.bool);
    friendsBlocks=convertDataList<DataFriendsBlock>(data,'friendsBlocks', 'DataFriendsBlock');
    fullName = convertData(data, 'fullName', DataType.string);
    id = convertData(data, 'id', DataType.string);
    is2FA = convertData(data, 'is2FA', DataType.bool);
    isBlockedByAdmin = convertData(data, 'isBlockedByAdmin', DataType.bool);
    isOnline = convertData(data, 'isOnline', DataType.bool);
    isProfileLocked = convertData(data, 'isProfileLocked', DataType.bool);
    location = convertData(data, 'location', DataType.string);
    notificationToken = convertData(data, 'notificationToken', DataType.string);
    notifications = convertDataList<DataNotification>(data, 'notifications', 'DataNotification');
    otp = convertData(data, 'otp', DataType.string);
    otpDate = convertData(data, 'otpDate', DataType.datetime);
    phoneNumber = convertData(data, 'phoneNumber', DataType.string);
    postCount = convertData(data, 'postCount', DataType.int);
    posts=convertDataList<DataPost>(data,'posts', 'DataPost');
    profilePhoto=convertData(data,'profilePhoto', DataType.clas,classType: 'DataProfileMediaType');
    refreshToken=convertData(data,'refreshToken', DataType.string);
    refreshTokens=convertDataList<DataRefreshToken>(data,'refreshTokens', 'DataRefreshToken');
    roles=convertDataList<String>(data,'roles', 'String');
    shortVideoStories=convertDataList<DataShortVideoStory>(data,'shortVideoStories', 'DataShortVideoStory');
    team = convertData(data, 'team', DataType.clas, classType: 'DataTeam');
    teamId = convertData(data, 'teamId', DataType.string);
    userFollowers=convertDataList<DataUserFollower>(data,'userFollowers', 'DataUserFollower');
    userFollowings=convertDataList<DataUserFollowing>(data,'userFollowings', 'DataUserFollowing');
    userName = convertData(data, 'userName', DataType.string);
  }



  String? accessToken;
  late DataApplicationUser applicationUser;
  String? applicationUserId;
  String? bio;
  late bool blockedByMe;
  late bool blockedMe;
  List<DataChatRoomUser?> chatRooms = [];
  late DateTime dateTemporaryBlocked;
  late DateTime dob;
  String? email;
  late bool followedByMe;
  late int followersCount;
  late int followingCount;
  late bool followingMe;
  List<DataFriendsBlock?> friendsBlocks = [];
  String? fullName;
  late String id;
  late bool is2FA;
  late bool isBlockedByAdmin;
  late bool isOnline;
  late bool isProfileLocked;
  String? location;
  String? notificationToken;
  List<DataNotification?> notifications = [];
  String? otp; //
  late DateTime otpDate;
  String? phoneNumber;
  late int postCount;
  List<DataPost?> posts = [];
  late DataProfileMediaType profilePhoto;
  String? refreshToken;
  List<DataRefreshToken?> refreshTokens = [];
  List<String?> roles = [];
  List<DataShortVideoStory?> shortVideoStories = [];
  late DataTeam team;
  String? teamId; //($uuid)
  List<DataUserFollower?> userFollowers = [];
  List<DataUserFollowing?> userFollowings = [];
  String? userName;
}

class DataEditRoleDTO {
  DataEditRoleDTO.fromJson(Map<String, dynamic> data) {
    roleName = convertData(data, 'roleName', DataType.string);
  }

  String? roleName;
}

class DataUserRoleDTO {
  DataUserRoleDTO.fromJson(Map<String, dynamic> data) {
    isSelected = convertData(data, 'isSelected', DataType.bool);
    userId = convertData(data, 'userId', DataType.string);
    userName = convertData(data, 'userName', DataType.string);
  }

  late bool isSelected;
  String? userId;
  String? userName;
}

class DataUserClaim {
  DataUserClaim.fromJson(Map<String, dynamic> data) {
    claimType = convertData(data, 'claimType', DataType.string);
    isSelected = convertData(data, 'isSelected', DataType.bool);
  }

  String? claimType;
  late bool isSelected;
}

class DataUserClaimsViewModel {
  DataUserClaimsViewModel.fromJson(Map<String, dynamic> data) {
    claims = convertData(data, 'claims', DataType.string);
    userId = convertData(data, 'userId', DataType.string);
  }

  List<DataUserClaim> claims = [];
  String? userId;
}

class DataForgotPasswordViewModel {
  DataForgotPasswordViewModel.fromJson(Map<String, dynamic> data) {
    user = convertData(data, 'user', DataType.string);
  }

  late String user;
}

class DataResetPasswordViewModel {
  DataResetPasswordViewModel.fromJson(Map<String, dynamic> data) {
    confirmPassword = convertData(data, 'confirmPassword', DataType.string);
    oTP = convertData(data, 'oTP', DataType.string);
    password = convertData(data, 'password', DataType.string);
    user = convertData(data, 'user', DataType.string);
  }

  String? confirmPassword; //($password)
  String? oTP; //
  late String password; //($password)
  String? user; //
}

class DataPhoneUpdateRequestDTO {
  DataPhoneUpdateRequestDTO.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    phoneNumber = convertData(data, 'phoneNumber', DataType.string);
  }

  late String id; //($uuid)
  String? phoneNumber;
}

class DataPhoneUpdateDTO {
  DataPhoneUpdateDTO.fromJson(Map<String, dynamic> data) {
    id = convertData(data, 'id', DataType.string);
    newPhoneNumber = convertData(data, 'newPhoneNumber', DataType.string);
    oTP = convertData(data, 'oTP', DataType.string);
  }

  late String id; //($uuid)
  String? newPhoneNumber;
  String? oTP;
}

class DataUpdatePasswordDTO {
  DataUpdatePasswordDTO.fromJson(Map<String, dynamic> data) {
    confirmPassword = convertData(data, 'confirmPassword', DataType.string);
    currentPassword = convertData(data, 'currentPassword', DataType.string);
    id = convertData(data, 'id', DataType.string);
    newPassword = convertData(data, 'newPassword', DataType.string);
  }

  String? confirmPassword; //($password)
  String? currentPassword; //($password)
  String? id; //
  String? newPassword; //($password)
}

class DataUserFollowerDTO {
  DataUserFollowerDTO.fromJson(Map<String, dynamic> data) {
    followerId = convertData(data, 'followerId', DataType.string);
    userId = convertData(data, 'userId', DataType.string);
  }

  late String followerId; //($uuid)
  late String userId; //($uuid)
}

class DataRegisterViewModel {
  DataRegisterViewModel.fromJson(Map<String, dynamic> data) {
    confirmPassword=convertData(data, 'confirmPassword', DataType.string);
    email=convertData(data, 'email', DataType.string);
    fullName=convertData(data, 'fullName=', DataType.string);
    is2FA=convertData(data, 'is2FA=convertData', DataType.bool);
    isOnline=convertData(data, 'isOnline', DataType.bool);
    notificationToken=convertData(data, 'notificationToken', DataType.string);
    password=convertData(data, 'password', DataType.string);
    phoneNumber=convertData(data, 'phoneNumber', DataType.string);
    userName=convertData(data, 'userName', DataType.string);
  }


  String? confirmPassword; //($password)
  late String email; //($email)
  late String fullName;
  late bool is2FA;
  late bool isOnline;
  String? notificationToken;
  late String password; //($password)
  String? phoneNumber;
  late String userName;
}

class DataLoginViewModel {
  DataLoginViewModel.fromJson(Map<String, dynamic> data) {
    notificationToken = convertData(data, 'notificationToken', DataType.string);
    password = convertData(data, 'password', DataType.string);
    rememberMe = convertData(data, 'rememberMe', DataType.bool);
    user = convertData(data, 'user', DataType.string);
  }

  String? notificationToken;
  late String password; //($password)
  late bool rememberMe;
  late String user;
}

class DataLoginViewModelWithOTP {
  DataLoginViewModelWithOTP.fromJson(Map<String, dynamic> data) {
    notificationToken = convertData(data, 'notificationToken', DataType.string);
    oTP = convertData(data, 'oTP', DataType.string);
    password = convertData(data, 'password', DataType.string);
    rememberMe = convertData(data, 'rememberMe', DataType.bool);
    user = convertData(data, 'user', DataType.string);
  }

  String? notificationToken;
  late String oTP;
  late String password; //($password)
  late bool rememberMe;
  late String user;
}



class DataEditPostDTO {
  DataEditPostDTO.fromJson(Map<String, dynamic> data) {
    details = convertData(data, 'details', DataType.string);
    isFriend = convertData(data, 'isFriend', DataType.bool);
    isPublic = convertData(data, 'isPublic', DataType.bool);
    mediaTypes = convertDataList<DataMediaType>(data, 'mediaTypes', 'DataMediaType');
    userIds = convertDataList<String>(data, 'userIds', 'String');
  }

  String? details;
  late bool isFriend;
  late bool isPublic;
  List<DataMediaType> mediaTypes = [];
  List<String> userIds = [];
}

class DataEditCommentReplyDTO {
  DataEditCommentReplyDTO.fromJson(Map<String, dynamic> data) {
    reply = convertData(data, 'reply', DataType.string);
  }

  String? reply;
}

class DataEditCommentDTO {
  DataEditCommentDTO.fromJson(Map<String, dynamic> data) {
    comment = convertData(data, 'comment', DataType.string);
  }

  String? comment;
}

class DataWeatherForecast {
  DataWeatherForecast.fromJson(Map<String, dynamic> data) {
    date = convertData(data, 'date', DataType.datetime);
    summary = convertData(data, 'summary', DataType.string);
    temperatureC = convertData(data, 'temperatureC', DataType.int);
    temperatureF = convertData(data, 'temperatureF', DataType.int);
  }

  late DateTime date;
  String? summary;
  late int temperatureC;
  late final int temperatureF; //readOnly: true
}

///---------------------------------------------

class DataRoleDTO {
  DataRoleDTO.fromJson(Map<String, dynamic> data) {
    roleName=convertData(data, 'roleName', DataType.string);
  }

  String? roleName;
}

enum DataType { datetime, int, double, string, bool, boolint, clas }

dynamic makeClass(Map<String, dynamic> data, String type) {
  switch (type) {
    case 'String':
      return data.toString();
    case 'DataCreateRoleDTO':
      return DataCreateRoleDTO.fromJson(data);
    case 'DataEditUserDTO':
      return DataEditUserDTO.fromJson(data);
    case 'DataUpdateIsProfileLock':
      return DataUpdateIsProfileLock.fromJson(data);
    case 'DataUpdateProfileBlock':
      return DataUpdateProfileBlock.fromJson(data);
    case 'DataUpdate2FADTO':
      return DataUpdate2FADTO.fromJson(data);
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
    case 'DataCommentReplyMediaType':
      return DataCommentReplyMediaType.fromJson(data);
    case 'DataPersonalInformationViewModel':
      return DataPersonalInformationViewModel.fromJson(data);
    case 'DataCommentReply':
      return DataCommentReply.fromJson(data);
    case 'DataCommentMediaType':
      return DataCommentMediaType.fromJson(data);
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
    case 'DataRefreshToken':
      return DataRefreshToken.fromJson(data);
    case 'DataFriendsBlock':
      return DataFriendsBlock.fromJson(data);
    case 'DataApplicationUser':
      return DataApplicationUser.fromJson(data);
    case 'DataPersonalInformation':
      return DataPersonalInformation.fromJson(data);
    case 'DataChatMessage':
      return DataChatMessage.fromJson(data);
    case 'DataChatRoom':
      return DataChatRoom.fromJson(data);
    case 'DataChatRoomUser':
      return DataChatRoomUser.fromJson(data);
    case 'DataUserWithToken':
      return DataUserWithToken.fromJson(data);
    case 'DataEditRoleDTO':
      return DataEditRoleDTO.fromJson(data);
    case 'DataUserRoleDTO':
      return DataUserRoleDTO.fromJson(data);
    case 'DataUserClaim':
      return DataUserClaim.fromJson(data);
    case 'DataUserClaimsViewModel':
      return DataUserClaimsViewModel.fromJson(data);
    case 'DataForgotPasswordViewModel':
      return DataForgotPasswordViewModel.fromJson(data);
    case 'DataResetPasswordViewModel':
      return DataResetPasswordViewModel.fromJson(data);
    case 'DataPhoneUpdateRequestDTO':
      return DataPhoneUpdateRequestDTO.fromJson(data);
    case 'DataPhoneUpdateDTO':
      return DataPhoneUpdateDTO.fromJson(data);
    case 'DataUpdatePasswordDTO':
      return DataUpdatePasswordDTO.fromJson(data);
    case 'DataUserFollowerDTO':
      return DataUserFollowerDTO.fromJson(data);
    case 'DataRegisterViewModel':
      return DataRegisterViewModel.fromJson(data);
    case 'DataLoginViewModel':
      return DataLoginViewModel.fromJson(data);
    case 'DataLoginViewModelWithOTP':
      return DataLoginViewModelWithOTP.fromJson(data);
    case 'DataCreateMessageDTO':
      return DataCreateMessageDTO.fromJson(data);
    case 'DataEditPostDTO':
      return DataEditPostDTO.fromJson(data);
    case 'DataEditCommentReplyDTO':
      return DataEditCommentReplyDTO.fromJson(data);
    case 'DataEditCommentDTO':
      return DataEditCommentDTO.fromJson(data);
    case 'DataWeatherForecast':
      return DataWeatherForecast.fromJson(data);

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
List<Type> convertDataList<Type>(Map<String, dynamic> data, String key,String classType){
  if (data.containsKey(key) == false ||
      data[key] == null ||
      data[key].isEmpty) {
    return [];
  } else {
    List<Type> temp = [];
    for (int j = 0; j < data[key].length; j++) {
      // print('$j j ${data[key][j].runtimeType}');
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
        return dd??DateTime.now();
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





