import 'package:iso_net/singelton_class/auth_singelton.dart';

class AppStrings {
  ///To get Sha Key from firebase
  static const String shaKeyFirebase = 'keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android';

  static const String describesYou = 'What best describes you?';

  ///authentication strings
  static const String getStarted = 'Get Started';
  static const String bSignIn = 'Sign in';
  static const String tSignIn = 'Sign In';
  static const String logIn = 'Login';
  static const String bNext = 'Next';

  static const String strChatTypeInitial = 'initial';
  static const String strChatTypeFeed = 'feed';
  static const String strChatTypeForum = 'forum';
  static const String strChatTypeMedia = 'media';

  static const String bForgotPwd = 'Forgot password?';
  static const String tForgotPwd = 'Forgot Password';
  static const String email = 'Email';
  static const String hintEmail = 'you@example.com';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String bSubmit = 'Submit';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String phoneNumber = 'Phone Number';

  static const String confirmYourEmail = 'Confirm Your Email';
  static const String enterOtp = 'Enter the OTP sent to your email.';
  static const String oneTimePassword = 'One-Time Password';
  static const String resendCode = 'Resend code';

  static const String resendSuccessMsg = 'Reset password link send to your email';
  static const String otpSentOnEmail = 'OTP send to your email id';
  static const String noPlanFound = "No Plan Found";

  ///user string
  static const String details = 'Details';
  static const String city = 'City';
  static const String state = 'State';
  static const String birthDate = 'Birthdate';
  static const String companyName = 'Company Name';
  static const String position = 'Position';
  static const String experience = 'Experience';
  static const String bio = 'Bio';
  static const String publicPrivate = 'Would you like your account to be Public?';
  static const String clearNotificationMessage = 'Are you sure you want to clear notification history?';
  static const String companySearch = 'Company Search';
  static const String industrySearch = 'Industry Search';
  static const String loanSearch = 'Loan Tags';
  static const String stateSearch = 'State Search';

  static const String createYourCompanyProfile = 'Create Your Company Profile';
  static const String createCompanyProfile = 'Create Company Profile';


  static const String noDataFound = 'No Data Found';

  ///create company screen

  static const String companyDetails = 'Company Details';

  ///validation string

  //**Email
  static const String blankEmail = "Please enter email";
  static const String validateEmail = "Please enter valid email";
  static const String emailNotRegister = "Entered email is not registered";
  static const String emailRegistered = "Entered email is already registered";

  //**Password
  static const String blankPassword = "Please enter your password";

  /*static const String passwordLength = "Password must contain at least 6 characters";*/
  static const String validatePassword = "Please enter valid password";

  //**Signup Password
  static const String signUpPasswordValidate = "Password must contain at least 6 characters";

  //**confirm password
  static const String blankConfirmPassword = "Please enter confirm password";
  static const String validateConfirmPassword = "Confirm password and password need to be the same";

  //**Forgot Password
  static const String resetPassword = "Reset Password link will be sent to your email/phone number. Please follow that link to reset your password";

  //**First Name
  static const String blankFirstName = "Please enter first name";
  static const String validateFirstName = "Please enter valid first name";

  //**Last Name
  static const String blankLastName = "Please enter last name";
  static const String validateLastName = "Please enter valid last name";

  //**Phone No
  static const String blankMobileNo = "Please enter phone number";
  static const String validateMobileNo = "Please enter valid phone number";
  static const String mobileNoRegistered = "Entered phone number is already registered";

  //**Otp
  static const String blankOtp = "Please enter OTP";
  static const String validateOtp = "Please enter valid OTP";
  static const String resendOtp = "Please wait for 59 seconds for next code";

  //**Details Page
  static const String noCompanyFound = "No Company Found";

  //**City
  static const String blankCity = "Enter city";
  static const String validateCity = "Please enter valid city";

  //**State
  static const String blankState = "Please select state";
  static const String validateState = "Please enter valid state";

  //**Birthdate
  static const String blankBirthDate = "Please select birth date";
  static const String validBirthDate = "Please select/enter valid birth date";

  //**Company
  static const String dBlankCompanyName = "Please select company name";
  static const String blankCompanyName = "Please enter company name";
  static const String validateCompanyName = "Please enter valid company name";

  //**Position
  static const String blankPosition = "Please enter position";
  static const String validatePosition = "Please enter valid position";

  //**Experience
  static const String blankExperience = "Please select experience";
  static const String validateExperience = "Please enter valid experience";

  //**Bio
  static const String blankBio = "Please enter bio";
  static const String validateBio = "Please enter valid bio";

  //**Company details page

  //**Description
  static const String description = "Description";
  static const String blankDescription = "Please enter description";
  static const String validateDescription = "Please enter valid description";

  //**Address
  static const String address = "Address";
  static const String blankAddress = "Please enter address";
  static const String validateAddress = "Please enter valid address";

  //**website
  static const String website = "Website";
  static const String blankWebsite = "Please enter your company website";
  static const String validateWebsite = "Please enter valid website";

  //**Zipcode
  static const String zipCode = "Zip Code";
  static const String blankZipCode = "Please enter zip code";
  static const String validateZipCode = "Zip code must contain at least 5 digits";

  //**Subscribe Page
  static const String subscribe = 'Subscribe';
  static const String restorePurchase = 'Restore Purchases';
  static const String termsOfUse = 'Terms of use';
  static const String privacyPolicy = 'Privacy policy';
  static const String byContinueAgree = 'By continuing, you agree to our';
  static const String validateTermsCondition = 'Please accept our terms of use & privacy policy';
  static const String and ='and';
  static const String paymentTerm =
      'Payment will be charged to your Apple ID at the confirmation of purchase.The subscription automatically renews unless it is cancelled at least 24 hours before end of the current period';

  //**Company Image
  static const String companyImage = 'Company Image';
  static const String validateCompanyImage = 'Please select company image';

  //**User Image
  static const String profileImage = 'Profile Image';
  static const String validateProfileImage = 'Please select profile image';

  //**Terms & condition


  //**Background Image
  static const String backGroundImage = 'Background Image';
  static const String validateBackGroundImage = 'Please select background image';

  //**Loan Preference Screen

  static const String loanPreferences = "Loan Preferences";
  static const String editLoanPreferences = "Edit Loan Preferences";

  static const String tellUsTypeLoans = "Tell us the type of loans your looking to fund";
  static const String tellUsTypeDeal = "Tell us the type of deals you are looking to fund";
  static const String creditScore = "Credit Score";
  static const String creditRequirement = "Credit Requirement";
  static const String borrowerCreditRequirement = "Borrower's Credit Score";
  static const String minCredScore = "Minimum Credit Score";
  static const String minimumMonthlyRevenue = "Minimum Monthly Revenue";
  static const String selectMonthlyRevenue = "Select Minimum Revenue";
  static const String minimumTimeInBusiness = "Minimum Time in Business";
  static const String selectTime = "Select Time";
  static const String restrictedIndustries = "Restricted Industries";
  static const String selectRestrictedIndustries = "Select Restricted Industries";
  static const String maximumOfNSFPerMonth = "Maximum # of NSFs per Month";
  static const String selectOfNSFPerMonth = "Select # of NSFs";
  static const String restrictedStates = "Restricted States";
  static const String selectRestrictedStates = "Select Restricted States";

  static const String industries = "Industries";
  static const String selectIndustry = "Select Industry";
  static const String selectState = "Select State";
  static const String preferredIndustries = "Preferred Industries";
  static const String selectPreferredIndustries = "Select Preferred Industries";

  static const String maximumFundingAmounts = "Maximum Funding Amounts";
  static const String selectFundingAmounts = "Select Funding Amounts";
  static const String maximumTermLength = "Maximum Term Length";
  static const String selectTermLength = "Select Term Length";
  static const String startingBuyRates = "Starting Buy Rates";
  static const String selectStartingBuyRates = "Select Starting Buy Rates";
  static const String maxUpsellPoints = "Max Upsell Points";
  static const String selectMaxUpsellPoints = "Select Max Upsell Points";
  static const String completeCompanyProfile = "Complete Company Profile";
  static const String loading = "Loading...";

  //** loan preference screen validations
  static const String validateCreditRequirement = "Please select credit";
  static const String validateCreditRequirementAdd = "Please add credit score";
  static const String validateCreditReq500to1000 = "Please add credit score between 500 to 1000";

  static const String validateMinimumMonthlyRevenue = "Please select minimum monthly revenue";
  static const String validateMinimumTimeInBusiness = "Please select minimum time in business";
  static const String validateRestrictedIndustries = "Please select restricted industries";
  static const String validateMaximumOfNSFPerMonth = "Please select maximum # of NSFs per month";
  static const String validateAddMaximumOfNSFPerMonth = "Please add maximum # of NSFs per month";
  static const String validateRestrictedStates = "Please select restricted states";
  static const String validateStates = "Please select states";
  static const String validateIndustries = "Please select industries";
  static const String validateSelectPreferredIndustries = "Please select preferred industries";
  static const String validateResPrefIndustries = "Restricted Industries and Preferred Industries should not to be same";
  static const String validateMaximumFundingAmounts = "Please add funding amounts";
  static const String validateMonthlyRevenueAmounts = "Please add monthly revenue";
  static const String validateMaximumTermLength = "Please select maximum term";
  static const String validateStartingBuyRates = "Please select buy rates";
  static const String validateAddStartingBuyRates = "Please add buy rates";
  static const String validateMaxUpsellPoints = "Please select upsell points";
  static const String validateAddMaxUpsellPoints = "Please add upsell points";

  //create feed validation
  static const String validateCategories = 'Please select the category';
  static const String validateContent = 'Please enter the post content';
  static const String loanAmountValidation = 'Please enter the loan amount';
  static const String loanIndustryValidation = 'Please select loan Industry';
  static const String validateAddTagScoreboard = "Please select validate tags";
  static const String validateSelectedIndustries = "Please select validate Industries";
  static String validateFunderBrokerName = userSingleton.userType == 'FU' ? "Please select broker name" : "Please select funder name";
  static String validateGroupName = "Please enter a valid group Name";
  static String searchFunderCompany = "Search by Funder or Company Name";
  static String searchBrokerCompany = "Search by Broker or Company Name";
  static String noBrokerCompany = "No Broker or Company data Found";
  static String noFunderCompany = "No Funder or Company data Found";


  //static const String validateImageVideo = 'Please select any image or video for post';
  //**Thanks Submission screen
  static const String thanksSubmission = "Thanks for your submission!";
  static const String weWillBeInTouch = "We will be in touch";
  static const String bDone = 'Done';
  static const String bLogin = 'Login';

  static const String youAreAlmostThere = 'You’re Almost There!';
  static const String reviewTeam = 'Our team will review and approve your account within 24hrs.';

  static const String logoutWarningMsg = "logoutWarningMsg";
  static const String yesLabel = "yesLabel";
  static const String noLabel = "noLabel";

  static const String appLatitude = "33.78151350894746";
  static const String appLongitude = "-84.41362900386731";

  //**location screen
  static const String locationAlertTitle = "Location";
  static const String locationAlertMessage = "Iso Net needs to access your accurate location in order to the smooth working of the app.";
  static const String notificationAlert = 'Allow Iso Net to send you notifications';

  static const String strCamera = "Camera";
  static const String strGallery = "Gallery";
  static const String strImages = "Images";
  static const String strVideos = "Videos";

  static const String strSelectImagesUsing = "Select Images using";
  static const String strSelectVideosUsing = "Select Videos using";

  static const String chooseCameraGalleryImages = "Choose multiple images or select from Camera";
  static const String chooseCameraGalleryVideos = "Choose multiple videos or record from Camera";

//***Media Permission
  static const String mediaAlertTitle = "Photos";
  static const String mediaAlertMessage = "Choose image from gallery or click from camera.";
  static const String downloadAlertMessage = "Choose image from gallery or click from camera.";

  static const String chooseMedia = "Multiple Media";
  static const String chooseMediaMessage = "Choose multiple images or video from gallery.";
  static const String chooseMediaCameraMessage = "Choose one option from below to capture a photo or video.";

  static const String noInternetMsg = "Check your internet connection";

  //*** Exit setup dialog
  static const String appName = "Iso Net";
  static const String exitSetupContent = "Are you sure you want to quit the registration? You need to login again to complete the process.";
  static const String signOut = "Are you sure you want to Sign out?";
  static const String blockMessage = "Are you sure you want to block";
  static const String unBlockMessage = 'Are you sure you want to unblock';
  static const String alreadyBlockMessage = 'You have blocked this account. Click on the button below to unblock';

  static const bSignOut = 'Sign out';

//**Bottom Tab
  static const String newsFeed = "News Feed";
  static const String forum = "Forum";
  static const String search = "Search";
  static const String network = "Network";
  static const String messenger = "Messenger";
  static const String searchMessage = "Search Message";

  //**News Feed
  static const String feed = "Feed";
  static const String scoreBoard = "Scoreboard";
  static const String sortBy = "Sort By";
  static const String viewAll = "View All";
  static const String connect = "Connect";
  static const String requested = 'Requested';
  static const String notConnected = 'NotConnected';
  static const String comments = "Comments";
  static const String comment = "Comment";
  static const String send = "Send";
  static const String sendPost = "Send Post";
  static const String sendForum = "Send Forum";
  static const String article = 'article';
  static const String approvals = 'Approvals';
  static const String approve = 'Approve';
  static const String approvedf = 'Approved';
  static const String decline = 'Decline';
  static const String reject = 'Reject';
  static const String rejected = 'Rejected';

  //** notifications strings
  static const String defaultNotificationChannelKey = 'default';

  //** create feed strings
  static const String newPost = 'New Post';
  static const String newForum = 'New Forum';
  static const String post = 'Post';
  static const String posts = 'Posts';
  static const String reportPost = 'Report Post';
  static const String enterReason = 'Enter reason for report';
  static const String reportForum = 'Report Forum';
  static const String reportArticle = 'Report Article';
  static const String reportUser = 'Report User';
  static const String reportComment = 'Report Comment';
  static const String flagUser = 'Flag User';
  static const String blockUser = 'Block User';
  static const String block = 'Block';
  static const String unblock = 'Unblock';
  static const String save = 'Save';

  static const String unBlockUser = 'Unblock User';
  static const String user = 'User';

  static const String flagPost = 'Flag Post';
  static const String flagForum = 'Flag Forum';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String reviews = 'Reviews';
  static const String review = 'Review';
  static const String enterReview = 'Enter your review';
  static const String leaveAReview = 'Leave a Review';
  static const String seeAll = 'See All';
  static const String employees = 'Employees';
  static const String searchEmployees = 'Search Employees';
  static const String sessionExpire = 'Session expired';

  //***Company profile strings
  static const String navigate = 'Navigate';
  static const String call = 'Call';
  static const String leaveReview = 'Leave a Review';
  static const String shareExp = 'Share your experience';
  static const String share = 'Share';
  static const String addReview = 'Add your Review...';
  static const String reviewValidate = 'Please enter review';
  static const String reviewAddSuccessMessage = 'Review added';
  static const String dealPreferences = 'Deal Preferences';
  static const String deals = 'Deals';


  //***Forum String
  static const String category = "Category";
  static const String categories = "Categories";

  //***Search tab screen
  static const String searchScreenMessage = 'You can search by users,\n'
      'companies or keywords';
  static const String searchMessageScreen = 'You can search by keywords';
  static const String searchSubTitle = 'You can search by brokers, funders or companies.';
  static const String findFunderB = 'Funder Finder';
  static const String dealPlacement = 'Deal Placement';
  static const String loanDetails = 'Loan Details';
  static const String dealDetails = 'Deal Details';
  static const String loanAmount = 'Loan Amount';
  static const String loanFundingAmount = 'Funding Amounts';
  static const String monthlyRevenue = 'Monthly Revenue';
  static const String loanIndustry = 'Loan Industry';
  static const String tags = 'Tags';
  static const String selectTags = 'Select Tags';
  static const String addTags = 'Add Tags';
  static const String funderName = 'Funder Name';
  static const String brokerName = 'Broker Name';
  static const String selectFunderName = 'Select Funder';
  static const String selectBrokerName = 'Select Broker';

  static const String filterBy = 'Filter By';
  static const String industry = 'Industry';
  static const String selectedIndustry = 'Select Industries';
  static const String findFunder = 'Find a Funder';
  static const String editPreference = 'Edit Preferences';
  static const String searchMessages = 'Search Messages';
  static const String validateFindFunderIndustry = 'Please select industry';
  static const String validateFindFunderState = 'Please select state';
  static const String preferred = 'Preferred';

  ///Notification String
  static const String notificationTypeKey = 'notification_type';
  static const String feedIdKey = 'feed_id';
  static const String forumIdKey = 'forum_id';
  static const String companyIdKey = 'company_id';
  static const String roomNameKey = 'room_name';
  static const String groupNameKey = 'group_name';
  static const String isGroupKey = 'is_group';
  static const String clearAll = 'Clear All';

  ///****Network tab
  static const String viewMyNetwork = 'View My Network';
  static const String request = 'Requests';
  static const String brokerYouKnow = 'Brokers You May Know';
  static const String funderYouKnow = 'Funders You May Know';
  static const String suggestionScreen = 'Suggestions';
  static const String pendingRequest = 'No Pending Requests Yet!';
  static String noSuggestion = userSingleton.userType == 'FU' ? '' : 'You will see suggestions here.';

  ///****My_profile & setting screen string
  static const String me = 'Me';
  static const String settingText = 'Settings';
  static const String appText = 'App';
  static const String accountText = 'Account';
  static const String editAccountText = 'Edit Account';
  static const String companyText = 'Company';
  static const String editCompanyText = 'Edit Company';

  static const String subscriptionText = 'Subscription';
  static const String referralsText = 'Referrals';
  static const String notificationsText = 'Notifications';
  static const String blockConnection = 'Blocked Connections';
  static const String aboutText = 'About';
  static const String privacyPolicyText = 'Privacy Policy';
  static const String termsOfUseText = 'Terms of Use';
  static const String myBookMarkText = 'My Bookmarks';
  static const String userInterest = "User Interests";
  static const String selectUserInterest = "Select User Interests";
  static const String updateProfileMessage = 'Successfully Updated';
  static const String delete = 'Delete';
  static const String deleteAccount = 'Delete Account';
  static const String deleteAccountMessage = 'Are you sure you want to delete your account?';

  static const String newMessageText = 'New Message';
  static const String searchAName = 'Search a name';
  static const String updateButton = "Update";
  static const String pushNotification = 'Push Notification';
  static const String writeAMessage = 'Write a Message...';
  static const String addGroupName = 'Add Group Name';
  static const String groupName = 'Group Name';

  static const String monthly = 'Monthly';
  static const String yearly = 'Yearly';
  static const String manage = 'Manage';
  static const String currentSub = 'Current Subscription';
  static const String generalKey = 'GENERAL';
  static const String adminKey = 'Admin_Noti';
  static const String newsFeedType = 'Newsfeed';
  static const String connectReType = 'CR';
  static const String newsFeedNotification = 'News Feed Notification';
  static const String requestNotification = 'Request Notification';
  static const String notification = 'Notification';
  static const String notifications = 'Notifications';
  static const String allC = 'All';
  static const String notificationSubtitle = 'Receive reminder notifications to your phone';
  static const String strPhoto = 'Photo';

  static const String noRecord = 'No Record Found!';
  static const String noReviews = 'No Reviews Yet!';
  static const String reportFeed = 'Report Feed';

  ///Referral screen text
  static const String referFrnd = 'Refer a friend';
  static const referQuotes = 'Share Iso Net and once they become,\n'
      'a paying member you earn \$10! Share\n'
      ' your code below:';

  ///
  static const String isoNetAdmin = 'IsoNet Admin';
  static const String deleteComment = 'Delete Comment';
  static const String successDeleteComment = 'Comment Deleted';
  static const String deletePost = 'Delete Post';
  static const String deletePostSuccess = 'Post Deleted';
  static const String deleteFeed = 'Delete Feed';
  static const String deleteFeedSuccess = 'Feed Deleted';
  static const String deleteForum = 'Delete Forum';
  static const String deleteForumSuccess = 'Forum Deleted';
  static const String noMessageFound = 'No Messages Yet!';
  static const String searchChatMessages = 'You can search chat messages here!';
  static const String noRecordFound = 'No records found!';
  static const String noForumsYet = 'No Forums Yet!';
  static const String noPostsYet = 'No Posts Yet!';
  static const String noLoanText = 'You will see your loans here!';
  static const String noScoreboardAvailable = 'No Scoreboard Available.';
  static const String noLoansYet = 'No Loans Yet!';
  static const String noBlockConnection = 'No Blocked Users Yet!';
  static const String noUserNetwork = 'No users in your network';

  static const String noNotification = 'You will see all notifications here.';
  static const String all = 'All';
  static const String funder = 'Funder';
  static const String funderFeed = 'Funder Feed';

  static const String broker = 'Broker';
  static const String brokerFeed = 'Broker Feed';
  static const String postTo = 'Post to';
  static const String successReportedCommentMSG = 'The comment has been successfully reported.';
  static const String okB = 'Ok';
  static const String approved = 'approved';
  static const String android = 'android';
  static const String ios = 'ios';
  static const String reply = 'Reply';
  static const String replies = 'Replies';

  ///*************** Startup screen slider text ***************///
  static const String startupSlider1String = 'Get Access to the Member-Exclusive Network';
  static const String startupSlider2String = 'Connect with Brokers & Funders';
  static const String startupSlider3String = 'Manage Your Communication Seamlessly';

  ///*************** Subscription screen slider text ***************///
  static const String subscribeSlider1String = 'Get Access to the Member-Exclusive Network';
  static const String subscribeSlider2String = 'Connect with Brokers & Funders';
  static const String subscribeSlider3String = 'Manage Your Communication Seamlessly';

  ///Choose_funder_broker screen text
  static const String imBroker = "I'm a Broker";
  static const String imFunder = "I'm a Funder";
  static const String br = 'BR';
  static const String fu = 'FU';

  ///User interest screen strings
  static const String interests = 'Interests';
  static const String skip = 'Skip';
  static const String btnYes = 'Yes';
  static const String btnNo = 'No';
  static const String leftGroupMsg = 'Are you sure you want to leave this group?';
  static const String leftChatMsg = 'Are you sure you want to delete this chat?';

}
