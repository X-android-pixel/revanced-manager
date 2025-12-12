import 'package:flutter/material.dart' hide SearchBar;
import 'package:revanced_manager/ui/views/mount/mount_viewmodel.dart';
import 'package:revanced_manager/ui/widgets/appSelectorView/app_skeleton_loader.dart';
import 'package:revanced_manager/ui/widgets/appSelectorView/installed_app_item.dart';
import 'package:revanced_manager/ui/widgets/shared/search_bar.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;

class MountView extends StatefulWidget {
  const MountView({super.key});

  @override
  State<MountView> createState() => _MountViewState();
}

class _MountViewState extends State<MountView> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MountViewModel>.reactive(
      onViewModelReady: (model) => model.initialize(),
      viewModelBuilder: () => MountViewModel(),
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              title: const Text("Mount APK"),
              titleTextStyle: TextStyle(
                fontSize: 22.0,
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(66.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: SearchBar(
                    hintText: "Search app",
                    onQueryChanged: (searchQuery) {
                      setState(() {
                        _query = searchQuery;
                      });
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: model.noApps
                  ? Center(
                      child: Text(
                        "No apps found",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                      ),
                    )
                  : model.apps.isEmpty
                      ? const AppSkeletonLoader()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0)
                              .copyWith(
                            bottom:
                                MediaQuery.viewPaddingOf(context).bottom + 8.0,
                          ),
                          child: Column(
                            children: [
                              ...model.getFilteredApps(_query).map(
                                    (app) => InstalledAppItem(
                                      name: app.appName,
                                      pkgName: app.packageName,
                                      icon: app.icon,
                                      installedVersion: app.versionName!,
                                      patchesCount: 0,
                                      onTap: () => model.selectInstalledApp(
                                        context,
                                        app.packageName,
                                      ),
                                    ),
                                  ),
                              const SizedBox(height: 70.0),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
