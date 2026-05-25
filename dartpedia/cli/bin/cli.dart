import "dart:io";
import "package:http/http.dart" as http;

const version = "0.0.1";

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == "help"){
      printUsage();
  } else if (arguments.first == "version"){
      print("Dartpedia, version number ${version}");
  } else if (arguments.first == "wikipedia"){
      final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null; // I have already ensured that the arguments length is > 1, since we are filtering out search. There has to be a better way to express it. Note: This is correct way since we are implementing and checking for > 1 which means "search" will not be included
      searchWikipedia(inputArgs);
  } else {
      printUsage(); 
  }
}

void printUsage(){
  print("Dartpedia app uses these commands, help, version and wikipedia <Wiki search term> for wikipedia search.");
}

// search function
void searchWikipedia(List<String>? arguments) async {
    final String articleTitle;

    if (arguments == null || arguments.isEmpty){
        print("Please provide an article title");
        final inputFromStdin = stdin.readLineSync(); 
        if (inputFromStdin == null || inputFromStdin.isEmpty){
            print("No Article title provided"); // The if block does not consider space as an empty value; it should
            return;
        } else {
            articleTitle = inputFromStdin;
        }
    } else {
        articleTitle = arguments.join(" ");
    }
    print("Looking up articles about ${articleTitle}");
    var articleContent = await getWikipediaArticle(articleTitle);
    print(articleContent);
}

// get wikipedia article from an API call
Future<String> getWikipediaArticle(String articleTitle) async{
    final url = Uri.https(
    'en.wikipedia.org',
    '/api/rest_v1/page/summary/$articleTitle');

    final response = await http.get(url);

    // checking the response of the above api call
    if (response.statusCode == 200){
        return response.body;
    }

    // In case of an error
    return 'Error: The API call to the ${articleTitle} has resulted in failure with the error code ${response.statusCode}';
}
// Questions
// where is the argument getting its value from?
//  The command line arguments are getting passed in the arguments. The arguments are in the form of strings
