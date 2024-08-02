import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/airplane_repository.dart';
import '../../presentation/cubit/airplane_cubit.dart';
import '../../data/models/airplane_model.dart';

class AirplaneListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      AirplaneCubit(AirplaneRepository())
        ..fetchAirplanes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Airplanes'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                context.read<AirplaneCubit>().fetchAirplanes();
              },
            ),
          ],
        ),
        body: BlocListener<AirplaneCubit, AirplaneState>(
          listener: (context, state) {
            if (state is AirplaneLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Airplane list updated')),
              );
            } else if (state is AirplaneError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update airplane list')),
              );
            }
          },
          child: BlocBuilder<AirplaneCubit, AirplaneState>(
            builder: (context, state) {
              if (state is AirplaneLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is AirplaneLoaded) {
                final airplanes = state.airplanes;
                return ListView.builder(
                  itemCount: airplanes.length,
                  itemBuilder: (context, index) {
                    final airplane = airplanes[index];
                    return ListTile(
                      title: Text('Model: ${airplane.modelo}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${airplane.id}'),
                          Text('Manufacturer: ${airplane.fabricante}'),
                          Text('Capacity: ${airplane.capacidad}'),
                          Text('Range: ${airplane.rango}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditAirplaneDialog(context, airplane);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              context.read<AirplaneCubit>().removeAirplane(
                                  airplane.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is AirplaneError) {
                return Center(child: Text(state.message));
              }
              return Center(child: Text('No data available'));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreateAirplaneDialog(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showCreateAirplaneDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _modeloController = TextEditingController();
    final _fabricanteController = TextEditingController();
    final _capacidadController = TextEditingController();
    final _rangoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Airplane'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _modeloController,
                  decoration: InputDecoration(labelText: 'Modelo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the model';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _fabricanteController,
                  decoration: InputDecoration(labelText: 'Fabricante'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the manufacturer';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _capacidadController,
                  decoration: InputDecoration(labelText: 'Capacidad'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the capacity';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _rangoController,
                  decoration: InputDecoration(labelText: 'Rango'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the range';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Create'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final airplane = Airplane(
                    id: '',
                    // ID will be auto-generated by the backend
                    modelo: _modeloController.text,
                    fabricante: _fabricanteController.text,
                    capacidad: int.parse(_capacidadController.text),
                    rango: _rangoController.text,
                  );
                  context.read<AirplaneCubit>().addAirplane(airplane);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }


  void _showEditAirplaneDialog(BuildContext context, Airplane airplane) {
    final _formKey = GlobalKey<FormState>();
    final _modeloController = TextEditingController(text: airplane.modelo);
    final _fabricanteController = TextEditingController(
        text: airplane.fabricante);
    final _capacidadController = TextEditingController(
        text: airplane.capacidad.toString());
    final _rangoController = TextEditingController(text: airplane.rango);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Airplane'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _modeloController,
                  decoration: InputDecoration(labelText: 'Modelo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the model';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _fabricanteController,
                  decoration: InputDecoration(labelText: 'Fabricante'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the manufacturer';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _capacidadController,
                  decoration: InputDecoration(labelText: 'Capacidad'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the capacity';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _rangoController,
                  decoration: InputDecoration(labelText: 'Rango'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the range';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final updatedAirplane = Airplane(
                    id: airplane.id,
                    modelo: _modeloController.text,
                    fabricante: _fabricanteController.text,
                    capacidad: int.parse(_capacidadController.text),
                    rango: _rangoController.text,
                  );
                  context.read<AirplaneCubit>().updateAirplane(updatedAirplane);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
