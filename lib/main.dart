import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  MyApp({super.key}); // Estado global del tema

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Segundo Parcial',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: Principal(isDarkMode: isDarkMode),
        );
      },
    );
  }
}

class Principal extends StatefulWidget {
  final ValueNotifier<bool> isDarkMode;
  const Principal({super.key, required this.isDarkMode});

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int _currentIndex = 0;

  // Lista de pantallas para navegar
  late final List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = [
      const Home(),
      const ConversionNumeros(),
      const Convertir(),
      const CalcularScreen(),
      ModoClaroScreen(isDarkMode: widget.isDarkMode), // Paso el estado global
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segundo Parcial'),
        shadowColor: Colors.green,
      ),
      body: _paginas[_currentIndex], // Muestra la pantalla correspondiente
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: isDarkMode ? Colors.green : Colors.green,
        unselectedItemColor: isDarkMode ? Colors.grey : Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cambia la pantalla según el ícono seleccionado
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.transform),
            label: 'Transformar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Convertir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calcular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Modo claro',
          ),
        ],
      ),
    );
  }
}

// Pantallas de ejemplo
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          SizedBox.expand(
            child: Image.network(
              'https://cdn.pixabay.com/photo/2016/03/26/05/19/fractal-1280084_1280.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Texto encima
          Center(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(
              '¡BIEN VENIDOS!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                backgroundColor: Colors.black.withOpacity(0.5), // Fondo semitransparente para el texto
              ),
              
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30,),
            Text('Elige una de las opciones',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                backgroundColor: Colors.black.withOpacity(0.5)
              ),
            ),
            ]
            )
          ),
        ],
      ),
    );
  }
}
class ConversionNumeros extends StatefulWidget {
  const ConversionNumeros({super.key});

  @override
  State<ConversionNumeros> createState() => _ConversionNumerosState();
}
class _ConversionNumerosState extends State<ConversionNumeros> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  int _numeros = 0; 
  String _resultado='';
  String _seleccionBase='Decimal';
  // ignore: non_constant_identifier_names
  void Calcular(){
    if (_formkey.currentState!.validate()) {
    setState(() {
       switch (_seleccionBase) {
      case 'Binario':
        setState(() {
          _resultado = 'Binario: ${_numeros.toRadixString(2)}';
        });
        break;
      case 'Octal':
        setState(() {
          _resultado = 'Octal: ${_numeros.toRadixString(8)}';
        });
        break;
      case 'Hexadecimal':
        setState(() {
          _resultado = 'Hexadecimal: ${_numeros.toRadixString(16).toUpperCase()}';
        });
        break;
      case 'Decimal':
      default:
        setState(() {
          _resultado = 'Decimal: $_numeros';
        });
        break;
    }
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Form(
          key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            const Padding(padding: EdgeInsets.all(40),
              child: Text('Es una conversion de un numero entero a decimal, Binario, Octal, Hexadecimal'),
            ),
            const SizedBox(height: 150,),
            Padding(
              padding: const EdgeInsets.all(10.0), 
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Ingrese un valor', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese una cantidad';
                  }
                  
                  final parsedValue = int.tryParse(value);
                  if (parsedValue == null) {
                    return 'Ingrese un número válido';
                  }
                  
                  _numeros = parsedValue;
                  return null;
                },
              ),
            ),
             const SizedBox(height: 40),

            // Dropdown para seleccionar la base
            DropdownButton<String>(
              value: _seleccionBase,
              onChanged: (String? newValue) {
                setState(() {
                  _seleccionBase = newValue!;
                });
              },
              items: <String>['Decimal', 'Binario', 'Octal', 'Hexadecimal']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: () => Calcular(), child: const Text('Resolver')),
            const SizedBox(height: 20,),
            Text(_resultado,style: const TextStyle(fontSize: 20))
          ],
        )
      ),
      )
    );
  }
}

class Convertir extends StatefulWidget {
  const Convertir({super.key});

  @override
  State<Convertir> createState() => _ConvertirState();
}

class _ConvertirState extends State<Convertir> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
String _modena = 'Bolivianos';
double _numero = 0;
String _resultado = '';

void Convertir(){
  setState(() {
    if (_formkey.currentState!.validate()) {
      if (_modena == 'Dolares'){
        _resultado = '${(_numero/7).toStringAsFixed(2)}USD';
      }
      else{
        _resultado = '${(_numero*7)}Bs';
      }
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(20),
                child: Text('Conversion de modena Boliviana a modena Estado Unidense o viceversa'),
              ),
              const SizedBox(height: 200,),
              Padding(padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Igrese un valor', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese una cantidad';
                  }
                  
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null) {
                    return 'Ingrese un número válido';
                  }
                  
                  _numero = parsedValue;
                  return null;
                },
              ),
              ),
              const SizedBox(height: 30,),
             // Dropdown para seleccionar la moneda
              DropdownButton<String>(
                value: _modena,
                onChanged: (String? newValue) {
                  setState(() {
                    _modena = newValue!;
                  });
                },
                items: <String>['Bolivianos', 'Dolares']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(onPressed: () => Convertir(), child: const Text('Convertir')),
              Text(_resultado)
            ],
        )),
      ),
    );
  }
}

class CalcularScreen extends StatefulWidget {
  const CalcularScreen({super.key});

  @override
  State<CalcularScreen> createState() => _CalcularScreenState();
}

class _CalcularScreenState extends State<CalcularScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  int _numero = 0;
  String _resultado='';

  void Primos(){
    setState(() {
      if (_formkey.currentState!.validate()) {
        int count = 0;
        for(int i=1; i<=_numero; i++){
          if(_numero%i==0){
            count++;
          }
        }
        if(count == 2){
          _resultado = 'Es un numero Primo';        
        }
        else{
          _resultado = 'No es un numero primo';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Center(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(20),
                child: Text('Verificacion de numeros primos '),
              ),
              const SizedBox(height: 200,),
              Padding(padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Igrese un valor', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese una cantidad';
                  }
                  
                  final parsedValue = int.tryParse(value);
                  if (parsedValue == null) {
                    return 'Ingrese un número válido';
                  }
                  
                  _numero = parsedValue;
                  return null;
                },
              ),
              ),
             // Dropdown para seleccionar la moneda
             
              ElevatedButton(onPressed: () => Primos(), child: const Text('Verificar')),
              Text(_resultado)
            ],
        )),
      ),
    );
  }
}

// Modo Claro/Oscuro Screen
class ModoClaroScreen extends StatelessWidget {
  final ValueNotifier<bool> isDarkMode;

  const ModoClaroScreen({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isDarkMode.value ? 'Modo Oscuro Activado' : 'Modo Claro Activado',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(
              isDarkMode.value ? Icons.nightlight_round : Icons.wb_sunny,
            ),
            label: Text(isDarkMode.value ? 'Cambiar a Modo Claro' : 'Cambiar a Modo Oscuro'),
            onPressed: () {
              isDarkMode.value = !isDarkMode.value; // Cambia el estado global
            },
          ),
        ],
      ),
    );
  }
}
