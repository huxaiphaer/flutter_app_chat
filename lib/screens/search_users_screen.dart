import 'package:flutter/material.dart';
import 'package:flutterappchat/models/user_data.dart';
import 'package:flutterappchat/models/user_model.dart';
import 'package:flutterappchat/screens/create_chat_screen.dart';
import 'package:flutterappchat/services/database_service.dart';
import 'package:provider/provider.dart';

class SearchUserScreen extends StatefulWidget {
  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _users = [];
  List<User> _selectedUsers = [];

  _clearSearch() {
    // setting the TextEditor to empty.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.clear();
    });

    setState(() {
      _users = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider
        .of<UserData>(context, listen: false)
        .currentUserId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search users'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {

              if(_selectedUsers.length > 0){
                Navigator.push(context, MaterialPageRoute(builder: (_) => CreateChatScreen(selectedUsers: _selectedUsers,)),);
              }
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                border: InputBorder.none,
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  size: 30.0,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _clearSearch,
                ),
                filled: true),
            onSubmitted: (input) async {
              if (input.trim().isNotEmpty) {
                List<User> users =
                await Provider.of<DatabaseService>(context, listen: false)
                    .searchUsers(currentUserId, input);

                _selectedUsers.forEach((user) => users.remove(user));
                setState(() => _users = users);
              }
            },
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _selectedUsers.length + _users.length,
                // ignore: missing_return
                itemBuilder: (BuildContext context, int index) {
                  if (index < _selectedUsers.length) {
                    //Selected Users

                    User selectedUser = _selectedUsers[index];
                    return ListTile(
                      title: Text(selectedUser.name),
                      trailing: Icon(Icons.check_circle),
                      onTap: () {
                        _selectedUsers.remove(selectedUser);
                        _users.insert(0, selectedUser);
                        //Re-render our widget tree
                        setState(() {});
                      },
                    );
                  }

                  int userIndex = index - _selectedUsers.length;
                  User user = _users[userIndex];

                  return ListTile(
                    title: Text(user.name),
                    trailing: Icon(Icons.check_circle_outline),
                    onTap: () {
                      _selectedUsers.add(user);
                      _users.remove(user);
                      //Re-render our widget tree
                      setState(() {});
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
