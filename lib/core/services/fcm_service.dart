import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:web_dashboard/core/Database/Local/local_storage.dart';

// Handle background messages - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 Background message received: ${message.messageId}');
  print('   Title: ${message.notification?.title}');
  print('   Body: ${message.notification?.body}');
}

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // Callbacks for handling notifications
  Function(RemoteMessage)? onForegroundMessage;
  Function(RemoteMessage)? onMessageOpenedApp;
  Function(String)? onTokenRefresh;
  
  /// Initialize FCM Service
  Future<void> initialize() async {
    print('🔥 Initializing FCM Service...');
    
    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    
    // Request permission
    await _requestPermission();
    
    // Get and store FCM token
    String? token = await getToken();
    if (token != null) {
      await _storeFcmToken(token);
      print('✅ FCM Token obtained: ${token.substring(0, 20)}...');
    }
    
    // Listen to token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('🔄 FCM Token refreshed');
      await _storeFcmToken(newToken);
      onTokenRefresh?.call(newToken);
    });
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Check if app was opened from a notification (when app was terminated)
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
    
    print('✅ FCM Service initialized successfully');
  }
  
  /// Request notification permission
  Future<NotificationSettings> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    print('📱 Notification permission status: ${settings.authorizationStatus}');
    return settings;
  }
  
  /// Get FCM Token
  Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      print('❌ Error getting FCM token: $e');
      return null;
    }
  }
  
  /// Store FCM token locally
  Future<void> _storeFcmToken(String token) async {
    await LocalStorage.setSecureData('fcm_token', token);
  }
  
  /// Get stored FCM token
  static Future<String?> getStoredToken() async {
    return await LocalStorage.getSecureData('fcm_token');
  }
  
  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('📬 Foreground message received:');
    print('   Title: ${message.notification?.title}');
    print('   Body: ${message.notification?.body}');
    print('   Data: ${message.data}');
    
    onForegroundMessage?.call(message);
  }
  
  /// Handle when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('📲 App opened from notification:');
    print('   Title: ${message.notification?.title}');
    print('   Data: ${message.data}');
    
    onMessageOpenedApp?.call(message);
  }
  
  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Error subscribing to topic $topic: $e');
    }
  }
  
  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Error unsubscribing from topic $topic: $e');
    }
  }
  
  /// Delete FCM token (useful for logout)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      await LocalStorage.removeSecureData('fcm_token');
      print('🗑️ FCM token deleted');
    } catch (e) {
      print('❌ Error deleting FCM token: $e');
    }
  }
}

