class ApiPaths {
  static String mainDirection = "https://matager.kaizensites.net/api";

  static String signUp = mainDirection + "/signup";

  static String login = mainDirection + "/login";

  static String updateProfile = mainDirection + "/updateprofile";

  static String allCategory = mainDirection + "/categories";

  static String singleCategoryStories(matgerId, lat, lng) =>
      mainDirection + "/stores?matger_id=$matgerId&lat=$lat&lng=$lng";

  static String singleStore(matgerId) => mainDirection + "/stores/$matgerId";

  static String storeSubCategory(matgerId, categoryId) =>
      mainDirection + "/storecategory/subcategories/?store_id=$matgerId&category=$categoryId";

  static String storeSubCategoryProduct(matgerId, subcategoryId) =>
      mainDirection + "/stores/subcategories/products?store_id=$matgerId&sub_category=$subcategoryId";

}
