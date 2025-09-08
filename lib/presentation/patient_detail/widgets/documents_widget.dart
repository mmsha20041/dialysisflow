import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> documents;

  const DocumentsWidget({
    Key? key,
    required this.documents,
  }) : super(key: key);

  @override
  State<DocumentsWidget> createState() => _DocumentsWidgetState();
}

class _DocumentsWidgetState extends State<DocumentsWidget> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Lab Reports',
    'OPD Reports',
    'Prescriptions',
    'Discharge Summary',
    'Insurance',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategoryFilter(),
        SizedBox(height: 2.h),
        Expanded(
          child: _getFilteredDocuments().isEmpty 
            ? _buildEmptyState() 
            : _buildDocumentsGrid(),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = category),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected 
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected 
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected 
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'folder_open',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            selectedCategory == 'All' 
              ? 'No Documents Available'
              : 'No $selectedCategory Found',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Upload documents to view them here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: () => _uploadDocument(),
            icon: CustomIconWidget(
              iconName: 'upload_file',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text('Upload Document'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsGrid() {
    final filteredDocs = _getFilteredDocuments();
    
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredDocs.length,
      itemBuilder: (context, index) {
        final document = filteredDocs[index];
        return _buildDocumentCard(document);
      },
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> document) {
    final fileType = _getFileType(document["fileName"] as String? ?? "");
    
    return GestureDetector(
      onTap: () => _viewDocument(document),
      onLongPress: () => _showDocumentOptions(document),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _getFileTypeColor(fileType).withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: document["thumbnailUrl"] != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: CustomImageWidget(
                        imageUrl: document["thumbnailUrl"] as String,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: CustomIconWidget(
                        iconName: _getFileTypeIcon(fileType),
                        color: _getFileTypeColor(fileType),
                        size: 12.w,
                      ),
                    ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document["fileName"] as String? ?? "Unknown File",
                      style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(document["category"] as String? ?? "").withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            document["category"] as String? ?? "Other",
                            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                              color: _getCategoryColor(document["category"] as String? ?? ""),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(document["uploadDate"] as String? ?? ""),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredDocuments() {
    if (selectedCategory == 'All') {
      return widget.documents;
    }
    return widget.documents.where((doc) => 
      (doc["category"] as String?) == selectedCategory
    ).toList();
  }

  String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'pdf';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'image';
      case 'doc':
      case 'docx':
        return 'document';
      case 'xls':
      case 'xlsx':
        return 'spreadsheet';
      default:
        return 'file';
    }
  }

  String _getFileTypeIcon(String fileType) {
    switch (fileType) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'image':
        return 'image';
      case 'document':
        return 'description';
      case 'spreadsheet':
        return 'table_chart';
      default:
        return 'insert_drive_file';
    }
  }

  Color _getFileTypeColor(String fileType) {
    switch (fileType) {
      case 'pdf':
        return Colors.red;
      case 'image':
        return Colors.green;
      case 'document':
        return Colors.blue;
      case 'spreadsheet':
        return Colors.orange;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Lab Reports':
        return Colors.purple;
      case 'OPD Reports':
        return Colors.blue;
      case 'Prescriptions':
        return Colors.green;
      case 'Discharge Summary':
        return Colors.orange;
      case 'Insurance':
        return Colors.teal;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  void _viewDocument(Map<String, dynamic> document) {
    // This would typically open the document viewer
    print('Viewing document: ${document["fileName"]}');
  }

  void _showDocumentOptions(Map<String, dynamic> document) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text('View Document'),
              onTap: () {
                Navigator.pop(context);
                _viewDocument(document);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text('Share Document'),
              onTap: () {
                Navigator.pop(context);
                _shareDocument(document);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text('Download'),
              onTap: () {
                Navigator.pop(context);
                _downloadDocument(document);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.getStatusColor('error'),
                size: 6.w,
              ),
              title: Text('Delete Document'),
              onTap: () {
                Navigator.pop(context);
                _deleteDocument(document);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _uploadDocument() {
    // This would typically open a file picker
    print('Uploading document...');
  }

  void _shareDocument(Map<String, dynamic> document) {
    // This would typically share the document
    print('Sharing document: ${document["fileName"]}');
  }

  void _downloadDocument(Map<String, dynamic> document) {
    // This would typically download the document
    print('Downloading document: ${document["fileName"]}');
  }

  void _deleteDocument(Map<String, dynamic> document) {
    // This would typically delete the document
    print('Deleting document: ${document["fileName"]}');
  }
}