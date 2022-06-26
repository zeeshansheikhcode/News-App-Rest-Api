import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'model.dart';
class Category extends StatefulWidget {
  String Query;
Category({required this.Query});

 // const Category({ Key? key }) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  //DateTime? times_now; 
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  bool isLoading = true;
  var now;
  var formatter;
  String? formattedDate;
  @override
void initState() {
 super.initState();
 
    now           = new DateTime.now();
    formatter     = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    getNewsByQuery(widget.Query,formattedDate!);
   // getNewsByQuery(widget.Query);
     
}
  getNewsByQuery(String query,String datenow) async
  {
    Map element;
    int i=0;
    String url= "https://newsapi.org/v2/everything?q=$query&from=$datenow&sortBy=publishedAt&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for( element in data["articles"])
      {
        try
        {
          i++;
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading =false;
          });
          if(i==5)
          {
            break;
          }

        }
        catch(e)
        {
          print(e);
        }
      }
    });
  }


  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
    
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ARNE NEWS"),
        centerTitle: true,
        ),
       body :    SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin : EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                           SizedBox(width: 12,),
                    Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                      child: Text(widget.Query, style: TextStyle( fontSize: 39
                      ),),
                    ),
                  ],
                ),
              ),
              isLoading ? Container( height: MediaQuery.of(context).size.height -500 , child: Center(child: CircularProgressIndicator(),),) :
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsModelList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 1.0,
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(newsModelList[index].newsImg ,fit: BoxFit.fitHeight, height: 230,width: double.infinity, )),

                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(

                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black12.withOpacity(0),
                                                Colors.black
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter
                                          )
                                      ),
                                      padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newsModelList[index].newsHead,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                Text(newsModelList[index].newsDes.length > 50
                 ? 
                 "${newsModelList[index].newsDes.substring(0,55)}...." 
                 :
                  newsModelList[index].newsDes , style: TextStyle(color: Colors.white , fontSize: 12)
                                            ,)
                                        ],
                                      )))
                            ],
                          )),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
