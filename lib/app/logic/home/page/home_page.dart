import 'package:chat_client/app/logic/friends/container/friends_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic.dart';

class HomePage extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (context) => HomePage());

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  int index = 0;

  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      this.setState(() {
        index = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InnerDrawer(
      key: _innerDrawerKey,
      scaffold: Scaffold(
        appBar: AppBar(
          leading: MyAvatar().padding(all: 8).ripple().gestures(
              onTap: () => _innerDrawerKey.currentState
                  ?.open(direction: InnerDrawerDirection.start)),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [InboxContainer(), FriendsContainer()],
        ),
        bottomNavigationBar: BottomAppBar(
          // currentIndex: index,
          // items: [
          //   BottomNavigationBarItem(icon: Icon(Icons.inbox), label: '消息'),
          //   BottomNavigationBarItem(icon: Icon(Icons.group), label: '好友')
          // ],
          // onTap: (index) {
          //   _tabController.index = index;
          // },
          child: Container(
            height: 56,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              tabs: [
                Icon(Icons.inbox).height(56),
                Icon(Icons.group).height(56),
              ],
            ),
          ),
          notchMargin: 4,
          shape: CircularNotchedRectangle(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            FilePicker.platform
                .pickFiles(type: FileType.image, withData: true)
                .then((value) async {
              final bytes = value?.files.single.bytes;
              if (bytes != null) {
                final content = await scanner.scanBytes(bytes);
                context
                    .read<FriendsBloc>()
                    .add(FriendsAdded(friend: Friend(public: content)));
              }
            });
          },
          backgroundColor: theme.primaryColor,
        ).constrained(height: 56, width: 56),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
      leftChild: SettingsPage(),
    );
  }
}
