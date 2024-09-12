part of 'stock_cubit.dart';

sealed class StockState extends Equatable {
  const StockState();

  @override
  List<Object> get props => [];
}

final class StockInitial extends StockState {}

final class StockLoading extends StockState {}

final class StockSuccess extends StockState {
  final String message;
  const StockSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class StockFailed extends StockState {
  final String message;
  const StockFailed({required this.message});

  @override
  List<Object> get props => [message];
}
