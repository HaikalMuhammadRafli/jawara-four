# Dashboard Widgets

Modular widgets untuk dashboard yang telah dipisah untuk kemudahan maintenance dan reusability.

## Struktur File

```
lib/widgets/dashboard/
├── dashboard_widgets.dart          # Export file untuk semua dashboard widgets
├── welcome_section.dart            # Welcome section dengan gradient header
├── summary_cards_section.dart      # Summary cards (Finance, Demographics, Activities)
├── charts_section.dart             # Charts section (Financial & Demographics charts)
├── recent_activities_section.dart  # Recent activities (Transactions, Events, Changes)
└── README.md                       # Dokumentasi ini
```

## Widget Components

### 1. WelcomeSection
- **File**: `welcome_section.dart`
- **Deskripsi**: Header section dengan gradient background dan welcome message
- **Props**: Tidak ada

### 2. SummaryCardsSection
- **File**: `summary_cards_section.dart`
- **Deskripsi**: Section untuk menampilkan 3 kartu summary utama
- **Props**:
  - `isTablet: bool` - Untuk responsive layout tablet
  - `isDesktop: bool` - Untuk responsive layout desktop

#### Sub-components:
- `FinanceCard` - Kartu untuk data keuangan
- `DemographicsCard` - Kartu untuk data kependudukan
- `ActivitiesCard` - Kartu untuk data kegiatan

### 3. ChartsSection
- **File**: `charts_section.dart`
- **Deskripsi**: Section untuk grafik dan visualisasi data
- **Props**:
  - `isTablet: bool` - Untuk responsive layout tablet
  - `isDesktop: bool` - Untuk responsive layout desktop

#### Sub-components:
- `FinancialChart` - Line chart untuk data keuangan bulanan
- `DemographicsChart` - Pie chart untuk komposisi warga

### 4. RecentActivitiesSection
- **File**: `recent_activities_section.dart`
- **Deskripsi**: Section untuk aktivitas terbaru dalam 3 kategori
- **Props**:
  - `isTablet: bool` - Untuk responsive layout tablet
  - `isDesktop: bool` - Untuk responsive layout desktop

#### Sub-components:
- `TransactionCard` - Kartu untuk transaksi keuangan terbaru
- `RecentActivitiesCard` - Kartu untuk kegiatan terbaru
- `DemographicsChangesCard` - Kartu untuk perubahan data kependudukan

## Responsive Design

Semua section mendukung responsive design dengan breakpoint:
- **Mobile**: < 768px (single column layout)
- **Tablet**: 768px - 1024px (2 column layout)
- **Desktop**: > 1024px (3 column layout)

## Usage

```dart
import '../widgets/dashboard/dashboard_widgets.dart';

// Atau import individual widgets
import '../widgets/dashboard/welcome_section.dart';
import '../widgets/dashboard/summary_cards_section.dart';
import '../widgets/dashboard/charts_section.dart';
import '../widgets/dashboard/recent_activities_section.dart';
```

## Benefits of Modularization

1. **Maintainability**: Setiap widget memiliki tanggung jawab yang jelas
2. **Reusability**: Widget dapat digunakan di tempat lain jika diperlukan
3. **Testability**: Setiap widget dapat di-test secara independen
4. **Code Organization**: Kode lebih terorganisir dan mudah dibaca
5. **Team Collaboration**: Tim dapat bekerja pada widget yang berbeda secara paralel

## File Size Reduction

- **Sebelum**: `dashboard_page.dart` ~1300+ lines
- **Sesudah**: `dashboard_page.dart` ~50 lines
- **Total**: Terdistribusi ke 4 file widget yang lebih kecil dan fokus
