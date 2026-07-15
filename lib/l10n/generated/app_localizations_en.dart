// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FeedPlan';

  @override
  String get homeTitle => 'My Projects';

  @override
  String get newProject => 'New Project';

  @override
  String get editProject => 'Edit Project';

  @override
  String get deleteProject => 'Delete';

  @override
  String get deleteProjectConfirm =>
      'Are you sure you want to delete this project?';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get confirm => 'Confirm';

  @override
  String get noProjects => 'No projects yet. Create your first one!';

  @override
  String get createProfile => 'Create Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profileName => 'Name';

  @override
  String get profileBio => 'Bio';

  @override
  String get profileAvatar => 'Profile Picture';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get addVideo => 'Add Video';

  @override
  String get addMedia => 'Add Media';

  @override
  String get reorder => 'Reorder';

  @override
  String get crop => 'Crop';

  @override
  String get trim => 'Trim';

  @override
  String get aspectRatio => 'Aspect Ratio';

  @override
  String get square => 'Square (1:1)';

  @override
  String get portrait => 'Portrait (4:5)';

  @override
  String get story => 'Story (9:16)';

  @override
  String get landscape => 'Landscape (16:9)';

  @override
  String get gridPreview => 'Grid Preview';

  @override
  String get export => 'Export';

  @override
  String get exporting => 'Exporting...';

  @override
  String get exportSuccess => 'Carousel exported successfully!';

  @override
  String get exportPath => 'Saved to gallery';

  @override
  String get openGallery => 'Open Gallery';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get settings => 'Settings';

  @override
  String get warningNoMedia => 'Add at least one media item to export.';

  @override
  String get carouselEditor => 'Carousel Editor';

  @override
  String get slide => 'Slide';

  @override
  String get slideOf => 'of';

  @override
  String get importGrid => 'Import from grid';

  @override
  String get startFromScratch => 'Start from scratch';

  @override
  String get postInGrid => 'Post in grid';

  @override
  String get newPost => 'New Post';

  @override
  String get emptyGrid => 'Your grid is empty. Add posts to see the preview.';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String deleteItemCount(int count) {
    return 'Delete $count item';
  }

  @override
  String deleteItemCountConfirm(int count) {
    return 'Are you sure you want to delete $count item?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get errorLogs => 'Error Logs';

  @override
  String get noPostsYet => 'No posts yet';

  @override
  String get tapToCreateCarousel => 'Tap + to create your first carousel';

  @override
  String errorSavingImage(String error) {
    return 'Error saving image: $error';
  }

  @override
  String get premiumFeature => 'Premium feature';

  @override
  String premiumLimitReached(String feature) {
    return 'You\'ve reached the free limit for $feature. Upgrade to Premium to unlock unlimited access.';
  }

  @override
  String get notNow => 'Not now';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get premium => 'Premium';

  @override
  String get tapToChangePhoto => 'Tap to change photo';

  @override
  String get name => 'Name';

  @override
  String get bio => 'Bio';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';

  @override
  String get deleteCarousel => 'Delete carousel';

  @override
  String get addPagesAndPhotos => 'Add pages and photos to build your carousel';

  @override
  String get addFirstPage => 'Add First Page';

  @override
  String get addImageToCurrentPage => 'Add image to current page';

  @override
  String get addPage => 'Add page';

  @override
  String get applyGridLayout => 'Apply grid layout';

  @override
  String get exportPagesToGallery => 'Export pages to gallery';

  @override
  String get centerImage => 'Center image';

  @override
  String get deleteSelectedImage => 'Delete selected image';

  @override
  String get exportingPages => 'Exporting pages';

  @override
  String savingPagesToGallery(int count) {
    return 'Saving $count page to gallery...';
  }

  @override
  String get allPagesSaved => 'All pages saved to gallery!';

  @override
  String pagesSavedOf(int saved, int total) {
    return '$saved of $total pages saved to gallery.';
  }

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get pageCreatedTapAgain => 'Page created. Tap + again to add image.';

  @override
  String errorAddingImage(String error) {
    return 'Error adding image: $error';
  }

  @override
  String get deleteCarouselConfirm => 'Delete carousel?';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get tapToAdd => 'Tap to add';

  @override
  String get chooseGridLayout => 'Choose a grid layout';

  @override
  String get viewCarousel => 'View Carousel';

  @override
  String get noPagesInCarousel => 'No pages in this carousel';

  @override
  String get goBack => 'Go Back';

  @override
  String get readyToExport => 'Ready to export';

  @override
  String get exportComingSoon => 'Export feature coming soon!';

  @override
  String get saveToGallery => 'Save to Gallery';

  @override
  String get noLogsFound => 'No logs found.';

  @override
  String get copyLogs => 'Copy logs';

  @override
  String get logsCopied => 'Logs copied to clipboard';

  @override
  String get clearLogs => 'Clear logs';

  @override
  String get clearLogsConfirm => 'Clear logs?';

  @override
  String get clearLogsMessage => 'This will delete all saved logs.';

  @override
  String get refresh => 'Refresh';

  @override
  String get enterInstagramUsername => 'Enter an Instagram username';

  @override
  String get dailyLimitReached =>
      'Daily limit reached. Subscribe to Premium to fetch more.';

  @override
  String errorFetchingPosts(String error) {
    return 'Error fetching posts: $error';
  }

  @override
  String get posts => 'posts';

  @override
  String get instagramUsername => 'Instagram username';
}
