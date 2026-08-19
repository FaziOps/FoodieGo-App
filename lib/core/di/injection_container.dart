import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

import 'package:restaurant_app/core/network/network_info.dart';

// Auth
import 'package:restaurant_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurant_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/update_profile_pic_usecase.dart';
import 'package:restaurant_app/features/auth/presentation/bloc/auth_bloc.dart';

// Menu
import 'package:restaurant_app/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:restaurant_app/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:restaurant_app/features/menu/domain/repositories/menu_repository.dart';
import 'package:restaurant_app/features/menu/domain/usecases/add_menu_item_usecase.dart';
import 'package:restaurant_app/features/menu/domain/usecases/delete_menu_item_usecase.dart';
import 'package:restaurant_app/features/menu/domain/usecases/get_categories_usecase.dart';
import 'package:restaurant_app/features/menu/domain/usecases/get_menu_items_usecase.dart';
import 'package:restaurant_app/features/menu/domain/usecases/update_menu_item_usecase.dart';
import 'package:restaurant_app/features/menu/presentation/bloc/menu_bloc.dart';

// Cart
import 'package:restaurant_app/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:restaurant_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:restaurant_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:restaurant_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/calculate_cart_total_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:restaurant_app/features/cart/domain/usecases/update_quantity_usecase.dart';
import 'package:restaurant_app/features/cart/presentation/bloc/cart_bloc.dart';

// Orders
import 'package:restaurant_app/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:restaurant_app/features/orders/data/repositories/order_repository_impl.dart';
import 'package:restaurant_app/features/orders/domain/repositories/order_repository.dart';
import 'package:restaurant_app/features/orders/domain/usecases/accept_order_usecase.dart';
import 'package:restaurant_app/features/orders/domain/usecases/assign_rider_usecase.dart';
import 'package:restaurant_app/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:restaurant_app/features/orders/domain/usecases/get_all_orders_usecase.dart';
import 'package:restaurant_app/features/orders/domain/usecases/get_customer_orders_usecase.dart';
import 'package:restaurant_app/features/orders/domain/usecases/get_rider_orders_usecase.dart';
import 'package:restaurant_app/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:restaurant_app/features/orders/domain/usecases/watch_order_status_usecase.dart';
import 'package:restaurant_app/features/orders/presentation/bloc/admin_orders_bloc.dart';
import 'package:restaurant_app/features/orders/presentation/bloc/customer_orders_bloc.dart';
import 'package:restaurant_app/features/orders/presentation/bloc/rider_orders_bloc.dart';

// Checkout
import 'package:restaurant_app/features/checkout/data/datasources/stripe_data_source.dart';
import 'package:restaurant_app/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:restaurant_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:restaurant_app/features/checkout/domain/usecases/confirm_payment_usecase.dart';
import 'package:restaurant_app/features/checkout/domain/usecases/create_payment_intent_usecase.dart';
import 'package:restaurant_app/features/checkout/domain/usecases/place_order_usecase.dart';
import 'package:restaurant_app/features/checkout/presentation/bloc/checkout_bloc.dart';

// Navigation
import 'package:restaurant_app/features/navigation/data/datasources/maps_launcher_data_source.dart';
import 'package:restaurant_app/features/navigation/data/repositories/navigation_repository_impl.dart';
import 'package:restaurant_app/features/navigation/domain/repositories/navigation_repository.dart';
import 'package:restaurant_app/features/navigation/domain/usecases/launch_navigation_usecase.dart';

// Rating
import 'package:restaurant_app/features/rating/data/datasources/rating_remote_data_source.dart';
import 'package:restaurant_app/features/rating/data/repositories/rating_repository_impl.dart';
import 'package:restaurant_app/features/rating/domain/repositories/rating_repository.dart';
import 'package:restaurant_app/features/rating/domain/usecases/get_rider_average_rating_usecase.dart';
import 'package:restaurant_app/features/rating/domain/usecases/get_rider_ratings_usecase.dart';
import 'package:restaurant_app/features/rating/domain/usecases/submit_rating_usecase.dart';
import 'package:restaurant_app/features/rating/presentation/bloc/rating_bloc.dart';

// Rider management
import 'package:restaurant_app/features/rider_management/data/datasources/rider_remote_data_source.dart';
import 'package:restaurant_app/features/rider_management/data/repositories/rider_repository_impl.dart';
import 'package:restaurant_app/features/rider_management/domain/repositories/rider_repository.dart';
import 'package:restaurant_app/features/rider_management/domain/usecases/get_available_riders_usecase.dart';
import 'package:restaurant_app/features/rider_management/domain/usecases/toggle_rider_online_status_usecase.dart';

// Notifications
import 'package:restaurant_app/features/notifications/data/datasources/fcm_data_source.dart';
import 'package:restaurant_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:restaurant_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:restaurant_app/features/notifications/domain/usecases/register_device_token_usecase.dart';
import 'package:restaurant_app/features/notifications/domain/usecases/send_order_status_notification_usecase.dart';

/// The service locator. Every Bloc is registered as a factory (fresh
/// instance per screen); every UseCase/Repository/DataSource is a
/// lazySingleton (one instance, created on first use). This is the ONLY
/// file in the app allowed to know about every layer at once — that's the
/// point of a composition root.
final sl = GetIt.instance;

/// Point this at your deployed Cloud Function / backend endpoint that
/// creates a Stripe PaymentIntent using the secret key server-side.
const String kCreatePaymentIntentUrl =
    'https://REPLACE_WITH_YOUR_BACKEND/createPaymentIntent';

Future<void> initDependencies() async {
  // ---- External / Firebase SDKs ----
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // ---- Auth ----
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfilePicUseCase(sl()));

  sl.registerFactory(() => AuthBloc(
        signUpUseCase: sl(),
        loginUseCase: sl(),
        logoutUseCase: sl(),
        resetPasswordUseCase: sl(),
        getCurrentUserUseCase: sl(),
        updateProfilePicUseCase: sl(),
      ));

  // ---- Menu ----
  sl.registerLazySingleton<MenuRemoteDataSource>(() => MenuRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetMenuItemsUseCase(sl()));
  sl.registerLazySingleton(() => AddMenuItemUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMenuItemUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMenuItemUseCase(sl()));
  sl.registerFactory(() => MenuBloc(
        getCategoriesUseCase: sl(),
        getMenuItemsUseCase: sl(),
      ));

  // ---- Cart ----
  sl.registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl());
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateQuantityUseCase(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));
  sl.registerLazySingleton(() => CalculateCartTotalUseCase());
  sl.registerFactory(() => CartBloc(
        getCartUseCase: sl(),
        addToCartUseCase: sl(),
        removeFromCartUseCase: sl(),
        updateQuantityUseCase: sl(),
        clearCartUseCase: sl(),
        calculateCartTotalUseCase: sl(),
      ));

  // ---- Orders ----
  // Registered once, shared with checkout — see architecture note.
  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetCustomerOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetAllOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetRiderOrdersUseCase(sl()));
  sl.registerLazySingleton(() => WatchOrderStatusUseCase(sl()));
  sl.registerLazySingleton(() => AcceptOrderUseCase(sl()));
  sl.registerLazySingleton(() => AssignRiderUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatusUseCase(sl()));
  sl.registerLazySingleton(() => CancelOrderUseCase(sl()));
  sl.registerFactory(() => CustomerOrdersBloc(getCustomerOrdersUseCase: sl()));
  sl.registerFactory(() => AdminOrdersBloc(
        getAllOrdersUseCase: sl(),
        acceptOrderUseCase: sl(),
        assignRiderUseCase: sl(),
      ));
  sl.registerFactory(() => RiderOrdersBloc(
        getRiderOrdersUseCase: sl(),
        updateOrderStatusUseCase: sl(),
      ));

  // ---- Checkout ----
  sl.registerLazySingleton<StripeDataSource>(
    () => StripeDataSourceImpl(createPaymentIntentBackendUrl: kCreatePaymentIntentUrl),
  );
  sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(
      stripeDataSource: sl(),
      orderRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => CreatePaymentIntentUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmPaymentUseCase(sl()));
  sl.registerLazySingleton(() => PlaceOrderUseCase(sl()));
  sl.registerFactory(() => CheckoutBloc(
        createPaymentIntentUseCase: sl(),
        confirmPaymentUseCase: sl(),
        placeOrderUseCase: sl(),
      ));

  // ---- Navigation ----
  sl.registerLazySingleton<MapsLauncherDataSource>(() => MapsLauncherDataSourceImpl());
  sl.registerLazySingleton<NavigationRepository>(() => NavigationRepositoryImpl(sl()));
  sl.registerLazySingleton(() => LaunchNavigationUseCase(sl()));

  // ---- Rating ----
  sl.registerLazySingleton<RatingRemoteDataSource>(() => RatingRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<RatingRepository>(
    () => RatingRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => SubmitRatingUseCase(sl()));
  sl.registerLazySingleton(() => GetRiderRatingsUseCase(sl()));
  sl.registerLazySingleton(() => GetRiderAverageRatingUseCase(sl()));
  sl.registerFactory(() => RatingBloc(
        submitRatingUseCase: sl(),
        getRiderRatingsUseCase: sl(),
      ));

  // ---- Rider management ----
  sl.registerLazySingleton<RiderRemoteDataSource>(() => RiderRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<RiderRepository>(
    () => RiderRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetAvailableRidersUseCase(sl()));
  sl.registerLazySingleton(() => ToggleRiderOnlineStatusUseCase(sl()));

  // ---- Notifications ----
  sl.registerLazySingleton<FCMDataSource>(
    () => FCMDataSourceImpl(messaging: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(sl()));
  sl.registerLazySingleton(() => RegisterDeviceTokenUseCase(sl()));
  sl.registerLazySingleton(() => SendOrderStatusNotificationUseCase(sl()));
}
