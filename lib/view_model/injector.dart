import 'package:chat_app/view_model/injector.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'providers/language_provider.dart';
export 'providers/theme_provider.dart';
export 'providers/virtual_assistant_provider.dart';
export 'providers/apikey_provider.dart';
export 'providers/friends_provider.dart';
export 'providers/router_provider.dart';
export 'blocs/authentication/authentication_bloc.dart';
export 'blocs/authentication/authentication_event.dart';
export 'blocs/authentication/authentication_state.dart';
export 'blocs/chat/chat_bloc.dart';
export 'blocs/chat/chat_event.dart';
export 'blocs/chat/chat_state.dart';
export 'blocs/search/search_bloc.dart';
export 'blocs/search/search_event.dart';
export 'blocs/search/search_state.dart';
export 'blocs/setting/setting_bloc.dart';
export 'blocs/conversation/conversation_bloc.dart';

List<SingleChildWidget> injectProviders({
  required SharedPreferences sharedPreferences,
}) {
  return [
    ChangeNotifierProvider(create: (_) => APIKeyProvider()..getAPIKey()),
    ChangeNotifierProvider(create: (_) => VirtualAssistantProvider()),
    ChangeNotifierProvider(create: (_) => RouterProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider(sharedPreferences)),
    ChangeNotifierProvider(create: (_) => LanguageProvider(sharedPreferences)),
  ];
}
