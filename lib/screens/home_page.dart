import 'package:flutter/material.dart';
import '../models/endereco_model.dart';
import '../repositories/cep_repository.dart';
import '../repositories/cep_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;
  bool loading = false;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Buscar CEP',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              //logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Container(
                  child: const Icon(
                    Icons.find_replace_sharp,
                    size: 70,
                    color: Color.fromARGB(255, 74, 213, 223),
                  ),
                ),
              ),

              //Formulário de entrada de texto
              //validação de valor de entrada no campo de cep
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: cepEC,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Cep Obrigatório';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'CEP',
                  ),
                ),
              ),

              SizedBox(height: 20),

              //Botão de busca
              ElevatedButton(
                onPressed: () async {
                  final valid = formKey.currentState?.validate() ?? false;
                  if (valid) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      final endereco = await cepRepository.getCep(cepEC.text);
                      setState(() {
                        loading = false;
                        enderecoModel = endereco;
                      });
                    } catch (e) {
                      setState(() {
                        loading = false;
                        enderecoModel = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Erro ao buscar Cep"),
                      ));
                    }
                  }
                },
                child: const Text("Buscar"),
              ),
              Visibility(
                visible: loading == true,
                child: const CircularProgressIndicator(),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: enderecoModel != null,
                child: Text(
                    '${enderecoModel?.logradouro} ${enderecoModel?.complemento} ${enderecoModel?.cep}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
