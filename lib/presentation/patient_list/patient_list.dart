import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './state/patient_list_controller.dart';
import './state/patient_list_state.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/patient_card_widget.dart';
import './widgets/search_bar_widget.dart';

class PatientList extends ConsumerStatefulWidget {
  const PatientList({Key? key}) : super(key: key);

  @override
  ConsumerState<PatientList> createState() => _PatientListState();
}

class _PatientListState extends ConsumerState<PatientList>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

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
    ref.listen<PatientListState>(patientListControllerProvider, (previous, next) {
      if (next.data.searchQuery != _searchController.text) {
        _searchController.text = next.data.searchQuery;
      }
      if (next is PatientListError) {
        _showSnackBar(next.message);
      }
      if (next is PatientListSuccess && next.message != null) {
        _showSnackBar(next.message!);
      }
    });

    final state = ref.watch(patientListControllerProvider);
    final data = state.data;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: data.isMultiSelectMode
          ? _buildMultiSelectAppBar(data.selectedPatients.length)
          : _buildNormalAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            if (!data.isMultiSelectMode) ...[
              SearchBarWidget(
                controller: _searchController,
                onChanged: ref
                    .read(patientListControllerProvider.notifier)
                    .onSearchChanged,
                onVoiceSearch: ref
                    .read(patientListControllerProvider.notifier)
                    .startOrStopVoiceSearch,
                onFilterTap: _showFilterDialog,
                hintText: data.isRecording
                    ? 'Listening...'
                    : 'Search patients by name, UHID, phone...',
              ),
              if (data.selectedFilters.isNotEmpty)
                FilterChipsWidget(
                  filters: data.filterOptions,
                  selectedFilters: data.selectedFilters,
                  onFilterSelected: ref
                      .read(patientListControllerProvider.notifier)
                      .onFilterSelected,
                ),
            ],
            Expanded(
              child: state is PatientListLoading && data.allPatients.isEmpty
                  ? const LoadingSkeletonWidget()
                  : data.filteredPatients.isEmpty
                      ? EmptyStateWidget(
                          title: data.searchQuery.isNotEmpty ||
                                  data.selectedFilters.isNotEmpty
                              ? 'No patients found'
                              : 'No patients yet',
                          subtitle: 'Try adjusting your search or filters',
                          iconName: 'search_off',
                        )
                      : RefreshIndicator(
                          onRefresh:
                              ref.read(patientListControllerProvider.notifier).refresh,
                          child: ListView.builder(
                            itemCount: data.filteredPatients.length,
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            itemBuilder: (context, index) {
                              final patient = data.filteredPatients[index];
                              final isSelected = data.selectedPatients
                                  .contains(patient['id'].toString());

                              return PatientCardWidget(
                                patient: patient,
                                isSelected: isSelected,
                                onTap: () {
                                  if (data.isMultiSelectMode) {
                                    ref
                                        .read(patientListControllerProvider.notifier)
                                        .onPatientTap(patient);
                                  } else {
                                    Navigator.pushNamed(context, '/patient-detail',
                                        arguments: patient);
                                  }
                                },
                                onLongPress: () => ref
                                    .read(patientListControllerProvider.notifier)
                                    .onPatientLongPress(patient),
                                onStartSession: () =>
                                    _showSnackBar('Starting session for ${patient['name']}'),
                                onViewRecords: () =>
                                    _showSnackBar('Opening records for ${patient['name']}'),
                                onCallPatient: () =>
                                    _showSnackBar('Calling ${patient['name']}'),
                                onEditDetails: () =>
                                    _showSnackBar('Editing ${patient['name']}'),
                                onTransferCenter: () =>
                                    _showSnackBar('Transferring ${patient['name']}'),
                                onArchive: () =>
                                    _showSnackBar('Archiving ${patient['name']}'),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: data.isMultiSelectMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, '/patient-registration'),
              icon: CustomIconWidget(iconName: 'add', color: Colors.white, size: 5.w),
              label: const Text('New Patient'),
            ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      title: const Text('Patients'),
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Patients'),
          Tab(text: 'Sessions'),
          Tab(text: 'Reports'),
          Tab(text: 'Analytics'),
        ],
      ),
      actions: [
        IconButton(
          onPressed: ref.read(patientListControllerProvider.notifier).refresh,
          icon: CustomIconWidget(
            iconName: 'refresh',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildMultiSelectAppBar(int count) {
    return AppBar(
      leading: IconButton(
        onPressed:
            ref.read(patientListControllerProvider.notifier).exitMultiSelectMode,
        icon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      title: Text('$count selected'),
    );
  }

  void _showFilterDialog() {
    final notifier = ref.read(patientListControllerProvider.notifier);
    final data = ref.read(patientListControllerProvider).data;

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.all(6.w),
        child: Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: data.filterOptions.map((filter) {
            final key = filter['key'] as String;
            return FilterChip(
              label: Text('${filter['label']} (${filter['count']})'),
              selected: data.selectedFilters.contains(key),
              onSelected: (_) => setState(() => notifier.onFilterSelected(key)),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
