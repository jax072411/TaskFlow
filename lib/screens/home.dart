import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../providers/auth_provider.dart';
import '../providers/project_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/add_edit_project_dialog.dart';
import '../widgets/project_card.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'project_detail.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectProvider);
    final filteredProjects = _getFilteredProjects(projects);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {});
          },
          tabs: const [
            Tab(text: '全部'),
            Tab(text: '进行中'),
            Tab(text: '已完成'),
            Tab(text: '已归档'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProjectSearchDelegate(ref),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索项目...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Project list
          Expanded(
            child: filteredProjects.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = filteredProjects[index];
                      return ProjectCard(
                        project: project,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectDetailScreen(project: project),
                            ),
                          );
                        },
                        onEdit: () {
                          _showEditProjectDialog(project);
                        },
                        onDelete: () {
                          _deleteProject(project);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProjectDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Project> _getFilteredProjects(List<Project> projects) {
    List<Project> filtered = projects;

    // Filter by tab index
    final tabIndex = _tabController.index;
    switch (tabIndex) {
      case 1:
        filtered = filtered.where((p) => p.status == ProjectStatus.inProgress).toList();
        break;
      case 2:
        filtered = filtered.where((p) => p.status == ProjectStatus.completed).toList();
        break;
      case 3:
        filtered = filtered.where((p) => p.status == ProjectStatus.archived).toList();
        break;
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((p) =>
          p.name.toLowerCase().contains(query) ||
          (p.description?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    return filtered;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无项目',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右下角 + 号创建新项目',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditProjectDialog(),
    );
  }

  void _showEditProjectDialog(Project project) {
    showDialog(
      context: context,
      builder: (context) => AddEditProjectDialog(project: project),
    );
  }

  void _deleteProject(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除项目'),
        content: Text('确定要删除项目 "${project.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              ref.read(projectProvider.notifier).deleteProject(project.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('项目已删除')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class ProjectSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  ProjectSearchDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final projects = ref.watch(projectProvider);
    final results = projects.where((p) =>
        p.name.toLowerCase().contains(query.toLowerCase()) ||
        (p.description?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final project = results[index];
        return ListTile(
          leading: const Icon(Icons.folder),
          title: Text(project.name),
          subtitle: Text(project.description ?? ''),
          onTap: () {
            close(context, '');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectDetailScreen(project: project),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
