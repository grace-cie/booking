import 'package:flutter/material.dart';

void main(){
  runApp(const ProfileUi());
}

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  @override
  State<StatefulWidget> createState() => ProfileUiState();
}

class ProfileUiState extends State<ProfileUi>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1580981794240-a0c7e5d10b1a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(
                  "John Doe",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "johndoe@email.com",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80"),
                          fit: BoxFit.cover)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "John Doe",
                        style: TextStyle(
                        fontSize: 18,
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("johndoe@email.com"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text("555-555-5555"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text("123 Main St, Anytown USA 12345"),
          ),
          TextButton(
              child: Text("Edit Profile"),
              onPressed: () {
              // navigate to edit profile screen or perform other actions
              },
          )
        ],
      ),
    );
  }
}