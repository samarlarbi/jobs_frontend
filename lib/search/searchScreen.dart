import 'package:flutter/material.dart';
import 'package:jobs_app/Controller/Controller.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/appbar.dart';
import 'package:jobs_app/workerPage/WorkerScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Controller controller = Controller();
  TextEditingController q = TextEditingController();
  List<Map<String, dynamic>> searchlist = [];

  @override
  void initState() {
    super.initState();
    search(q.text);
  }

  Future<void> search(String q) async {
    try {
      var res = await controller.searchworker(q: q);
      if (!mounted) return;
      setState(() {
        searchlist = res;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("Search"),
      backgroundColor: const Color.fromARGB(209, 255, 253, 253),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: TextField(
              onChanged: (value) => search(value),
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: const InputDecoration(

                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: Color.fromARGB(255, 204, 206, 206),
                ),
                hintText: 'Search...',
                hintStyle: TextStyle(
                    color: Color.fromARGB(255, 195, 197, 197), fontSize: 13),

                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),

                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 154, 155, 157), width: 2),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: searchlist.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                   ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Workerscreen(id: searchlist[index]["id"]),
                        ),
                      );
                    },
                    leading: Container(
                      height: MediaQuery.of(context).size.width * 0.13,
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 223, 223, 223),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: (searchlist[index]["imgprofile"] != null &&
                              searchlist[index]["imgprofile"].trim().isNotEmpty)
                          ? Image.network(
                              searchlist[index]["imgprofile"],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 35,
                                  color: Color.fromARGB(255, 178, 177, 177),
                                ),
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.person,
                                size: 35,
                                color: Color.fromARGB(255, 178, 177, 177),
                              ),
                            ),
                    ),
                    title: Text(searchlist[index]["name"]),
                    subtitle: Text(
                      searchlist[index]["email"],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
