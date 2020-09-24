class ApiPaths {
  static String mainDirection = "https://matager.kaizensites.net/api";

  static String signUp = mainDirection + "/signup";

  static String login = mainDirection + "/login";

  static String updateProfile = mainDirection + "/updateprofile";

  static String allCategory = mainDirection + "/categories";

  static String singleCategoryStories(matgerId, lat, lng) =>
      mainDirection + "/stores?matger_id=$matgerId&lat=$lat&lng=$lng";
}
