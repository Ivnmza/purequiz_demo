import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class GoToAnimTestButton extends StatelessWidget {
  /// {@macro add_todo_button}
  const GoToAnimTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const MyHomePage();
          }));
        },
        child: Material(
          color: const Color.fromARGB(255, 9, 52, 65),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: const Icon(
            Icons.search,
            size: 56,
          ),
        ),
      ),
    );
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchString = 'start';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: OpenContainer<String>(
            openBuilder: (_, closeContainer) =>
                SearchPage(onClose: closeContainer),
            onClosed: (res) => setState(() {
              if (res == null) {
                searchString = "";
              } else{
              searchString = res;
               }
            }),
            tappable: false,
            closedBuilder: (_, openContainer) => SearchBar(
              searchString: searchString,
              openContainer: openContainer,
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar(
      {super.key, required this.searchString, required this.openContainer});

  final String searchString;
  final VoidCallback openContainer;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: openContainer,
        child: Container(
          padding: const EdgeInsets.all(10),
          color: const Color.fromARGB(255, 14, 127, 106),
          child: Row(
            children: [
              const Icon(Icons.search),
              const SizedBox(width: 10),
              // ignore: unnecessary_null_comparison
              searchString != null
                  ? Expanded(child: Text(searchString))
                  : const Spacer(),
              const Icon(Icons.mic),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.onClose});

  final void Function({String returnValue}) onClose;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                    blurRadius: 1,
                    color: Colors.black26,
                  )
                ],
                color: Color.fromARGB(255, 83, 30, 231),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: onClose,
                  ),
                  const Spacer(),
                  const Icon(Icons.mic),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () => onClose(returnValue: 'Flutter'),
                    child: const Text('Search: "Flutter"'),
                  ),
                  TextButton(
                    onPressed: () => onClose(returnValue: 'Rabbit'),
                    child: const Text('Search: "Rabbit"'),
                  ),
                  TextButton(
                    onPressed: () => onClose(returnValue: 'What is the Matrix'),
                    child: const Text('Search: "What is the Matrix"'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
