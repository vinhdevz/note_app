import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_todo_app/home/widgets/create_category_screen.dart';
import 'package:flutter_todo_app/database/task_database.dart';
import 'package:flutter_todo_app/models/category_model.dart';

class SelectCategoryDialog extends StatefulWidget {
  final int? selectedCategoryId;
  final void Function(CategoryModel) onSave;
  final VoidCallback? onCategoryUpdated;

  const SelectCategoryDialog({
    super.key,
    required this.selectedCategoryId,
    required this.onSave,
    this.onCategoryUpdated,
  });

  @override
  State<SelectCategoryDialog> createState() => _SelectCategoryDialogState();
}

class _SelectCategoryDialogState extends State<SelectCategoryDialog> {
  int? _selectedCategoryId;
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await TaskDatabase.instance.readAllCategories();
    setState(() => categories = cats);
  }

  Future<void> _removeCategory(int? id) async {
    if (id == null) {
      debugPrint('Category không tồn tại hoặc chưa có id');
      return;
    }
    await TaskDatabase.instance.deleteCategory(id);
    await _loadCategories();
    if (_selectedCategoryId == id) {
      setState(() => _selectedCategoryId = null);
    }
    widget.onCategoryUpdated?.call();
  }

  Future<void> _editCategory(CategoryModel category) async {
    if (category.id == null) {
      debugPrint('Category không tồn tại để sửa');
      return;
    }
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CreateCategoryScreen(category: category)),
    );
    if (result == true) {
      await _loadCategories();
      widget.onCategoryUpdated?.call();
    }
  }

  Future<void> _confirmDeleteCategory(CategoryModel category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xóa danh mục?'.tr()),
        content: Text('Bạn có chắc muốn xóa "${category.label}" không?'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Hủy'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Xóa'.tr()),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _removeCategory(category.id);
     
    }
  }

  void _handleSave() {
    final selected = categories.firstWhere(
      (cat) => cat.id == _selectedCategoryId,
      orElse: () => CategoryModel(id: null, label: '', icon: '', color: 0),
    );
    if (selected.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category'.tr())),
      );
      return;
    }
    widget.onSave(selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categoryItems = [...categories, _createNewCategory()];

    return Dialog(
      backgroundColor: tdGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            const SizedBox(height: 10),
            _buildCategoryGrid(categoryItems),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  CategoryModel _createNewCategory() {
    return CategoryModel(
      id: -1, // Sử dụng ID đặc biệt cho mục "Tạo mới"
      label: 'Create New'.tr(),
      icon: 'assets/icons/add.svg',
      color: 0xff80FFD1,
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Choose Category'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(color: tdText),
      ],
    );
  }

  Widget _buildCategoryGrid(List<CategoryModel> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final category = items[index];
        if (category.id == -1) {
          return _buildCreateNewItem(
            label: category.label,
            iconPath: category.icon,
            bgColor: Color(category.color),
          );
        }
        final isSelected = _selectedCategoryId == category.id;
        return _buildCategoryItem(category: category, isSelected: isSelected);
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: tdPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          "Add Category".tr(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required CategoryModel category,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryId = category.id),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _categoryIcon(category, isSelected),
              _buildRemoveIcon(category),
              _buildEditIcon(category),
            ],
          ),
          const SizedBox(height: 6),
          _categoryLabel(category),
        ],
      ),
    );
  }

  Widget _categoryIcon(CategoryModel category, bool isSelected) {
    final categoryColor = Color(category.color);
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: isSelected ? categoryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? null : Border.all(color: categoryColor, width: 2),
      ),
      child: Center(
        child: SvgPicture.asset(
          category.icon,
          width: 28,
          height: 28,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.black : categoryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveIcon(CategoryModel category) {
    if (category.id == -1) return const SizedBox.shrink();
    return Positioned(
      top: -10,
      right: -10,
      child: _circleIcon(Icons.close, Colors.red, () => _confirmDeleteCategory(category)),
    );
  }

  Widget _buildEditIcon(CategoryModel category) {
    if (category.id == -1) return const SizedBox.shrink();
    return Positioned(
      top: -10,
      left: -10,
      child: _circleIcon(Icons.edit, Colors.blue, () => _editCategory(category)),
    );
  }

  Widget _categoryLabel(CategoryModel category) {
    return SizedBox(
      width: 60,
      child: Text(
        category.label,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCreateNewItem({
    required String label,
    required String iconPath,
    required Color bgColor,
  }) {
    return GestureDetector(
      onTap: _onCreateNewCategory,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 28,
                height: 28,
                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _onCreateNewCategory() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateCategoryScreen()),
    );
    if (result == true) {
      await _loadCategories();
     widget.onCategoryUpdated?.call();} 
    
  }

  Widget _circleIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
