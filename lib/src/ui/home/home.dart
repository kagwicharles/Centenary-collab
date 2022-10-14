import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rafiki/src/data/local/shared_pref/shared_preferences.dart';
import 'package:rafiki/src/data/user_model.dart';
import 'package:rafiki/src/ui/home/adverts.dart';
import 'package:rafiki/src/ui/home/home_menu_items.dart';
import 'package:rafiki/src/ui/home/top_home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _sharedPref = SharedPrefLocal();
  ScrollPhysics physics = const BouncingScrollPhysics();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(64.0), // here the desired height
            child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                title: FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (BuildContext context,
                        AsyncSnapshot<SharedPreferences> snapshot) {
                      Widget child = SizedBox();
                      if (snapshot.hasData) {
                        var sharedPref = snapshot.data;
                        child = Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              child: Image.asset("assets/images/user.png"),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 18,
                                ),
                                Text(
                                  "Hello ${_sharedPref.getUserData(sharedPref: sharedPref, key: UserAccountData.FirstName.name)}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Last Login ${_sharedPref.getUserData(sharedPref: sharedPref, key: UserAccountData.LastLoginDateTime.name)}",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () async {
                                  if (await confirm(
                                    context,
                                    title: const Text('Logout'),
                                    content:
                                        const Text('Would you like to logout?'),
                                    textOK: const Text('Confirm'),
                                    textCancel: const Text('Cancel'),

                                  )) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                icon: const Icon(Icons.power_settings_new))
                          ],
                        );
                      }
                      return child;
                    }))),
        body: ListView(
          physics: physics,
          children: [
            const SizedBox(
              height: 24,
            ),
            TopHomeWidget(),
            const SizedBox(
              height: 24,
            ),
            Stack(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(22),
                            bottomRight: Radius.circular(22),
                          )),
                      height: 200,
                      child: const Align(
                          alignment: Alignment.topCenter,
                          child: MainMenuWidget()),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(18, 124, 18, 10),
                    child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: const SubMenuWidget(),
                        )))
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            AdvertsContainer(),
            const SizedBox(
              height: 24,
            ),
          ],
        ));
  }
}
