import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'FeedPlan'**
  String get appTitle;

  /// Title for the home/projects screen
  ///
  /// In en, this message translates to:
  /// **'My Projects'**
  String get homeTitle;

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @editProject.
  ///
  /// In en, this message translates to:
  /// **'Edit Project'**
  String get editProject;

  /// No description provided for @deleteProject.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteProject;

  /// No description provided for @deleteProjectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this project?'**
  String get deleteProjectConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @noProjects.
  ///
  /// In en, this message translates to:
  /// **'No projects yet. Create your first one!'**
  String get noProjects;

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Profile'**
  String get createProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @profileBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profileBio;

  /// No description provided for @profileAvatar.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profileAvatar;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @addVideo.
  ///
  /// In en, this message translates to:
  /// **'Add Video'**
  String get addVideo;

  /// No description provided for @addMedia.
  ///
  /// In en, this message translates to:
  /// **'Add Media'**
  String get addMedia;

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// No description provided for @crop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// No description provided for @trim.
  ///
  /// In en, this message translates to:
  /// **'Trim'**
  String get trim;

  /// No description provided for @aspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatio;

  /// No description provided for @square.
  ///
  /// In en, this message translates to:
  /// **'Square (1:1)'**
  String get square;

  /// No description provided for @portrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait (4:5)'**
  String get portrait;

  /// No description provided for @story.
  ///
  /// In en, this message translates to:
  /// **'Story (9:16)'**
  String get story;

  /// No description provided for @landscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape (16:9)'**
  String get landscape;

  /// No description provided for @gridPreview.
  ///
  /// In en, this message translates to:
  /// **'Grid Preview'**
  String get gridPreview;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Carousel exported successfully!'**
  String get exportSuccess;

  /// No description provided for @exportPath.
  ///
  /// In en, this message translates to:
  /// **'Saved to gallery'**
  String get exportPath;

  /// No description provided for @openGallery.
  ///
  /// In en, this message translates to:
  /// **'Open Gallery'**
  String get openGallery;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @warningNoMedia.
  ///
  /// In en, this message translates to:
  /// **'Add at least one media item to export.'**
  String get warningNoMedia;

  /// No description provided for @carouselEditor.
  ///
  /// In en, this message translates to:
  /// **'Carousel Editor'**
  String get carouselEditor;

  /// No description provided for @slide.
  ///
  /// In en, this message translates to:
  /// **'Slide'**
  String get slide;

  /// No description provided for @slideOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get slideOf;

  /// No description provided for @importGrid.
  ///
  /// In en, this message translates to:
  /// **'Import from grid'**
  String get importGrid;

  /// No description provided for @startFromScratch.
  ///
  /// In en, this message translates to:
  /// **'Start from scratch'**
  String get startFromScratch;

  /// No description provided for @postInGrid.
  ///
  /// In en, this message translates to:
  /// **'Post in grid'**
  String get postInGrid;

  /// No description provided for @newPost.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get newPost;

  /// No description provided for @emptyGrid.
  ///
  /// In en, this message translates to:
  /// **'Your grid is empty. Add posts to see the preview.'**
  String get emptyGrid;

  /// Number of items selected
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// Delete dialog title with count
  ///
  /// In en, this message translates to:
  /// **'Delete {count} item'**
  String deleteItemCount(int count);

  /// Delete dialog confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} item?'**
  String deleteItemCountConfirm(int count);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @errorLogs.
  ///
  /// In en, this message translates to:
  /// **'Error Logs'**
  String get errorLogs;

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPostsYet;

  /// No description provided for @tapToCreateCarousel.
  ///
  /// In en, this message translates to:
  /// **'Tap + to create your first carousel'**
  String get tapToCreateCarousel;

  /// Error message when saving image fails
  ///
  /// In en, this message translates to:
  /// **'Error saving image: {error}'**
  String errorSavingImage(String error);

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium feature'**
  String get premiumFeature;

  /// Premium limit dialog message
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the free limit for {feature}. Upgrade to Premium to unlock unlimited access.'**
  String premiumLimitReached(String feature);

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tapToChangePhoto;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @deleteCarousel.
  ///
  /// In en, this message translates to:
  /// **'Delete carousel'**
  String get deleteCarousel;

  /// No description provided for @addPagesAndPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add pages and photos to build your carousel'**
  String get addPagesAndPhotos;

  /// No description provided for @addFirstPage.
  ///
  /// In en, this message translates to:
  /// **'Add First Page'**
  String get addFirstPage;

  /// No description provided for @addImageToCurrentPage.
  ///
  /// In en, this message translates to:
  /// **'Add image to current page'**
  String get addImageToCurrentPage;

  /// No description provided for @addPage.
  ///
  /// In en, this message translates to:
  /// **'Add page'**
  String get addPage;

  /// No description provided for @applyGridLayout.
  ///
  /// In en, this message translates to:
  /// **'Apply grid layout'**
  String get applyGridLayout;

  /// No description provided for @exportPagesToGallery.
  ///
  /// In en, this message translates to:
  /// **'Export pages to gallery'**
  String get exportPagesToGallery;

  /// No description provided for @centerImage.
  ///
  /// In en, this message translates to:
  /// **'Center image'**
  String get centerImage;

  /// No description provided for @deleteSelectedImage.
  ///
  /// In en, this message translates to:
  /// **'Delete selected image'**
  String get deleteSelectedImage;

  /// No description provided for @exportingPages.
  ///
  /// In en, this message translates to:
  /// **'Exporting pages'**
  String get exportingPages;

  /// Export progress message
  ///
  /// In en, this message translates to:
  /// **'Saving {count} page to gallery...'**
  String savingPagesToGallery(int count);

  /// No description provided for @allPagesSaved.
  ///
  /// In en, this message translates to:
  /// **'All pages saved to gallery!'**
  String get allPagesSaved;

  /// Partial export success message
  ///
  /// In en, this message translates to:
  /// **'{saved} of {total} pages saved to gallery.'**
  String pagesSavedOf(int saved, int total);

  /// Export error message
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @pageCreatedTapAgain.
  ///
  /// In en, this message translates to:
  /// **'Page created. Tap + again to add image.'**
  String get pageCreatedTapAgain;

  /// Error message when adding image fails
  ///
  /// In en, this message translates to:
  /// **'Error adding image: {error}'**
  String errorAddingImage(String error);

  /// No description provided for @deleteCarouselConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete carousel?'**
  String get deleteCarouselConfirm;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap to add'**
  String get tapToAdd;

  /// No description provided for @chooseGridLayout.
  ///
  /// In en, this message translates to:
  /// **'Choose a grid layout'**
  String get chooseGridLayout;

  /// No description provided for @viewCarousel.
  ///
  /// In en, this message translates to:
  /// **'View Carousel'**
  String get viewCarousel;

  /// No description provided for @noPagesInCarousel.
  ///
  /// In en, this message translates to:
  /// **'No pages in this carousel'**
  String get noPagesInCarousel;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @readyToExport.
  ///
  /// In en, this message translates to:
  /// **'Ready to export'**
  String get readyToExport;

  /// No description provided for @exportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Export feature coming soon!'**
  String get exportComingSoon;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to Gallery'**
  String get saveToGallery;

  /// No description provided for @noLogsFound.
  ///
  /// In en, this message translates to:
  /// **'No logs found.'**
  String get noLogsFound;

  /// No description provided for @copyLogs.
  ///
  /// In en, this message translates to:
  /// **'Copy logs'**
  String get copyLogs;

  /// No description provided for @logsCopied.
  ///
  /// In en, this message translates to:
  /// **'Logs copied to clipboard'**
  String get logsCopied;

  /// No description provided for @clearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear logs'**
  String get clearLogs;

  /// No description provided for @clearLogsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear logs?'**
  String get clearLogsConfirm;

  /// No description provided for @clearLogsMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all saved logs.'**
  String get clearLogsMessage;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @enterInstagramUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter an Instagram username'**
  String get enterInstagramUsername;

  /// No description provided for @dailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily limit reached. Subscribe to Premium to fetch more.'**
  String get dailyLimitReached;

  /// Error message when fetching Instagram posts
  ///
  /// In en, this message translates to:
  /// **'Error fetching posts: {error}'**
  String errorFetchingPosts(String error);

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'posts'**
  String get posts;

  /// No description provided for @instagramUsername.
  ///
  /// In en, this message translates to:
  /// **'Instagram username'**
  String get instagramUsername;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
