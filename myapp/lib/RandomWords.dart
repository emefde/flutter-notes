import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:myapp/SavedWords.dart';


class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(onPressed: _pushSaved, icon: Icon(Icons.list))
        ],
      ),
      body: _buildSuggestions(),
    );
  }


  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
          pair.asPascalCase,
          style: _biggerFont
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () => _save(pair, alreadySaved),
    );
  }

  void _save(WordPair pair, bool alreadySaved) {
    setState(() {
      alreadySaved ? _saved.remove(pair) : _saved.add(pair);
    });
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => SavedWords(savedWords: _saved.toList(),
          ))
    );
  }

}
