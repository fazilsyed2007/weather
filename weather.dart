import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _city = '';
  String _description = '';
  double _temperature = 0;
  String _error = '';

  Future<void> fetchWeather(String city) async {
    final apiKey = 'YOUR_API_KEY'; // Replace with your OpenWeatherMap API key
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _city = data['name'];
          _description = data['weather'][0]['description'];
          _temperature = data['main']['temp'];
          _error = '';
        });
      } else {
        setState(() {
          _error = 'City not found!';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching weather data.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter city',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => fetchWeather(_controller.text),
                ),
              ),
              onSubmitted: (value) => fetchWeather(value),
            ),
            SizedBox(height: 20),
            if (_error.isNotEmpty)
              Text(_error, style: TextStyle(color: Colors.red)),
            if (_city.isNotEmpty && _error.isEmpty) ...[
              Text('City: $_city', style: TextStyle(fontSize: 22)),
              Text('Temperature: $_temperature°C',
                  style: TextStyle(fontSize: 18)),
              Text('Description: $_description',
                  style: TextStyle(fontSize: 16)),
            ]
          ],
        ),
      ),
    );
  }
}
