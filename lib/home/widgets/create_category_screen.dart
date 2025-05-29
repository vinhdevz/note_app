import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/database/task_database.dart';
import 'package:flutter_todo_app/models/category_model.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateCategoryScreen extends StatefulWidget {
  final CategoryModel? category;

  const CreateCategoryScreen({super.key, this.category});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  Color? _selectedColor;
  String? _iconPath;

  final List<Color> _colors = [
    const Color(0xFFD9D96F),
    const Color(0xFF7ED957),
    const Color(0xFF00FFBF),
    const Color(0xFF4D84FF),
    const Color(0xFF3CCFFF),
    const Color(0xFFFFA447),
    const Color(0xFFA050FF),
    const Color(0xFFFF4D6D),
  ];

  final List<String> _iconPaths = [
    'assets/icons/apple.svg',
    'assets/icons/bread.svg',
    'assets/icons/briefcase.svg',
    'assets/icons/brush.svg',
    'assets/icons/calendar.svg',
    'assets/icons/camera.svg',
    'assets/icons/clock.svg',
    'assets/icons/design.svg',
    'assets/icons/flag.svg',
    'assets/icons/flash.svg',
    'assets/icons/google.svg',
    'assets/icons/heartbeat.svg',
    'assets/icons/home_category.svg',
    'assets/icons/home_index.svg',
    'assets/icons/info_circle.svg',
    'assets/icons/key.svg',
    'assets/icons/language_square.svg',
    'assets/icons/like.svg',
    'assets/icons/logout.svg',
    'assets/icons/megaphone.svg',
    'assets/icons/menu.svg',
    'assets/icons/mortarboard.svg',
    'assets/icons/music.svg',
    'assets/icons/send.svg',
    'assets/icons/setting.svg',
    'assets/icons/sport.svg',
    'assets/icons/tag.svg',
    'assets/icons/text.svg',
  ];

  @override
  void initState() {
    super.initState();
    _loadCategoryIfEdit();
  }

  void _loadCategoryIfEdit() {
    if (widget.category != null) {
      _nameController.text = widget.category!.label;
      _iconPath = widget.category!.icon;
      _selectedColor = Color(widget.category!.color);
    }
  }

  void _chooseIconFromLibrary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          shrinkWrap: true,
          children: _iconPaths.map(_buildIconItem).toList(),
        ),
      ),
    );
  }

  Widget _buildIconItem(String path) {
    final isSelected = _iconPath == path;
    return GestureDetector(
      onTap: () {
        setState(() => _iconPath = path);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
              : Border.all(color: Colors.transparent),
        ),
        child: SvgPicture.asset(
          path,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Future<void> _saveCategory() async {
    final name = _nameController.text.trim();
    if (!_validateInput(name)) return;

    if (widget.category == null) {
      await _createCategory(name);
    } else {
      await _updateCategory(name);
    }

    Navigator.pop(context, true);
  }

  bool _validateInput(String name) {
    if (name.isEmpty || _iconPath == null || _selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Complete All Fields'.tr())),
      );
      return false;
    }
    return true;
  }

  Future<void> _createCategory(String name) async {
    final newCategory = CategoryModel(
      label: name,
      icon: _iconPath!,
      color: _selectedColor!.value,
    );
    await TaskDatabase.instance.createCategory(newCategory);
  }

  Future<void> _updateCategory(String name) async {
    final updatedCategory = widget.category!.copyWith(
      label: name,
      icon: _iconPath!,
      color: _selectedColor!.value,
    );
    await TaskDatabase.instance.updateCategory(updatedCategory);
  }

  Widget _buildCategoryNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category name'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          decoration: InputDecoration(
            hintText: 'Category name'.tr(),
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category icon'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _chooseIconFromLibrary,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Choose icon from library'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
        const SizedBox(height: 12),
        if (_iconPath != null)
          Row(
            children: [
              Text('Selected icon'.tr(),
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7))),
              const SizedBox(width: 8),
              SvgPicture.asset(
                _iconPath!,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onBackground,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category color'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: _colors.map(_buildColorCircle).toList(),
        ),
      ],
    );
  }

  Widget _buildColorCircle(Color color) {
    final bool isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
        ),
      ),
    );
  }

  Widget _buildBottomButtons(bool isEditMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Expanded(
  child: TextButton(
    onPressed: () => Navigator.pop(context),
    child: Text(
      'Cancel'.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
    ),
  ),
),


        ElevatedButton(
          onPressed: _saveCategory,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Text(
              isEditMode ? 'Save'.tr() : 'Create category'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.category != null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onBackground),
        centerTitle: true,
        title: Text(
          isEditMode ? 'Edit category'.tr() : 'Create new category'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildCategoryNameInput(),
            const SizedBox(height: 20),
            _buildIconSelector(),
            const SizedBox(height: 20),
            _buildColorSelector(),
            const Spacer(),
            _buildBottomButtons(isEditMode),
          ],
        ),
      ),
    );
  }
}
