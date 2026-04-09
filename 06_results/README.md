# TravelTide — Kundensegmentierung & Rewards-Programm

**Mastery Project · Term 7**  
Analytics Team · 2025/2026

---

## Projektübersicht

TravelTide ist ein E-Booking-Startup, das ein personalisiertes Rewards-Programm einführen möchte, um die Kundenbindung zu steigern. Ziel dieses Projekts ist es, 5.782 Nutzer anhand ihres Buchungs- und Browsingverhaltens in aussagekräftige Segmente einzuteilen und jedem Segment den optimalen Perk (Programmvorteil) zuzuweisen.

**Business-Frage:** Welcher Perk motiviert welchen Kundentyp zur Anmeldung im Rewards-Programm?

---

## Ergebnisse auf einen Blick

| Segment | Nutzer | Empfohlener Perk |
|---|---|---|
| Local Eco Travelers | 1.789 | Keine Stornierungsgebühren |
| Regional Cold Travelers | 1.533 | Kostenloses Aufgabegepäck |
| Dormant Users | 836 | Exklusive Rabatte (Reaktivierung) |
| VIP | 737 | Exklusive Rabatte |
| Frequent Traveler | 396 | Kostenloses Aufgabegepäck |
| Global Frequent Travelers | 213 | 1 kostenlose Hotelnacht mit Flug |
| Tropics Lover | 139 | Kostenloses Frühstück im Hotel |
| Dreamer | 91 | Exklusive Rabatte |
| Winter Escaper | 48 | Keine Stornierungsgebühren |

---

## Projektstruktur

```
_MyMSIT_MasteryProject_Term7/
│
├── 01_data/
│   ├── raw/                        # Rohdaten (Datenbankschema-Export)
│   ├── processed/                  # Verarbeitete Zwischenergebnisse
│   │   ├── STEP1_user_features.csv
│   │   ├── STEP2und3_df_kundensegmentierung_regelbasiert.csv
│   │   └── STEP4_user_features_with_segments.csv
│   └── sql_filtered/               # Gefilterte SQL-Exporte (Kohorte)
│
├── 02_sql/
│   ├── 1_exploration/              # EDA-Abfragen
│   ├── 2_filters/                  # Kohorten-Filter
│   ├── 3_analysis/                 # Analyse-Abfragen
│   └── 4_archive/                  # Veraltete Abfragen
│
├── 03_notebooks/
│   ├── STEP 1 – EDA & Projektverständnis.ipynb
│   ├── STEP 2 und 3 - Kundensegmentierung regelbasiert.ipynb
│   └── STEP 4 - Kundensegmentierung MachineLearning.ipynb
│
├── 04_scr/                         # Python-Hilfsskripte
│
├── 05_visualizations/              # Interaktive HTML-Karten
│   ├── heatmap.html
│   ├── heatmap_weighted.html
│   └── winter_escape_heatmap.html
│
├── 06_results/                     # Finale Abgabedokumente
│   ├── TravelTide_Executive_Summary.pptx
│   ├── TravelTide_Detaillierter_Bericht.pptx
│   └── user_with_groups.csv        # Finale Nutzerzuweisung
│
├── README.md
└── requirements.txt
```

---

## Analytischer Workflow

### STEP 1 — EDA & Datenvorbereitung
- Verbindung zur PostgreSQL-Datenbank (Neon)
- Exploration aller vier Tabellen: `users`, `sessions`, `flights`, `hotels`
- Datenbereinigung: ungültige Nächte-Werte, Ausreißer-Behandlung
- Kohorten-Filter: Sessions nach 04.01.2023, mind. 7 Sessions pro Nutzer

### STEP 2 & 3 — Feature Engineering & Regelbasierte Segmentierung
- Entwicklung von 20+ Verhaltensmetriken (Reisefrequenz, Saisonalität, Klimapräferenz, Rabattverhalten, Umsatz u.a.)
- Regelbasierte Vorsegmentierung über Perzentil-Schwellenwerte
- Identifikation von 5 regelbasierten Segmenten: VIP, Frequent Traveler, Tropics Lover, Dreamer, Winter Escaper

### STEP 4 — Machine Learning (K-Means Clustering)
- MinMax-Skalierung aller Features
- K-Means-Clustering zur Validierung und Erweiterung der regelbasierten Segmente
- Identifikation von 4 ML-Clustern: Global Frequent Travelers, Dormant Users, Local Eco Travelers, Regional Cold Travelers
- Zusammenführung beider Ansätze zur finalen Segmentzuweisung (`segment_final`)

---

## Datenbank

```
Host:     ep-noisy-flower-846766.us-east-2.aws.neon.tech
DB:       TravelTide
User:     Test
SSL:      require
```

Tabellen: `users` · `sessions` · `flights` · `hotels`

---

## Installation & Nutzung

### 1. Repository klonen

```bash
git clone https://github.com/AwaTekoete/_MyMSIT_MasteryProject_Term7.git
cd _MyMSIT_MasteryProject_Term7
```

### 2. Virtuelle Umgebung erstellen

```bash
python -m venv .venv

# Windows
.venv\Scripts\activate

# macOS / Linux
source .venv/bin/activate
```

### 3. Abhängigkeiten installieren

```bash
pip install -r requirements.txt
```

### 4. Notebooks ausführen

Notebooks in der richtigen Reihenfolge ausführen:

```
03_notebooks/STEP 1 – EDA & Projektverständnis.ipynb
03_notebooks/STEP 2 und 3 - Kundensegmentierung regelbasiert.ipynb
03_notebooks/STEP 4 - Kundensegmentierung MachineLearning.ipynb
```

---

## Wichtige Erkenntnisse

- **Keine Business Traveler** in den Daten nachweisbar — zu geringe Reisefrequenz, kein Di–Do-Buchungsmuster
- **Local Eco + Regional Cold** machen 58 % der Nutzerbasis aus — größtes Aktivierungspotenzial
- **VIP-Segment** generiert überproportional hohen Umsatz (Ø € 2.651 vs. Ø € 1.245 gesamt)
- **Dormant Users** (14 %) — Reaktivierungspotenzial über Exklusivrabatte
- **Tropics Lover** planen mit 29 Tagen Vorlaufzeit am weitesten voraus

---

## Abgabedokumente

- [Executive Summary](06_results/TravelTide_Executive_Summary.pptx)
- [Detaillierter Bericht](06_results/TravelTide_Detaillierter_Bericht.pptx)
- [Finale Nutzerzuweisung (CSV)](06_results/user_with_groups.csv)

---

## Abhängigkeiten

Siehe `requirements.txt` — Hauptbibliotheken:

- `pandas` · `numpy` — Datenverarbeitung
- `scikit-learn` — K-Means Clustering, MinMax-Skalierung
- `matplotlib` · `seaborn` — Visualisierungen
- `folium` — Interaktive Karten
- `psycopg2` / `sqlalchemy` — Datenbankverbindung

---

## Autor

**Awa Tekoete**  
Mastery Project · Data Analytics · Term 7  
GitHub: [AwaTekoete](https://github.com/AwaTekoete)
