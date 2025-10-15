
import 'package:flutter/material.dart';

class LogAktifitasPage extends StatelessWidget {
	const LogAktifitasPage({super.key});

	@override
	Widget build(BuildContext context) {
		// Contoh data log
		final List<Map<String, String>> logs = [
			{
				'deskripsi': 'Mengubah iuran bulanan',
				'aktor': 'Admin',
				'tanggal': '10 Okt 2025',
			},
			{
				'deskripsi': 'Menambah data pengeluaran',
				'aktor': 'Bendahara',
				'tanggal': '11 Okt 2025',
			},
			{
				'deskripsi': 'Edit profil pengguna',
				'aktor': 'Admin',
				'tanggal': '12 Okt 2025',
			},
			{
				'deskripsi': 'Menghapus kegiatan',
				'aktor': 'Admin',
				'tanggal': '13 Okt 2025',
			},
      {
				'deskripsi': 'Menambah data user baru',
				'aktor': 'Admin',
				'tanggal': '14 Okt 2025',
			},
		];

		return Scaffold(
			appBar: AppBar(
				title: const Text('Log Aktifitas'),
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						const Text(
							'Detail Log Aktifitas',
							style: TextStyle(
								fontSize: 24,
								fontWeight: FontWeight.bold,
							),
						),
						const SizedBox(height: 16),
						Expanded(
							child: ListView.separated(
								itemCount: logs.length,
								separatorBuilder: (context, index) => const SizedBox(height: 16),
								itemBuilder: (context, index) {
									final log = logs[index];
									return Container(
										decoration: BoxDecoration(
											color: Colors.white,
											borderRadius: BorderRadius.circular(16),
											boxShadow: [
												BoxShadow(
													color: Colors.grey.withOpacity(0.1),
													blurRadius: 8,
													offset: const Offset(0, 2),
												),
											],
										),
										child: Padding(
											padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
											child: Row(
												children: [
													// No
													Container(
														width: 36,
														height: 36,
														decoration: BoxDecoration(
															color: Colors.blue.shade50,
															borderRadius: BorderRadius.circular(12),
														),
														alignment: Alignment.center,
														child: Text(
															'${index + 1}',
															style: const TextStyle(
																fontWeight: FontWeight.bold,
																color: Colors.blue,
															),
														),
													),
													const SizedBox(width: 16),
													// Deskripsi dan Aktor
													Expanded(
														child: Column(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Text(
																	log['deskripsi'] ?? '',
																	style: const TextStyle(
																		fontSize: 16,
																		fontWeight: FontWeight.bold,
																	),
																),
																const SizedBox(height: 4),
																Row(
																	children: [
																		Container(
																			padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
																			decoration: BoxDecoration(
																				color: Colors.grey.shade200,
																				borderRadius: BorderRadius.circular(8),
																			),
																			child: Text(
																				log['aktor'] ?? '',
																				style: const TextStyle(fontSize: 12, color: Colors.black54),
																			),
																		),
																		const SizedBox(width: 8),
																		Text(
																			log['tanggal'] ?? '',
																			style: const TextStyle(fontSize: 12, color: Colors.black45),
																		),
																	],
																),
															],
														),
													),
												],
											),
										),
									);
								},
							),
						),
					],
				),
			),
		);
	}
}
