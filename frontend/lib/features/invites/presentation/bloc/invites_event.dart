part of 'invites_bloc.dart';

abstract class InvitesEvent extends Equatable {
  const InvitesEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvites extends InvitesEvent {}
