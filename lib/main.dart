import 'package:flutter/material.dart';

void main() => runApp(BytebankApp());

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencias(),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controllerCampoNumeroConta = TextEditingController();
  final TextEditingController _controllerCampoNumeroValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Transferência'),
      ),
      body: Column(
        children: [
          Editor(
            controlador: _controllerCampoNumeroConta,
            rotulo: 'Número da conta',
            dica: '0000',
          ),
          Editor(controlador: _controllerCampoNumeroValor, rotulo: 'Valor', dica: '0.00'),
          ElevatedButton(
            onPressed: () => _criaTransferencia(context),
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    var numeroConta = int.tryParse(_controllerCampoNumeroConta.text);
    var numeroValor = double.tryParse(_controllerCampoNumeroValor.text);

    if (numeroConta != null && numeroValor != null) {
      final transferenciaCriada = Transferencia(numeroValor, numeroConta);
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(
          fontSize: 24.0,
        ),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListaTransferencias extends StatelessWidget {
  final List<Transferencia> _transferencias = [];

  @override
  Widget build(BuildContext context) {
    _transferencias.add(Transferencia(100.00, 100));
    return Scaffold(
      appBar: AppBar(
        title: Text('Transferências'),
      ),
      body: ListView.builder(
        itemCount: _transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = _transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<Transferencia> future = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormularioTransferencia();
              },
            ),
          ) as Future<Transferencia>;

          future.then((transferenciaRecebida) {
            debugPrint('$transferenciaRecebida');
            _transferencias.add(transferenciaRecebida);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}
// Statefull Capacidade de modificar o conteudo do widget de maneira dinamica, consegue modificar o conteudo
// Stateless Nao consegue mudar o conteudo,
