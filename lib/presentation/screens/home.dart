import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../extensions/extensions.dart';
import '../../blocs/blocs.dart';
import '../tabs/tabs.dart';
import '../../presentation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  ScrollController _scrollController;

  int _currentIndex = 0;
  bool _showBottomNavBar;

  List<StoryType> get _tabs => StoryType.values;

  @override
  void initState() {
    _scrollController = ScrollController();
    _showBottomNavBar = true;
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showBottomNavBar) {
          setState(() {
            _showBottomNavBar = false;
          });
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showBottomNavBar) {
          setState(() {
            _showBottomNavBar = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> _navigationBarItems =
        <BottomNavigationBarItem>[];
    for (var index = 0; index < _tabs.length; index++) {
      final StoryType type = _tabs[index];
      _navigationBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(
            type.tabIcon,
            size: 24.0,
          ),
          label: FlutterI18n.translate(context, type.tabBarTitle),
        ),
      );
    }
    final type = _tabs[_currentIndex];
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        maintainBottomViewPadding: true,
        top: false,
        bottom: _showBottomNavBar,
        right: false,
        left: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: UserActionsListener(
            child: BlocProvider<StoriesCubit>(
              create: (context) => StoriesCubit(
                RepositoryProvider.of<StoriesRepository>(context),
              ),
              child: StoriesTab(
                key: ValueKey(type.toString()),
                storyType: type,
                scrollController: _scrollController,
              ),
            ),
          ),
          bottomNavigationBar: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: _showBottomNavBar ? kBottomNavigationBarHeight : 0.0,
            child: BottomNavigationBar(
              items: _navigationBarItems,
              selectedLabelStyle: GoogleFonts.rubik(),
              unselectedLabelStyle: GoogleFonts.rubik(),
              elevation: 0.0,
              backgroundColor: Theme.of(context).backgroundColor,
              selectedItemColor: Theme.of(context).accentColor,
              unselectedItemColor: Theme.of(context).unselectedWidgetColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              currentIndex: _currentIndex,
              onTap: (index) => _currentIndex != index
                  ? setState(() => _currentIndex = index)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
