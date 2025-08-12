import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'invites_event.dart';
part 'invites_state.dart';

class InvitesBloc extends Bloc<InvitesEvent, InvitesState> {
  InvitesBloc() : super(InvitesInitial()) {
    on<LoadInvites>(_onLoadInvites);
  }

  Future<void> _onLoadInvites(
    LoadInvites event,
    Emitter<InvitesState> emit,
  ) async {
    emit(InvitesLoading());
    // TODO: Implement invites loading
    emit(const InvitesLoaded(invites: []));
  }
}
