import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class Figure {
  final int code;
  final String title;
  final String description;
  final String image;
  final bool aShow;
  final bool bShow;
  final bool hShow;

  Figure(this.code, this.title, this.description, this.image, this.aShow,
      this.bShow, this.hShow);
}

class Parameters {
  int code;
  double a=0;
  double b=0;
  double h=0;
  double d1=0;
  double d2=0;

  double calcArea() {
    switch (code) {
      case 1:
        return a * h / 2;
      case 2:
        return a * h / 2;
      case 3:
        return a * h / 2;
      case 4:
        return a * b;
      case 5:
        return a * a;
      case 6:
        return a * h;
      case 7:
        if (d1 > 0 && d2 > 0) return d1 * d2 / 2;
        if (a > 0 && h > 0) return a * h;
        return 0;
      case 8:
        return (a + b) * h / 2;
      case 9:
        return (a + b) * h / 2;
    }
    return 0;
  }
}

void main() {
  runApp(MaterialApp(
    //debugShowCheckedModeBanner: false,
    title: 'Matematyka',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  final List<Figure> figures = [
    Figure(1, 'Trójkąt', 'Pole trójkąta', 'images/Triangle.png', true, false,
        true),
    Figure(2, 'Trójkąt równoboczny', 'Pole trójkąta',
        'images/Triangle_isosceles.png', true, false, true),
    Figure(3, 'Trójkąt prostokątny', 'Pole trójkąta',
        'images/Triangle_rectangular.png', true, false, true),
    Figure(4, 'Prostokąt', 'Pole prostokąta', 'images/Rectangle.png', true,
        true, false),
    Figure(
        5, 'Kwadrat', 'Pole kwadratu', 'images/Square.png', true, false, false),
    Figure(6, 'Równoległobok', 'Pole równoległoboku',
        'images/Parallelogram.png', true, false, true),
    Figure(7, 'Romb', 'Pole rombu', 'images/Diamond.png', true, false, true),
    Figure(
        8, 'Trapez', 'Pole trapezu', 'images/Trapezoid.png', true, true, true),
    Figure(9, 'Trapez równoramienny', 'Pole trapezu',
        'images/Trapezoid_isosceles.png', true, true, true),
  ];

  @override
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Figury'),
      ),
      body: ListView.builder(
        itemCount: figures.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(figures[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Details(),
                  settings: RouteSettings(
                    arguments: figures[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Parameters param = Parameters();
  String answer = '';

  String _validateNumber(String value) {
    int _valueAsInteger = value.isEmpty ? 0 : int.tryParse(value);
    return _valueAsInteger < 0 ? 'Wartość musi być dodatnia ($value)' : null;
  }

  void _submitOrder() {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
      setState(() {
        answer = 'Pole ' + param.calcArea().toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Figure figure = ModalRoute.of(context).settings.arguments;
    param..code = figure.code;

    var bar = AppBar(
      title: Text(figure.title),
    );

    Widget titleSection = Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(figure.description,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center),
          Divider(),
          Image(
            image: AssetImage(figure.image),
          ),
          Divider(),
          Form(
            key: _formStateKey,
            autovalidate: true,
            child: Padding(
              padding: EdgeInsets.all(16.0 ),
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: figure.aShow,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Podaj bok a',
                          labelText: 'a',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => _validateNumber(value),
                        onSaved: (value) => param.a = double.tryParse(value),
                        keyboardType: TextInputType.number,
                      ),
                  ),
                  Visibility(
                      visible: figure.bShow,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Podaj bok b',
                          labelText: 'b',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => _validateNumber(value),
                        onSaved: (value) => param.b = double.tryParse(value),
                        keyboardType: TextInputType.number,

                      ),
                  ),
                  Visibility(
                      visible: figure.hShow,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Podaj wysokość',
                          labelText: 'h',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => _validateNumber(value),
                        onSaved: (value) => param.h = double.tryParse(value),
                        keyboardType: TextInputType.number,
                      ),
                  ),
                  RaisedButton(
                    onPressed: () => _submitOrder(),
                    child: Text('Oblicz pole'),
                    color: Colors.lightGreen,
                  ),
            Container(
              margin: EdgeInsets.all(10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TeXView(
                    teXHTML: r"""$$Pole trójkąta = \frac{1}{2}ah$$""",
                    loadingWidget: Center(
                      child: Text("My Custom Loading Widget"),
                    ),
                  ),
                ),
              ),
            ),                  
                  Text(
                    answer,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: bar,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: titleSection,
      ),
    );
  }
}
