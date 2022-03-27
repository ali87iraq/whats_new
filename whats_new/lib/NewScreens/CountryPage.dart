import 'package:flutter/material.dart';
import 'package:whats_new/Model/CountryModel.dart';

class CounryPage extends StatefulWidget {
  const CounryPage({Key? key, required this.setCountryData}) : super(key: key);
  final Function setCountryData;

  @override
  _CounryPageState createState() => _CounryPageState();
}

class _CounryPageState extends State<CounryPage> {
  List<CountryModel> countries = [
    CountryModel(name: 'Afghanistan', code: '+93', flag: '🇦🇫'),
    CountryModel(name: 'Albania', code: '+355', flag: '🇮🇶'),
    CountryModel(name: 'Algeria', code: '+213', flag: '🇮🇶'),
    CountryModel(name: 'Andorra', code: '+376', flag: '🇮🇶'),
    CountryModel(name: 'Angola', code: '+244', flag: '🇮🇶'),
    CountryModel(name: 'Argentina', code: '+54', flag: '🇮🇶'),
    CountryModel(name: 'Armenia', code: '+374', flag: '🇮🇶'),
    CountryModel(name: 'Aruba', code: '+297', flag: '🇮🇶'),
    CountryModel(name: 'Australia', code: '+61', flag: '🇮🇶'),
    CountryModel(name: 'Bahrain', code: '+973', flag: '🇮🇶'),
    CountryModel(name: 'Bangladesh', code: '+880', flag: '🇮🇶'),
    CountryModel(name: 'Belarus', code: '+375', flag: '🇮🇶'),
    CountryModel(name: 'Belgium', code: '+32', flag: '🇮🇶'),
    CountryModel(name: 'Burundi', code: '+257', flag: '🇮🇶'),
    CountryModel(name: 'Cape Verde', code: '+238', flag: '🇮🇶'),
    CountryModel(name: 'Cambodia', code: '+855', flag: '🇮🇶'),
    CountryModel(name: 'Cameroon', code: '+237', flag: '🇮🇶'),
    CountryModel(name: 'Canada', code: '+1', flag: '🇮🇶'),
    CountryModel(name: 'Chad', code: '+235', flag: '🇮🇶'),
    CountryModel(name: 'Chile', code: '+56', flag: '🇨🇱'),
    CountryModel(name: 'China', code: '+86', flag: '🇨🇳'),
    CountryModel(name: 'India', code: '+91', flag: '🇮🇳'),
    CountryModel(name: 'Indonesia', code: '+62', flag: '🇮🇩'),
    CountryModel(name: 'Iran', code: '+98', flag: '🇮🇷'),
    CountryModel(name: 'iraq', code: '+964', flag: '🇮🇶'),
    CountryModel(name: 'iraq', code: '+964', flag: '🇮🇶'),
    CountryModel(name: 'Ireland', code: '+353', flag: '🇮🇪'),
    CountryModel(name: 'Italy', code: '+39', flag: '🇮🇹'),
    CountryModel(name: 'Tunisia', code: '+216', flag: '🇹🇳'),
    CountryModel(name: 'Turkey', code: '+90', flag: '🇹🇷'),
    CountryModel(name: 'Turkmenistan', code: '+993', flag: '🇮🇶'),
    CountryModel(name: 'Ukraine', code: '+380', flag: '🇺🇦'),
    CountryModel(name: 'United Arab Emirates', code: '+971', flag: '🇦🇪'),
    CountryModel(name: 'United Kingdom', code: '+44', flag: '🇬🇧'),
    CountryModel(name: 'United States', code: '+1', flag: '🇺🇸'),
    CountryModel(name: 'iraq', code: '+964', flag: '🇮🇶'),
    CountryModel(name: 'iraq', code: '+964', flag: '🇮🇶'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.teal,
          ),
        ),
        title: Text(
          'choose a country',
          style: TextStyle(
              wordSpacing: 1,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.teal),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.teal,
            ),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, i) {
            print("===> " + i.toString());
            return card(countries[i]);
          }),
    );
  }

  Widget card(CountryModel country) {
    return InkWell(
      onTap: () {
        print(country.name);
        widget.setCountryData(country);
      },
      child: Card(
        margin: EdgeInsets.all(0.15),
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Text(country.flag),
              SizedBox(
                width: 10,
              ),
              Text(country.name),
              Expanded(
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(country.code),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
