import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_near/features/profile/domain/usecase/get_profile.dart';
import 'package:work_near/features/profile/domain/usecase/set_profile.dart';
import 'package:work_near/features/profile/presentation/bloc/profile_event.dart';
import 'package:work_near/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>{
  final GetProfile getProfile;
  final SetProfile setProfile;

  ProfileBloc(this.getProfile, this.setProfile) : super(ProfileInitial()){
    on<LoadUserProfile>(_onGet);
    on<UpdateUserProfile>(_onUpdate);
  }

  Future<void> _onGet(LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final rs = await getProfile.call(event.params);
    rs.fold(
        (failure) => emit(ProfileError(failure.message)),
        (user) => emit(ProfileLoaded(user))
    );
  }

  Future<void> _onUpdate(UpdateUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await setProfile.call(event.user);

    result.fold(
          (failure) => emit(ProfileError(failure.message)),
          (_) => emit(ProfileUpdated(event.user)),
    );
  }
}