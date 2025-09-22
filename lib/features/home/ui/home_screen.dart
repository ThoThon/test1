import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../mainpage/ui/mainpage_screen.dart';
import '../../profile/ui/profile_screen.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = [
      const MainpageScreen(),
      const ProfileScreen(),
    ];

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _getAppBarTitle(state.currentIndex),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: false,
          ),
          body: IndexedStack(
            index: state.currentIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<HomeBloc>().add(HomeTabChanged(index));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
            selectedItemColor: const Color(0xFFf24e1e),
            unselectedItemColor: Colors.black45,
            iconSize: 28,
            selectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black45,
            ),
          ),
        );
      },
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return "Trang chủ";
      case 1:
        return "Thông tin cá nhân";
      default:
        return "Trang chủ";
    }
  }
}
