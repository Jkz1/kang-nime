import 'package:flutter/material.dart';
import 'package:kang_nime/utils/api_hit.dart';
import 'package:kang_nime/widget/anime_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  List<dynamic> animeList = [];

  bool loading = true;
  bool hasMore = true;
  int currentPage = 0;
  bool loadingMore = false;
  bool _showFab = false;
  int _currIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        fetchData();
      }
      if (_scrollController.offset > 300 && !_showFab) {
        setState(() => _showFab = true);
      } else if (_scrollController.offset <= 300 && _showFab) {
        setState(() => _showFab = false);
      }
    });
  }

  void fetchData() async {
    if (loadingMore) return;
    loadingMore = true;
    try {
      currentPage += 1;
      var res;
      if (_currIndex == 0) {
        res = await fetchDataAnime(page: currentPage, filter: selectedFilter ?? "", rating: selectedRating ?? "");
      } else {
        res = await fetchDataManga(page: currentPage);
      }
      if (hasMore == false) return;
      if (res.isEmpty) {
        hasMore = false;
      } else {
        animeList.addAll(res);
      }
      loadingMore = false;
    } catch (e) {
      animeList = [];
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void onSelectBottomNav(int index) {
    setState(() {
      _currIndex = index;
      animeList = [];
      loading = true;
      hasMore = true;
      currentPage = 0;
    });
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<String> filtersAnime = [
    'Airing',
    'Upcoming',
    'ByPopularity',
    'Favorite',
  ];
  final List<String> ratingsAnime = ["G", "PG", "PG-13", "R", "R+", "Rx"];

  final List<String> typeManga = [
    "manga",
    "novel",
    "lightnovel",
    "oneshot",
    "doujin",
    "manhwa",
    "manhua"
  ];

  final List<String> filterManga = [
    "publishing",
    "upcoming",
    "bypopularity",
    "favorite"
  ];

  String? selectedFilter;
  String? selectedRating;

  void resetFilters() {
    setState(() {
      selectedFilter = null;
      selectedRating = null;
    });
  }

  void applyFilters() {
    setState(() {
      animeList = [];
      loading = true;
      hasMore = true;
      currentPage = 0;
    });
    fetchData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Filter diterapkan:\nFilter: ${selectedFilter ?? "-"} | Rating: ${selectedRating ?? "-"}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            title: const Text(
              "KangNime",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            floating: true, // muncul saat scroll sedikit ke atas
            snap: true, // animasi halus munculnya
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Search anime...',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: Container(height: 5, color: Colors.orange)),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),

              ExpansionTile(
  leading: const Icon(Icons.filter_list, color: Color(0xFFEFEEEA)),
  title: const Text(
    'Filter & Rating',
    style: TextStyle(
      color: Color(0xFFEFEEEA),
      fontWeight: FontWeight.w600,
    ),
  ),
  backgroundColor: const Color(0xFF273F4F),
  collapsedBackgroundColor: const Color(0xFF273F4F),
  iconColor: const Color(0xFFEFEEEA),
  collapsedIconColor: const Color(0xFFEFEEEA),
  children: [
    Container(
      color: const Color(0xFF273F4F),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🌿 Filter
          const Text(
            "Filter",
            style: TextStyle(
              color: Color(0xFFEFEEEA),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filtersAnime.map((item) {
              final isSelected = selectedFilter == item;
              return ChoiceChip(
                label: Text(
                  item,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF273F4F)
                        : const Color(0xFFEFEEEA),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                backgroundColor: const Color(0xFF273F4F),
                selectedColor: const Color(0xFFEFEEEA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFFEFEEEA)
                        : Colors.grey.shade600,
                  ),
                ),
                onSelected: (selected) {
                  setState(() {
                    selectedFilter = selected ? item : null;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // 🌟 Rating
          const Text(
            "Rating",
            style: TextStyle(
              color: Color(0xFFEFEEEA),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _currIndex == 0 ? 
            ratingsAnime.map((rating) {
              final isSelected = selectedRating == rating;
              return ChoiceChip(
                label: Text(
                  rating,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF273F4F)
                        : const Color(0xFFEFEEEA),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                backgroundColor: const Color(0xFF273F4F),
                selectedColor: const Color(0xFFEFEEEA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFFEFEEEA)
                        : Colors.grey.shade600,
                  ),
                ),
                onSelected: (selected) {
                  setState(() {
                    selectedRating = selected ? rating : null;
                  });
                },
              );
            }).toList() : typeManga.map((type) {
              final isSelected = selectedRating == type;
              return ChoiceChip(
                label: Text(
                  type,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF273F4F)
                        : const Color(0xFFEFEEEA),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                backgroundColor: const Color(0xFF273F4F),
                selectedColor: const Color(0xFFEFEEEA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFFEFEEEA)
                        : Colors.grey.shade600,
                  ),
                ),
                onSelected: (selected) {
                  setState(() {
                    selectedRating = selected ? type : null;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // 🧭 Tombol Apply & Reset
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Tombol Reset (outline)
              OutlinedButton(
                onPressed: resetFilters,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEFEEEA), width: 1.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  "Reset",
                  style: TextStyle(
                    color: Color(0xFFEFEEEA),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Tombol Apply (oranye modern)
              ElevatedButton(
                onPressed: applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF9F45),
                  foregroundColor: Color(0xFF273F4F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 12),
                  elevation: 0,
                ),
                child: const Text(
                  "Apply",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  ],
)

            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver:
                loading
                    ? const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                    : SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final anime = animeList[index];
                        return AnimeCard(
                          index: index,
                          title: anime['title'],
                          imageUrl: anime['images']['jpg']['image_url'],
                          rating: anime['score'] ?? 0.0,
                        );
                      }, childCount: animeList.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 anime per baris
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.68,
                          ),
                    ),
          ),
        ],
      ),
      floatingActionButton:
          _showFab
              ? FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeInOutQuart,
                  );
                },
                child: const Icon(Icons.keyboard_double_arrow_up),
              )
              : null,

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent,
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            currentIndex: _currIndex,
            onTap: (index) {
              onSelectBottomNav(index);
            },
            backgroundColor: Colors.black,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Anime'),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Manga',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
