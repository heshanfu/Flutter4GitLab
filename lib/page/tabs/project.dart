import 'package:F4Lab/page/PageProjectDetail.dart';
import 'package:F4Lab/widget/comm_ListView.dart';
import 'package:flutter/material.dart';

const projectTypes = {
  "All": "membership=true",
  "Your": "owned=true",
  "Starred": "starred=true"
};

class Project extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
              labelColor: Theme.of(context).accentColor,
              indicatorColor: Theme.of(context).primaryColor,
              tabs:
                  projectTypes.keys.map((title) => Tab(text: title)).toList()),
          body: TabBarView(
              children: projectTypes.values
                  .map((option) => ProjectTab(option))
                  .toList()),
        ));
  }
}

class ProjectTab extends CommListWidget {
  final String type;

  ProjectTab(this.type);

  @override
  State<StatefulWidget> createState() => ProjectState(
      "projects?order_by=updated_at&per_page=10&simple=true&$type");
}

class ProjectState extends CommListState {
  ProjectState(String endPoint) : super(endPoint);

  @override
  Widget childBuild(BuildContext context, int index) {
    final item = data[index];
    return Card(
      child: ListTile(
        leading: item['avatar_url'] != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(item['avatar_url']),
                backgroundColor: Theme.of(context).primaryColor,
              )
            : CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  item['name'].substring(0, 1).toUpperCase(),
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
        title: Text(item['name_with_namespace']),
        subtitle: Text(item['description'] ?? item['last_activity_at']),
        trailing: item['default_branch'] != null
            ? Chip(
                label: Text(item['default_branch'],
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                backgroundColor: Theme.of(context).backgroundColor,
              )
            : IgnorePointer(
                ignoring: true,
              ),
        onTap: () {
          _navToProjectDetail(item['name'], item['id']);
        },
      ),
    );
  }

  _navToProjectDetail(String name, int projectId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PageProjectDetail(name, projectId)));
  }
}
