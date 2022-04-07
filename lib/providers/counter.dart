import 'package:flutter/material.dart';

// classe estado que irá ser alterada
class CounterState {
  int _value = 0;

  void inc() => _value++;
  void dec() => _value--;
  int get value => _value;

  // Função que retonra um estado diferente da anterior
  bool diff(CounterState old) {
    return old._value != _value;
  }
}

class CounterProvider extends InheritedWidget {
  // Instancia da classs estado
  final CounterState state = CounterState();

  // Construtor que pede como parâmetro um Widget
  CounterProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  // É a função que permite usar o "context" para navegar suas propriedades
  static CounterProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  // Função que irá determinar a chamada do ChangeNotify, atraves de uma validação
  @override
  bool updateShouldNotify(covariant CounterProvider oldWidget) {
    return oldWidget.state.diff(state);
  }
}
