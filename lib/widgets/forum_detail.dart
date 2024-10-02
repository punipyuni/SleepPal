import 'package:flutter/material.dart';

class PostDetailPage extends StatefulWidget {
  final String title;
  final String author;
  final String avatarUrl;

  const PostDetailPage({
    Key? key,
    required this.title,
    required this.author,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-1.0, -0.8),
            radius: 1.3,
            colors: [
              Color(0xFF6C51A6),
              Color(0xFF1A102E),
              Color(0xFF131417),
            ],
            stops: [0.17, 0.56, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.avatarUrl),
                      radius: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.author,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "This is the content of the post...",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 20),

                            // Divider to separate content and replies
                            Divider(color: Colors.white.withOpacity(0.5), thickness: 1),

                            SizedBox(height: 20), // Space after divider
                            
                            Text(
                              'Replies',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // Example replies - replace with actual data
                          final replies = [
                            Reply("Nick", "https://example.com/nick.jpg", "Hey there, Just stumbled upon this forum while browsing for ways to improve my sleep, and I'm totally onboard! Chapter 3 sounds promising—I've been looking to establish a better bedtime routine to unwind after busy days. Can't wait to give it a shot and see how it goes. Thanks for starting this discussion!"),
                            Reply("Nicky", "https://example.com/nicky.jpg", "Hi! I'm in the same boat! Just found this forum while searching for sleep tips online. Chapter 2 caught my eye—I definitely need to revamp my sleep environment. It's been feeling more like a workspace than a sanctuary lately. Looking forward to hearing about everyone's experiences and trying out some new ideas."),
                          ];
                          if (index >= replies.length) return null;
                          return ReplyWidget(reply: replies[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Reply input
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Write a reply...',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color:
                                    Colors.white.withOpacity(0.3)),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color:
                                    Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon:
                          Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        // TODO: Implement reply submission
                        print('Reply: ${_replyController.text}');
                        _replyController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
}

class Reply {
  final String author;
  final String avatarUrl;
  final String content;

  Reply(this.author, this.avatarUrl, this.content);
}

class ReplyWidget extends StatelessWidget {
  final Reply reply;

  const ReplyWidget({Key? key, required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children:[
          CircleAvatar(
            backgroundImage:
                NetworkImage(reply.avatarUrl),
            radius:
                15,
          ),
          SizedBox(width:
              10),
          Expanded(child:
              Column(crossAxisAlignment:
                  CrossAxisAlignment.start, children:[
            Text(reply.author,
                style:
                    TextStyle(color:
                        Colors.white, fontWeight:
                        FontWeight.bold)),
            SizedBox(height:
                5),
            Text(reply.content,
                style:
                    TextStyle(color:
                        Colors.white)),
          ])),
        ],
      ));
}
}