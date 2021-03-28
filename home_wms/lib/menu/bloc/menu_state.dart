part of 'menu_bloc.dart';

@immutable
abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuStateInitial extends MenuState {}

class MenuButtonActionNavigator extends MenuState {
  late final String buttonName;
  MenuButtonActionNavigator(this.buttonName);
}
