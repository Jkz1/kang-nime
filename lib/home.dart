import 'package:flutter/material.dart';
import 'package:kang_nime/utils/api_hit.dart';
import 'package:kang_nime/widget/anime_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dynamic> animeList;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async{

    try {
      animeList = await fetchDataFromApi();
      // Lakukan sesuatu dengan data jika perlu
      print("success");
    } catch (e) {
      animeList = [];
      print("error: $e");
      // Tangani error jika perlu
    } finally {
      setState(() {
        print("loading selesai");
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 🧠 SliverAppBar yang bisa sembunyi & muncul
          SliverAppBar(
            backgroundColor: Colors.black,
            title: const Text("KangNime",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            centerTitle: true,
            floating: true, // muncul saat scroll sedikit ke atas
            snap: true, // animasi halus munculnya
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                color: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
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
          SliverToBoxAdapter(
            child: Container(
              height: 5,
              color: Colors.orange,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: 
            loading ? const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ):
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final anime = animeList[index];
                  return AnimeCard(
                    title: anime['title'],
                    imageUrl: anime['images']['jpg']['image_url'],
                    rating: anime['score'],
                  );
                },
                childCount: animeList.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 anime per baris
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.68,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
