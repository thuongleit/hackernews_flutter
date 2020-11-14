import 'package:hydrated_bloc/hydrated_bloc.dart';

enum Browser { internal, external }

class BrowserCubit extends HydratedCubit<Browser> {
  static const _prefKey = 'browser';

  BrowserCubit() : super(Browser.internal);

  void chooseBrowser(Browser browser) => emit(browser);

  @override
  Browser fromJson(Map<String, dynamic> json) {
    final prefCode = json[_prefKey] as String;
    return Browser.values[int.parse(prefCode)];
  }

  @override
  Map<String, dynamic> toJson(Browser state) {
    return <String, String>{_prefKey: '${state.index}'};
  }
}