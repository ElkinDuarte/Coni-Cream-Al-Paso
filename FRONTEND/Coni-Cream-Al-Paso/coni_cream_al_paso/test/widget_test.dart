// Widget tests para la pantalla de Login de Coni-Cream Al Paso.

import 'package:flutter_test/flutter_test.dart';

import 'package:coni_cream_al_paso/main.dart';

void main() {
  testWidgets('La pantalla de login se renderiza correctamente', (
    WidgetTester tester,
  ) async {
    // Construye la app y genera el primer frame.
    await tester.pumpWidget(const AlPasoApp());
    await tester.pump();

    // Verifica que los elementos clave del login están presentes.
    expect(find.text('AlPaso'), findsOneWidget);
    expect(find.text('Numero Documento'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.text('Registrarse'), findsOneWidget);
  });

  testWidgets('Muestra error al intentar ingresar con campos vacíos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AlPasoApp());
    await tester.pump();

    // Toca el botón "Ingresar" sin llenar campos.
    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    // Verifica que aparece el mensaje de error.
    expect(
      find.text('Por favor ingresa tu documento y contraseña'),
      findsOneWidget,
    );
  });
}
