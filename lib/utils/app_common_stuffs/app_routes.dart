import 'package:get/get.dart';
import 'package:iso_net/bindings/authentication/forgot_password_binding.dart';
import 'package:iso_net/bindings/authentication/get_started_binding.dart';
import 'package:iso_net/bindings/authentication/otp_binding.dart';
import 'package:iso_net/bindings/authentication/sign_in_screen_binding.dart';
import 'package:iso_net/bindings/authentication/startup_screen_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/article_detail_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/bottom_tabs_bindings.dart';
import 'package:iso_net/bindings/bottom_tabs/company_binding/company_employeelist_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/company_binding/company_profile_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/company_binding/employee_profile_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/create_feed_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/forum_category_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/loan_approval_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/network/viewall_request_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/network/viewmy_network_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/search/search_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import 'package:iso_net/bindings/my_profile/block_connection_binding.dart';
import 'package:iso_net/bindings/my_profile/bookmark_binding.dart';
import 'package:iso_net/bindings/my_profile/bookmark_detail_binding.dart';
import 'package:iso_net/bindings/my_profile/my_allfeed_binding.dart';
import 'package:iso_net/bindings/my_profile/my_allloanlist_binding.dart';
import 'package:iso_net/bindings/my_profile/notification_listing_binding.dart';
import 'package:iso_net/bindings/my_profile/notification_setting_binding.dart';
import 'package:iso_net/bindings/my_profile/terms_privacy_binding.dart';
import 'package:iso_net/bindings/user/company_image_binding.dart';
import 'package:iso_net/bindings/user/create_company_binding.dart';
import 'package:iso_net/bindings/user/details_info_binding.dart';
import 'package:iso_net/bindings/user/loan_preference_binding.dart';
import 'package:iso_net/bindings/user/subscribe_binding.dart';
import 'package:iso_net/bindings/user/user_backimage_binding.dart';
import 'package:iso_net/bindings/user/user_interest_binding.dart';
import 'package:iso_net/bindings/user/user_profileimage_binding.dart';
import 'package:iso_net/ui/authentication/choose_funder_broker_screen.dart';
import 'package:iso_net/ui/authentication/forgot_password_screen.dart';
import 'package:iso_net/ui/authentication/get_started_screen.dart';
import 'package:iso_net/ui/authentication/otp_screen.dart';
import 'package:iso_net/ui/authentication/sign_in_screen.dart';
import 'package:iso_net/ui/authentication/startup_screen.dart';
import 'package:iso_net/ui/bottom_tabs/dashboard_tab_bar.dart';
import 'package:iso_net/ui/bottom_tabs/search/search_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/Network/viewall_request_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/Network/viewall_suggestion_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/Network/viewmy_network_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/forum/category_forumlist_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/article_detail_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/company_screens/company_employeeslist_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/company_screens/company_profile_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/company_screens/company_review_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/company_screens/employee_profile_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/create_feed_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/loan_approval_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/settings_screen/company_filter_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/settings_screen/user_setting_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/user_screens/user_profile_screen.dart';
import 'package:iso_net/ui/my_profile/bookmark_detail_screen.dart';
import 'package:iso_net/ui/my_profile/my_allfeed_screen.dart';
import 'package:iso_net/ui/my_profile/my_allloanlist_screen.dart';
import 'package:iso_net/ui/my_profile/my_profile_screen.dart';
import 'package:iso_net/ui/my_profile/notification_listing_screen.dart';
import 'package:iso_net/ui/my_profile/notification_setting_screen.dart';
import 'package:iso_net/ui/my_profile/privacy_policy_screen.dart';
import 'package:iso_net/ui/my_profile/terms_condition_screen.dart';
import 'package:iso_net/ui/user/company_image_screen.dart';
import 'package:iso_net/ui/user/create_company_screen.dart';
import 'package:iso_net/ui/user/detail_info_screen.dart';
import 'package:iso_net/ui/user/loan_prefrence_screen.dart';
import 'package:iso_net/ui/user/signup_completed_screen.dart';
import 'package:iso_net/ui/user/subscribe_screen.dart';
import 'package:iso_net/ui/user/user_approve_waiting_screen.dart';
import 'package:iso_net/ui/user/user_backimage_screen.dart';
import 'package:iso_net/ui/user/user_interest_screen.dart';
import 'package:iso_net/ui/user/user_profileimage_screen.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';

import '../../bindings/authentication/choose_funder_broker_binding.dart';
import '../../bindings/bottom_tabs/chat_tab/add_group_name_binding.dart';
import '../../bindings/bottom_tabs/chat_tab/chat_screen_binding.dart';
import '../../bindings/bottom_tabs/chat_tab/create_new_message_binding.dart';
import '../../bindings/bottom_tabs/chat_tab/one_to_one_chat_binding.dart';
import '../../bindings/bottom_tabs/company_binding/company_review_binding.dart';
import '../../bindings/bottom_tabs/create_scoreboard_binding.dart';
import '../../bindings/bottom_tabs/network/viewall_suggestion_binding.dart';
import '../../bindings/bottom_tabs/scoreboard_binding.dart';
import '../../bindings/bottom_tabs/setting_binding/company_setting_binding.dart';
import '../../bindings/bottom_tabs/setting_binding/filter_setting_binding.dart';
import '../../bindings/bottom_tabs/setting_binding/user_setting_binding.dart';
import '../../bindings/bottom_tabs/user_binding/user_edit_screen_binding.dart';
import '../../bindings/my_profile/my_profile_binding.dart';
import '../../ui/bottom_tabs/tabs/news_feed/chat_tab/add_group_name_screen.dart';
import '../../ui/bottom_tabs/tabs/news_feed/chat_tab/chat_screen.dart';
import '../../ui/bottom_tabs/tabs/news_feed/chat_tab/create_new_message.dart';
import '../../ui/bottom_tabs/tabs/news_feed/chat_tab/one_to_one_chat_screen.dart';
import '../../ui/bottom_tabs/tabs/news_feed/create_filter_scoreboard_screen.dart';
import '../../ui/bottom_tabs/tabs/news_feed/create_scoreboard.dart';
import '../../ui/bottom_tabs/tabs/news_feed/scoreboard_screen.dart';
import '../../ui/bottom_tabs/tabs/news_feed/settings_screen/company_setting_screen.dart';
import '../../ui/bottom_tabs/tabs/news_feed/user_screens/user_edit_screen.dart';
import '../../ui/my_profile/block_connection_screen.dart';
import '../../ui/my_profile/bookmark_setting_screen.dart';
import '../../ui/user/check_location_screen.dart';

class AppRoutes {
  static List<GetPage> routes = [
    GetPage(
      name: ScreenRoutesConstants.startupScreen,
      page: () => const StartupScreen(),
      binding: StartupScreenBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.signInScreen,
      page: () => const SignInScreen(),
      binding: SignInScreenBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.forgotPwdScreen,
      page: () => const ForgotPwdScreen(),
      binding: ForgotPwdBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.funderBrokerScreen,
      page: () => const ChooseFunderBrokerScreen(),
      binding: FunderBrokerBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.getStartedScreen,
      page: () => const GetStartedScreen(),
      binding: GetStartedBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.otpScreen,
      page: () => const OtpScreen(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.detailScreen,
      page: () => const DetailInfoScreen(),
      binding: DetailInfoBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.subscribeScreen,
      page: () => const SubscribeScreen(),
      binding: SubscribeBinding(),
      arguments: false,
    ),
    GetPage(
      name: ScreenRoutesConstants.checkLocationScreen,
      page: () => const CheckLocationScreen(),
    ),
    GetPage(
      name: ScreenRoutesConstants.createCompany,
      page: () => const CreateCompanyScreen(),
      binding: CreateCompanyBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.companyImageScreen,
      page: () => const CompanyImageScreen(),
      binding: CompanyImageBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.loanPreferenceScreen,
      page: () => const LoanPreferencesScreen(),
      binding: LoanPreferenceBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.userProfileImageScreen,
      page: () => const UserProfileImageScreen(),
      binding: UserProfileImageBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.userBackImageScreen,
      page: () => const UserBackImageScreen(),
      binding: UserBackImageBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.signUpCompletedScreen,
      page: () => const SignUpCompletedScreen(),
    ),
    GetPage(
      name: ScreenRoutesConstants.userInterestScreen,
      page: () => UserInterestScreen(),
      binding: UserInterestBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.bottomTabsScreen,
      page: () => const DashboardTabBar(),
      binding: BottomTabsBindings(),
    ),
    GetPage(
      name: ScreenRoutesConstants.userApproveWaitingScreen,
      page: () => const UserApproveWaitingScreen(),
    ),
    GetPage(
      name: ScreenRoutesConstants.createFeedScreen,
      page: () => CreateFeedScreen(),
      binding: CreateFeedBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.userProfileScreen,
      page: () => UserProfileScreen(),
      binding: UserProfileBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.companyProfileScreen,
      page: () => const CompanyProfile(),
      binding: CompanyProfileBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.companyReviewScreen,
      page: () => const ListCompanyReview(),
      binding: CompanyReviewBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.companyEmployeeListScreen,
      page: () => const CompanyEmployeeScreen(),
      binding: CompanyEmployeeListBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.employeeProfileScreen,
      page: () => EmployeeProfileScreen(),
      binding: EmployeeProfileBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.categoryForumListScreen,
      page: () => const CategoryForumListScreen(),
      binding: ForumCategoryBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.articleDetailScreen,
      page: () => ArticleDetail(),
      binding: ArticleDetailBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.scoreBoardScreen,
      page: () => const ScoreBoard(),
      binding: ScoreBoardBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.createScoreBoardScreen,
      page: () => const CreateScoreBoardScreen(),
      binding: CreateScoreBoardBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.filterScoreboardLoanScreen,
      page: () => const CreateFilterScoreboard(),
      binding: CreateScoreBoardBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.loanApprovalScreen,
      page: () => const LoanApprovalScreen(),
      binding: LoanApprovalBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.chatNewMessageScreen,
      page: () => const CreateNewMessage(),
      binding: CreateNewMessageBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.chatScreen,
      page: () => const ChatScreen(),
      binding: ChatScreenBinding(),
    ),

    GetPage(
      name: ScreenRoutesConstants.viewAllRequestScreen,
      page: () => const ViewAllRequestScreen(),
      binding: ViewAllRequestBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.viewAllSuggestionScreen,
      page: () => const ViewAllSuggestionScreen(),
      binding: ViewAllSuggestionBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.viewMyNetWorkScreen,
      page: () => const ViewMyNetworkScreen(),
      binding: ViewMyNetworkBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.profileSettingScreen,
      page: () => UserSettingScreen(),
      binding: UserSettingBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.editUserProfileScreen,
      page: () => const UserEditScreen(),
      binding: UserEditScreenBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.settingCompanyScreen,
      page: () => const CompanySettingScreen(),
      binding: CompanySettingBinding(),
    ),

    ///My Profile Screen
    GetPage(
      name: ScreenRoutesConstants.myProfileScreen,
      page: () => const MyProfileScreen(),
      binding: MyProfileBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.myAllFeedScreen,
      page: () => const MyAllFeedScreen(),
      binding: MyAllFeedBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.myLoanListScreen,
      page: () => const MyAllLoanListScreen(),
      binding: MyAllLoanListBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.settingFilterScreen,
      page: () => const CompanyFilterScreen(),
      binding: CompanyFilterBinding(),
    ),
    /*GetPage(
      name: ScreenRoutesConstants.editMyAccountScreen,
      page: () => const EditMyAccountScreen(),
      binding: EditMyAccountBinding(),
    ),*/
    GetPage(
      name: ScreenRoutesConstants.notificationSettingScreen,
      page: () => const NotificationSettingScreen(),
      binding: NotificationSettingBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.notificationListingScreen,
      page: () => const NotificationListingScreen(),
      binding: NotificationListingBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.bookMarkScreen,
      page: () => const BookMarkScreen(),
      binding: BookMarkBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.bookmarkDetailScreen,
      page: () => const BookMarkDetailScreen(),
      binding: BookMarkDetailBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.oneToOneChatScreen,
      page: () =>  OneToOneChatScreen(),
      binding: OneToOneChatBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.addGroupNameScreen,
      page: () => const AddGroupNameScreen(),
      binding: AddGroupNameBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.privacyPolicyScreen,
      page: () => const PrivacyPolicyScreen(),
      binding: TermsPrivacyBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.termsConditionScreen,
      page: () => const TermsConditionScreen(),
      binding: TermsPrivacyBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.blockedConnectionScreen,
      page: () => const BlockConnectionScreen(),
      binding: BlockConnectionBinding(),
    ),
    GetPage(
      name: ScreenRoutesConstants.searchScreen,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
    // GetPage(
    //   name: ScreenRoutesConstants.chatFilterScreen,
    //   page: () => const ChatFilterScreen(),
    //   binding: ChatFilterBinding(),
    // ),
  ];
}
