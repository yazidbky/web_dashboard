class Endpoints {
  static const loginEndPoint = "/api/auth/ing/login";
  static const registerEndPoint = "/api/auth/inj/register";
  static const userProfileEndPoint = "/api/auth/ing/profile";
  static const myFarmersEndPoint = "/api/farmers/my-farmers";
  
  // Notification endpoints
  static const registerFcmTokenEndPoint = "/api/notifications/register-token";
  static const sendNotificationEndPoint = "/api/notifications/send";
  static const getNotificationsEndPoint = "/api/notifications";
  static const markNotificationReadEndPoint = "/api/notifications/read";

  // Weather endpoints
  static const weatherFetchAndSaveEndPoint = "/api/weather/fetch-and-save";
  
  // Get today's weather endpoint
  /// GET /api/weather/today/{landId}
  static String getTodayWeatherEndPoint(int landId) =>
      "/api/weather/today/$landId";
  
  // Get weather forecast (3 days) endpoint
  /// GET /api/weather/forecast/{landId}
  static String getWeatherForecastEndPoint(int landId) =>
      "/api/weather/forecast/$landId";

  // Soil data endpoints
  /// GET /api/soil/{farmerId}/{landId}/{section}
  static String getSoilDataEndPoint(int farmerId, int landId, String section) =>
      "/api/soil/$farmerId/$landId/$section";
  
  /// GET /api/soil/{farmerId}/{landId}/sections
  static String getAllSoilSectionsEndPoint(int farmerId, int landId) =>
      "/api/soil/$farmerId/$landId/sections";

  // Dashboard overview endpoint
  static const overviewEndPoint = "/api/overview";

  // Farmers connect endpoint
  static const connectFarmerEndPoint = "/api/farmers/connect";

  // Get farmer lands endpoint
  /// GET /api/farmers/{farmerId}/lands
  static String getFarmerLandsEndPoint(int farmerId) =>
      "/api/farmers/$farmerId/lands";

  // Farmers disconnect endpoint
  /// DELETE /api/farmers/disconnect/{farmerId}
  static String disconnectFarmerEndPoint(int farmerId) =>
      "/api/farmers/disconnect/$farmerId";
}