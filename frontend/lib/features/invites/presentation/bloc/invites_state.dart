part of 'invites_bloc.dart';

abstract class InvitesState extends Equatable {
  const InvitesState();

  @override
  List<Object?> get props => [];
}

class InvitesInitial extends InvitesState {}

class InvitesLoading extends InvitesState {}

class InvitesLoaded extends InvitesState {
  final List<dynamic> invites;

  const InvitesLoaded({required this.invites});

  @override
  List<Object?> get props => [invites];
}

class InvitesError extends InvitesState {
  final String message;

  const InvitesError({required this.message});

  @override
  List<Object?> get props => [message];
}
