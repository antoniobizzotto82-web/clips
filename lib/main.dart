import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const GbmApp());

class GbmApp extends StatelessWidget {
  const GbmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GBM SERVICIOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00BFA5), brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF10151D),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? photoPath;
  String? songPath;
  String style = 'Cuarteto cordobés';
  VideoPlayerController? preview;
  final List<String> gallery = [];
  bool generating = false;

  static const styles = [
    'Cuarteto cordobés', 'Cumbia', 'Cumbia santafesina', 'Cumbia villera',
    'Chamamé', 'Folclore argentino', 'Rock nacional', 'Pop',
    'Reguetón', 'Bachata', 'Salsa', 'Romántico'
  ];

  Future<void> choosePhoto() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result?.files.single.path != null) setState(() => photoPath = result!.files.single.path);
  }

  Future<void> chooseSong() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['mp3', 'wav', 'm4a', 'aac'],
    );
    if (result?.files.single.path != null) setState(() => songPath = result!.files.single.path);
  }

  Future<void> createClip() async {
    if (photoPath == null || songPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero seleccioná una foto y una canción.')),
      );
      return;
    }
    setState(() => generating = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => generating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La interfaz está lista. Falta conectar el servicio de IA para generar el videoclip.')),
      );
    }
  }

  Widget actionTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      color: const Color(0xFF1B2633),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00D6B2), size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  void dispose() {
    preview?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GBM SERVICIOS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF075B57), Color(0xFF172A3A)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('TU CANCIÓN, TU HISTORIA', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
              SizedBox(height: 8),
              Text('Elegí una foto, cargá tu MP3 y prepará un videoclip con inteligencia artificial.'),
            ]),
          ),
          const SizedBox(height: 16),
          actionTile(Icons.add_a_photo, 'SELECCIONAR FOTO', photoPath == null ? 'Elegí al protagonista' : 'Foto seleccionada', choosePhoto),
          actionTile(Icons.music_note, 'CARGAR CANCIÓN', songPath == null ? 'Seleccioná un archivo de audio' : File(songPath!).uri.pathSegments.last, chooseSong),
          const SizedBox(height: 8),
          const Text('ESTILO MUSICAL', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: style,
            decoration: const InputDecoration(border: OutlineInputBorder(), filled: true),
            items: styles.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => style = v ?? style),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: generating ? null : createClip,
            icon: generating ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.movie_creation),
            label: Text(generating ? 'PREPARANDO...' : 'CREAR VIDEOCLIP'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
          ),
          const SizedBox(height: 18),
          Card(
            color: const Color(0xFF1B2633),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('VISTA PREVIA Y DESCARGA', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('Cuando conectemos el motor de generación, acá podrás mirar el video y descargarlo en MP4.'),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          actionTile(Icons.video_library, 'MI GALERÍA', '${gallery.length} videoclips guardados', () {
            showDialog(context: context, builder: (_) => AlertDialog(
              title: const Text('Mi galería'),
              content: Text(gallery.isEmpty ? 'Todavía no hay videoclips guardados.' : gallery.join('\n')),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
            ));
          }),
          const SizedBox(height: 12),
          const Text('Nota: esta primera versión es la estructura visual. La generación real de escenas con IA, el análisis de la letra, la vista previa y la exportación MP4 se conectarán en la siguiente etapa. Los servicios externos pueden tener límites o costos; no se promete uso ilimitado gratuito.', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
