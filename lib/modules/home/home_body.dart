import 'package:flutter/material.dart';
import 'package:endava_profile_app/common/constants/dimens.dart';
import 'package:endava_profile_app/common/constants/palette.dart';
import 'package:endava_profile_app/modules/home/components/progress_bar.dart';
import 'components/section_card.dart';
import 'package:endava_profile_app/common/components/flutter_team.dart';

import 'package:endava_profile_app/modules/home/models/section_list_item.dart';
import 'models/placeholder_item.dart';
import 'bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_mapper.dart';
import 'package:endava_profile_app/common/components/profile_app_bar.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  HomeBloc _bloc;

  List<SectionListItem> contentItems = [];

  final List<SectionListItem> placeholders = [
    PlaceholderItem(
      key: 'user',
      title: 'Name and role',
      icon: 'assets/images/user.png',
    ),
    PlaceholderItem(
      key: 'summary',
      title: 'Summary',
      icon: 'assets/images/summary.png',
    ),
    PlaceholderItem(
      key: 'experience',
      title: 'Domain experience',
      icon: 'assets/images/experience.png',
    ),
    PlaceholderItem(
      key: 'skills',
      title: 'Core skills',
      icon: 'assets/images/skills.png',
    ),
    PlaceholderItem(
      key: 'education',
      title: 'Education and training',
      icon: 'assets/images/education.png',
    ),
    PlaceholderItem(
      key: 'portfolio',
      title: 'Professional experience',
      icon: 'assets/images/portfolio.png',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _bloc = BlocProvider.of<HomeBloc>(context)..add(ScreenLoaded());
  }

  @override
  Widget build(BuildContext context) {
    _bloc.add(ScreenLoaded());
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeSuccessResponse) {
        contentItems = HomeMapper.map(response: state);

        final sections = _getSections();

        return CustomScrollView(
          slivers: [
            ProfileAppBar(bgColor: Theme.of(context).scaffoldBackgroundColor),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(0, Dimens.spacingLarge, 0, 0),
                child: Center(
                  child: ProgressBar(
                    percent: contentItems.length / placeholders.length,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return SectionCard(section: sections[index]);
                },
                childCount: sections.length,
                semanticIndexOffset: 2,
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: FlutterTeam(
                onTap: () {
                  Navigator.of(context).pushNamed('/contributors');
                },
              ),
            ),
          ],
        );
      } else {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Palette.cinnabar),
            strokeWidth: 6,
          ),
        );
      }
    });
  }

  List<SectionListItem> _getSections() => placeholders
      .map((placeholder) => _getContentByKey(placeholder.key) ?? placeholder)
      .toList();

  SectionListItem _getContentByKey(String key) => contentItems.firstWhere(
        (item) => item.key == key,
        orElse: () => null,
      );
}
