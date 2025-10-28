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
      var res = await fetchDataFromApi(page: currentPage);
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
                          rating: anime['score'],
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
    );
  }
}
