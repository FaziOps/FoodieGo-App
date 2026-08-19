import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/network/network_info.dart';
import 'package:restaurant_app/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:restaurant_app/features/orders/data/models/order_model.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  OrderModel _toModel(OrderEntity e) => OrderModel(
        orderId: e.orderId,
        customerId: e.customerId,
        riderId: e.riderId,
        items: e.items,
        totalAmount: e.totalAmount,
        paymentStatus: e.paymentStatus,
        stripePaymentIntentId: e.stripePaymentIntentId,
        orderStatus: e.orderStatus,
        deliveryAddress: e.deliveryAddress,
        ratingStars: e.ratingStars,
        ratingReview: e.ratingReview,
        createdAt: e.createdAt,
      );

  @override
  Future<Either<Failure, String>> createOrder(OrderEntity order) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final id = await remoteDataSource.createOrder(_toModel(order));
      return Right(id);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getCustomerOrders(String customerId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await remoteDataSource.getCustomerOrders(customerId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await remoteDataSource.getAllOrders());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getRiderOrders(String riderId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await remoteDataSource.getRiderOrders(riderId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<Either<Failure, OrderEntity>> watchOrder(String orderId) {
    return remoteDataSource.watchOrder(orderId).map<Either<Failure, OrderEntity>>(
          (model) => Right(model),
        ).handleError((_) => const Left(ServerFailure('Lost connection to order updates.')));
  }

  @override
  Future<Either<Failure, void>> acceptOrder(String orderId) async {
    try {
      await remoteDataSource.updateStatus(orderId, AppConstants.statusAccepted);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> assignRider({
    required String orderId,
    required String riderId,
  }) async {
    try {
      await remoteDataSource.assignRider(orderId, riderId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) async {
    try {
      await remoteDataSource.updateStatus(orderId, newStatus);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    try {
      await remoteDataSource.cancelOrder(orderId, reason);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
