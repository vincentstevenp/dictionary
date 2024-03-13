import 'package:flutter/material.dart';
import 'package:dictionary/api.dart';
import 'package:dictionary/response_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool inProgress = false;
  ResponseModel? responseModel;
  String noDataText = "Welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _buildSearchWidget(),
            SizedBox(height: 12),
            if (inProgress)
              LinearProgressIndicator(color: Colors.white)
            else if (responseModel != null)
              Expanded(child: _buildResponseWidget())
            else
              _noDataWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          responseModel!.word!,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Text(responseModel!.phonetic ?? "", style: TextStyle(color: Colors.white)),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildMeaningWidget(responseModel!.meanings![index]);
            },
            itemCount: responseModel!.meanings!.length,
          ),
        )
      ],
    );
  }

  Widget _buildMeaningWidget(Meanings meanings) {
    String definitionList = "";
    meanings.definitions?.forEach(
          (element) {
        int index = meanings.definitions!.indexOf(element);
        definitionList += "\n${index + 1}. ${element.definition}\n";
      },
    );

    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meanings.partOfSpeech!,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Definitions : ",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              definitionList,
              style: TextStyle(color: Colors.red),
            ),
            _buildSet("Synonyms", meanings.synonyms),
            _buildSet("Antonyms", meanings.antonyms),
          ],
        ),
      ),
    );
  }

  Widget _buildSet(String title, List<String>? setList) {
    if (setList?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Text(
            setList!
                .toSet()
                .toString()
                .replaceAll("{", "")
                .replaceAll("}", ""),
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 10),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _noDataWidget() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          noDataText,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Center(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          style: TextStyle(color: Colors.red),
          decoration: InputDecoration(
            hintText: 'Search word here',
            hintStyle: TextStyle(color: Colors.red),
            border: InputBorder.none,
            suffixIcon: ClipOval(
              child: Material(
                color: Colors.red,
                child: IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    // Add your search functionality here
                  },
                ),
              ),
            ),
          ),
          onSubmitted: (value) {
            _getMeaningFromApi(value);
          },
        ),
      ),
    );
  }

  void _getMeaningFromApi(String word) async {
    setState(() {
      inProgress = true;
    });
    try {
      responseModel = await API.fetchMeaning(word);
      setState(() {});
    } catch (e) {
      responseModel = null;
      noDataText = "Meaning cannot be fetched";
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
