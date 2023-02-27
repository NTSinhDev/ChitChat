import 'package:chat_app/view_model/providers/injector.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'app_state_provider.dart';
export 'language_provider.dart';
export 'theme_provider.dart';

List<SingleChildWidget> injectProviders({required SharedPreferences sharedPreferences}) {
  return [
    ChangeNotifierProvider(create: (_) => AppStateProvider()),
    ChangeNotifierProvider(
        create: (_) => ThemeProvider(sharedPreferences)),
    ChangeNotifierProvider(
        create: (_) => LanguageProvider(sharedPreferences)),
  ];
}
