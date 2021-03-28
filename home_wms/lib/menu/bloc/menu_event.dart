part of 'menu_bloc.dart';

@immutable
abstract class MenuEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ButtonEvent extends MenuEvent {

  late final String buttonName;
  ButtonEvent(this.buttonName);
  @override
  List<Object?> get props => [];
}
