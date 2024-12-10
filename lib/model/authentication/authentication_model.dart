class AuthModel {
  int? id;
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? city;
  String? state;
  String? dob;
  String? position;
  String? experience;
  String? bio;
  String? userType;
  bool? isOwner;
  String? profileImg;
  String? backgroundImg;
  bool? isApproved;
  bool? isSupAdmin;
  bool? isBlocked;
  bool? isActive;
  bool? isDeleted;
  bool? deleteByUser;
  bool? isStaff;
  bool? isSuperuser;
  String? lastLogin;
  int? userStage;
  bool? isPublic;
  String? createdAt;
  String? updatedAt;
  String? companyId;
  List<int>? interestIn;
  String? token;

  AuthModel(
      {this.id,
        this.email,
        this.password,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.city,
        this.state,
        this.dob,
        this.position,
        this.experience,
        this.bio,
        this.userType,
        this.isOwner,
        this.profileImg,
        this.backgroundImg,
        this.isApproved,
        this.isSupAdmin,
        this.isBlocked,
        this.isActive,
        this.isDeleted,
        this.deleteByUser,
        this.isStaff,
        this.isSuperuser,
        this.lastLogin,
        this.userStage,
        this.isPublic,
        this.createdAt,
        this.updatedAt,
        this.companyId,
        this.interestIn,
        this.token});

  AuthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    city = json['city'];
    state = json['state'];
    dob = json['dob'];
    position = json['position'];
    experience = json['experience'];
    bio = json['bio'];
    userType = json['user_type'];
    isOwner = json['is_owner'];
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    isApproved = json['is_approved'];
    isSupAdmin = json['is_sup_admin'];
    isBlocked = json['is_blocked'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    deleteByUser = json['delete_by_user'];
    isStaff = json['is_staff'];
    isSuperuser = json['is_superuser'];
    lastLogin = json['last_login'];
    userStage = json['user_stage'];
    isPublic = json['is_public'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    interestIn = json['interest_in'].cast<int>();
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phoneNumber;
    data['city'] = city;
    data['state'] = state;
    data['dob'] = dob;
    data['position'] = position;
    data['experience'] = experience;
    data['bio'] = bio;
    data['user_type'] = userType;
    data['is_owner'] = isOwner;
    data['profile_img'] = profileImg;
    data['background_img'] = backgroundImg;
    data['is_approved'] = isApproved;
    data['is_sup_admin'] = isSupAdmin;
    data['is_blocked'] = isBlocked;
    data['is_active'] = isActive;
    data['is_deleted'] = isDeleted;
    data['delete_by_user'] = deleteByUser;
    data['is_staff'] = isStaff;
    data['is_superuser'] = isSuperuser;
    data['last_login'] = lastLogin;
    data['user_stage'] = userStage;
    data['is_public'] = isPublic;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['token'] = token;
    return data;
  }
}

