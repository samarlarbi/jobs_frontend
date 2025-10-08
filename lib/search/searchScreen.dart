import 'package:flutter/material.dart';
import 'package:jobs_app/Controller/Controller.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/simpleappbar.dart';
import 'package:jobs_app/workerPage/WorkerScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

    Controller controller = Controller();
    TextEditingController  q= TextEditingController();
    List<Map<String, dynamic>> searchlist=[];
    @override
    void initState() {
      super.initState();
      search(q.text);
    }

  Future<void> search(String q) async
  {
    try{
      var res = await  controller.searchworker(q: q);
if (!mounted) return;
setState(() {        searchlist = res;
      });


    }catch(e){

    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(context, "Search"),


      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(9),
            child: TextField(
              onChanged: (value) => search(value),
              
             decoration: InputDecoration(
  prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 170, 172, 172)),
  
  hintText: 'search...',
  hintStyle: TextStyle(color: Colors.grey),
  enabledBorder: OutlineInputBorder( borderSide: BorderSide(
      color: Color.fromARGB(255, 170, 172, 172),
      width: 1,
    ),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  ),
  focusedBorder: OutlineInputBorder( borderSide: BorderSide(
      color: const Color.fromARGB(255, 109, 110, 110),
      width: 1,
    ),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  ),
  
  
  ),
  cursorColor: Colors.black,
  

   

            )
          ),
      
Container(
  height:MediaQuery.of(context).size.height ,
  child: ListView.builder(
    itemCount: searchlist.length,
    
    itemBuilder: 
  (context,index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:  15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 210, 210, 210)))
      ),
      child: ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Workerscreen(id: searchlist[index]["id"])));
        },
  
  
      leading:   Container(
      
                  height: MediaQuery.of(context).size.width*0.15,
                  width: MediaQuery.of(context).size.width*0.13,
                  decoration: BoxDecoration(
                color: loading,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: (searchlist[index]["imgprofile"] != null &&
        searchlist[index]["imgprofile"].trim().isNotEmpty)
    ? Image.network(
        searchlist[index]["imgprofile"],
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.person, size: 45)),
      )
    : const Center(child: Icon(Icons.person, size: 45)),
                ),
                title:Text( searchlist[index]["name"]),
                subtitle: Text( searchlist[index]["email"],style:TextStyle(color:Colors.grey)),
      
      ),
    );
  }),
)


        ],
      ),
    );
  }
}