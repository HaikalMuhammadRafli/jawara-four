import 'package:flutter/material.dart';

import '../models/pengguna_model.dart';

const List<Pengguna> penggunaMock = [
  Pengguna(
    no: 1,
    nama: 'Kania Talitha',
    email: 'kania.talitha@email.com',
    role: 'Admin',
    icon: Icons.person,
    color: Colors.blue,
  ),
  Pengguna(
    no: 2,
    nama: 'Siti Aminah',
    email: 'siti.aminah@email.com',
    role: 'Bendahara',
    icon: Icons.person_outline,
    color: Colors.green,
  ),
  Pengguna(
    no: 3,
    nama: 'Budi Santoso',
    email: 'budi.santoso@email.com',
    role: 'Warga',
    icon: Icons.person_2,
    color: Colors.orange,
  ),
];

