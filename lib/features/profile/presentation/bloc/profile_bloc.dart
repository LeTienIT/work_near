import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_near/features/profile/domain/usecase/get_profile.dart';
import 'package:work_near/features/profile/presentation/bloc/profile_event.dart';
import 'package:work_near/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>{
  final GetProfile getProfile;

  ProfileBloc(this.getProfile) : super(ProfileInitial()){
    on<LoadUserProfile>(_onGet);
  }

  Future<void> _onGet(LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final rs = await getProfile.call(event.uid);
    rs.fold(
        (failure) => emit(ProfileError(failure.message)),
        (user) => emit(ProfileLoaded(user))
    );
  }

}