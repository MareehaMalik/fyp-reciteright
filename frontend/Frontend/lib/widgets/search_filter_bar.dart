import 'package:flutter/material.dart';

class SearchFilterBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String?) onCategoryChanged;
  final Function(String?) onDifficultyChanged;
  final List<String> categories;
  final String? selectedCategory;
  final String? selectedDifficulty;

  const SearchFilterBar({
    super.key,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onDifficultyChanged,
    required this.categories,
    this.selectedCategory,
    this.selectedDifficulty,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  late TextEditingController _searchController;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search lessons...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF1E4976),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                        },
                        child: const Icon(
                          Icons.clear,
                          color: Color(0xFF1E4976),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() => _showFilters = !_showFilters);
                        },
                        child: const Icon(
                          Icons.filter_list,
                          color: Color(0xFF1E4976),
                        ),
                      ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),

        // Filter Options
        if (_showFilters)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Filter
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E4976),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'All',
                        selected: widget.selectedCategory == null,
                        onTap: () => widget.onCategoryChanged(null),
                      ),
                      ...widget.categories.map(
                        (category) => _buildFilterChip(
                          label: category,
                          selected: widget.selectedCategory == category,
                          onTap: () => widget.onCategoryChanged(category),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Difficulty Filter
                const Text(
                  'Difficulty',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E4976),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildDifficultyChip('All', null),
                    const SizedBox(width: 8),
                    _buildDifficultyChip('Beginner', 'beginner'),
                    const SizedBox(width: 8),
                    _buildDifficultyChip('Intermediate', 'intermediate'),
                    const SizedBox(width: 8),
                    _buildDifficultyChip('Advanced', 'advanced'),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF1E4976)
                : const Color(0xFFF5F7FB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? const Color(0xFF1E4976)
                  : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : const Color(0xFF1E4976),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String label, String? value) {
    final selected = widget.selectedDifficulty == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onDifficultyChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF1E4976)
                : const Color(0xFFF5F7FB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? const Color(0xFF1E4976)
                  : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : const Color(0xFF1E4976),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
