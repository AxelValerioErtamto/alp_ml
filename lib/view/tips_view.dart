import 'package:flutter/material.dart';

// --- DATA MODELS ---
class Article {
  final String title;
  final String subtitle;
  final String content;
  final IconData icon;
  final Color color;
  final String readTime;

  Article({
    required this.title,
    required this.subtitle,
    required this.content,
    required this.icon,
    required this.color,
    required this.readTime,
  });
}

class Category {
  final String name;
  final List<Article> articles;
  final Color color;

  Category({required this.name, required this.articles, required this.color});
}

// --- STATIC DATA ---
final List<Category> libraryData = [
  Category(
    name: "Nutrition",
    color: Colors.green,
    articles: [
      Article(
        title: "The 80/20 Rule",
        subtitle: "Balance your diet without giving up favorites.",
        icon: Icons.pie_chart,
        color: Colors.green,
        readTime: "3 min",
        content: "The 80/20 rule represents a balanced approach to diet. The idea is simple: eat nutritious foods 80% of the time and allow yourself to indulge in your favorite treats for the other 20%. This approach makes dieting sustainable and prevents binge eating caused by extreme restriction."
      ),
      Article(
        title: "Hydration Hacks",
        subtitle: "Why water is your best weight-loss tool.",
        icon: Icons.water_drop,
        color: Colors.blue,
        readTime: "2 min",
        content: "Drinking water before meals can make you feel fuller, reducing your calorie intake. Additionally, replacing sugary drinks with water is the easiest way to cut empty calories. Aim for at least 2 liters a day."
      ),
      Article(
        title: "Protein Power",
        subtitle: "How protein boosts metabolism.",
        icon: Icons.egg_alt,
        color: Colors.orange,
        readTime: "5 min",
        content: "High-protein foods require more energy to digest, metabolize, and use, which means you burn more calories just by eating them. This is known as the thermic effect of food (TEF). Include lean meats, beans, or tofu in every meal."
      ),
    ],
  ),
  Category(
    name: "Fitness",
    color: Colors.red,
    articles: [
      Article(
        title: "NEAT Activity",
        subtitle: "Burn calories without 'exercising'.",
        icon: Icons.directions_walk,
        color: Colors.redAccent,
        readTime: "4 min",
        content: "NEAT stands for Non-Exercise Activity Thermogenesis. It's the energy expended for everything we do that is not sleeping, eating, or sports-like exercise. Walking to work, typing, gardening, and even fidgeting counts. Increasing NEAT is a powerful way to manage weight."
      ),
      Article(
        title: "HIIT Basics",
        subtitle: "Maximum burn in minimum time.",
        icon: Icons.timer,
        color: Colors.deepOrange,
        readTime: "6 min",
        content: "High-Intensity Interval Training (HIIT) involves short bursts of intense exercise alternated with low-intensity recovery periods. It is incredibly efficient for burning fat and boosting metabolism for hours after the workout."
      ),
    ],
  ),
  Category(
    name: "Mindset",
    color: Colors.purple,
    articles: [
      Article(
        title: "Sleep & Weight",
        subtitle: "The hidden link to obesity.",
        icon: Icons.bedtime,
        color: Colors.indigo,
        readTime: "5 min",
        content: "Poor sleep triggers cortisol spikes and hunger hormones like ghrelin, making you crave high-calorie foods. Prioritizing 7-9 hours of quality sleep is as important as your diet and workout routine."
      ),
      Article(
        title: "Mindful Eating",
        subtitle: "Stop eating on autopilot.",
        icon: Icons.self_improvement,
        color: Colors.purple,
        readTime: "4 min",
        content: "Mindful eating is about maintaining an in-the-moment awareness of the food and drink you put into your body. It involves observing how the food makes you feel and the signals your body sends about taste, satisfaction, and fullness."
      ),
    ],
  ),
];

// --- MAIN VIEW ---
class TipsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // 1. RICH HEADER
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF2D3142),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: EdgeInsets.only(left: 20, bottom: 20),
              // --- HEADER UPDATE ---
              title: Text(
                "HealthBuddy",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2D3142), Color(0xFF4F5D75)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(right: -30, top: -20, child: Icon(Icons.health_and_safety, size: 150, color: Colors.white.withOpacity(0.1))),
                    Positioned(bottom: 60, left: 20, child: Text("Health Library", style: TextStyle(color: Colors.white70, fontSize: 14))),
                  ],
                ),
              ),
            ),
          ),

          // 2. FEATURED CAROUSEL
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              child: Text("Trending Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: libraryData[0].articles.length,
                itemBuilder: (context, index) {
                  return _buildFeaturedCard(context, libraryData[0].articles[index]);
                },
              ),
            ),
          ),

          // 3. VERTICAL CATEGORY LIST
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = libraryData[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            Container(width: 4, height: 20, color: category.color),
                            SizedBox(width: 10),
                            Text(category.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                          ],
                        ),
                      ),
                      ...category.articles.map((article) => _buildArticleTile(context, article)).toList(),
                    ],
                  );
                },
                childCount: libraryData.length,
              ),
            ),
          ),
          
          // Bottom padding
          SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildFeaturedCard(BuildContext context, Article article) {
    return GestureDetector(
      onTap: () => _openArticle(context, article),
      child: Container(
        width: 260,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [article.color, article.color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: article.color.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                  child: Text(article.readTime, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                Icon(article.icon, color: Colors.white, size: 24),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 5),
                Text(article.subtitle, style: TextStyle(color: Colors.white70, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildArticleTile(BuildContext context, Article article) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: article.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(article.icon, color: article.color),
        ),
        title: Text(article.title, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
        subtitle: Text(article.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () => _openArticle(context, article),
      ),
    );
  }

  void _openArticle(BuildContext context, Article article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(
            controller: controller,
            padding: EdgeInsets.zero,
            children: [
              // HEADER IMAGE AREA
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: article.color,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Stack(
                  children: [
                    Center(child: Icon(article.icon, size: 80, color: Colors.white.withOpacity(0.5))),
                    Positioned(
                      top: 20, right: 20,
                      child: IconButton(icon: Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text("${article.readTime} read", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(article.title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF2D3142), height: 1.2)),
                    SizedBox(height: 10),
                    Text(article.subtitle, style: TextStyle(fontSize: 18, color: Colors.grey[600], fontStyle: FontStyle.italic)),
                    SizedBox(height: 30),
                    Divider(),
                    SizedBox(height: 30),
                    Text(article.content, style: TextStyle(fontSize: 16, height: 1.8, color: Colors.black87)),
                    SizedBox(height: 50),
                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.check, size: 18),
                        label: Text("Mark as Read"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: article.color,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}