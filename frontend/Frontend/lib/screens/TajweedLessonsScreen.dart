import 'package:flutter/material.dart';
import 'package:tajweed_corrector/services/tajweed_service.dart';
import 'package:tajweed_corrector/services/search_service.dart';
import 'package:tajweed_corrector/screens/RecitationScreen.dart';
import 'package:tajweed_corrector/widgets/index.dart';

class TajweedLessonsScreen extends StatefulWidget {
  const TajweedLessonsScreen({super.key});

  @override
  State<TajweedLessonsScreen> createState() => _TajweedLessonsScreenState();
}

class _TajweedLessonsScreenState extends State<TajweedLessonsScreen> {
  final TajweedService _tajweedService = TajweedService();
  final SearchService _searchService = SearchService();
  
  List<TajweedLesson> lessons = [];
  List<TajweedLesson> filteredLessons = [];
  List<String> categories = [];
  
  String searchQuery = '';
  String? selectedCategory;
  String? selectedDifficulty;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLessons();
    _loadCategories();
  }

  Future<void> _loadLessons() async {
    setState(() => isLoading = true);
    final loadedLessons = await _tajweedService.getAllLessons();
    
    // Apply filters: difficulty, category, and search query
    List<TajweedLesson> filtered = loadedLessons;
    
    // Filter by difficulty
    if (selectedDifficulty != null && selectedDifficulty!.isNotEmpty) {
      final normalizedDifficulty = selectedDifficulty!.toLowerCase();
      filtered = filtered
          .where((lesson) => lesson.difficulty.toLowerCase() == normalizedDifficulty)
          .toList();
    }
    
    // Filter by category if selected
    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      filtered = filtered.where((lesson) => lesson.category == selectedCategory).toList();
    }
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final queryLower = searchQuery.toLowerCase();
      filtered = filtered.where((lesson) =>
        lesson.title.toLowerCase().contains(queryLower) ||
        lesson.description.toLowerCase().contains(queryLower)
      ).toList();
    }
    
    if (mounted) {
      setState(() {
        lessons = loadedLessons;
        filteredLessons = filtered;
        isLoading = false;
      });
    }
  }

  Future<void> _loadCategories() async {
    final loadedCategories = await _searchService.getCategories();
    if (mounted) {
      setState(() => categories = loadedCategories);
    }
  }

  void _applyFilters() {
    // Re-filter based on current state
    List<TajweedLesson> filtered = lessons;

    // Filter by difficulty if selected
    if (selectedDifficulty != null && selectedDifficulty!.isNotEmpty) {
      final normalizedDifficulty = selectedDifficulty!.toLowerCase();
      filtered = filtered
          .where((lesson) => lesson.difficulty.toLowerCase() == normalizedDifficulty)
          .toList();
    }
    
    // Filter by category if selected
    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      filtered = filtered.where((lesson) => lesson.category == selectedCategory).toList();
    }
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final queryLower = searchQuery.toLowerCase();
      filtered = filtered.where((lesson) =>
        lesson.title.toLowerCase().contains(queryLower) ||
        lesson.description.toLowerCase().contains(queryLower)
      ).toList();
    }
    
    if (mounted) {
      setState(() => filteredLessons = filtered);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Tajweed Rules'),
        backgroundColor: const Color(0xFF1E4976),
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: const Color(0xFF1E4976).withOpacity(0.3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search and Filter Bar
            SearchFilterBar(
              categories: categories,
              selectedCategory: selectedCategory,
              selectedDifficulty: selectedDifficulty,
              onSearchChanged: (query) {
                setState(() => searchQuery = query);
                _applyFilters();
              },
              onCategoryChanged: (category) {
                setState(() => selectedCategory = category);
                _applyFilters();
              },
              onDifficultyChanged: (difficulty) {
                setState(() => selectedDifficulty = difficulty);
                _applyFilters();
              },
            ),
            const SizedBox(height: 24),

            // Lessons Count
            Text(
              '${filteredLessons.length} lesson${filteredLessons.length != 1 ? 's' : ''} found',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),

            // Lessons List
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (filteredLessons.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No lessons found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search or filters',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: filteredLessons.map((lesson) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecitationScreen(lesson: lesson),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  lesson.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(lesson.difficulty),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  lesson.difficulty.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lesson.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${lesson.duration} min',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                lesson.category,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1E4976),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}


