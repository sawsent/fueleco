# 🛠️ fueleco — Command-Line Fuel Economy Tracker

**fueleco** is a simple, shell-based fuel economy tracking tool.  
It helps you record refueling data, calculate your vehicle’s fuel efficiency, and analyze spending — all directly from the terminal.

---

## 📦 Features

- Track multiple **vehicle profiles**
- Record refueling data (liters, km, prices, etc.)
- Compute **fuel economy** in L/100km and mpg
- View **aggregate stats** (average consumption, cost per km)
- Display formatted tables of your refueling history
- Manage profiles (list, switch, delete)

---

## ⚙️ Setup

### Usage
The tool is executed as:
```bash
fueleco <command> [options]
```

---

## 🚗 Commands Overview

### 🔹 `calc`
Calculate fuel economy manually.

```bash
fueleco calc -l=<liters> -km=<kilometers>
```

**Example:**
```bash
fueleco calc -l=45 -km=600
# Output: Fuel Economy: 7.5 L/100km // 31.4 mpg
```

---

### 🔹 `use`
Select or create a profile for data tracking.

```bash
fueleco use <profile_name>
```

**Example:**
```bash
fueleco use mycar
# Output: Profile mycar is now active.
```

---

### 🔹 `add`
Add a new fuel log entry for the current profile.

```bash
fueleco add -l=<liters> -km=<kilometers> [-p=<total_price>] [-pl=<price_per_liter>] [-date=<YYYY/MM/DD>]
```

**Examples:**
```bash
fueleco add -l=42 -km=580 -pl=1.85
fueleco add -l=40 -km=500 -p=74 -date=2025/11/12
```

Automatically records date if none is provided.

---

### 🔹 `stats`
View profile statistics.

```bash
fueleco stats
```

**Displays:**
```
Showing stats for profile: mycar
------------------------------------
KM travelled | 5120
Liters used  | 420
Avg LPKM     | 8.2
Avg EUR/km   | 0.12
```

---

### 🔹 `show`
Display all entries in a formatted table.

```bash
fueleco show
```

**Example Output:**
```
DATE        KM     LITERS  PRICE  PRICE/L  L/100KM
2025/11/01  600    42      77.7   1.85     7.0
2025/11/12  580    41      75.0   1.83     7.1
```

---

### 🔹 `profile`
Show the currently active profile.

```bash
fueleco profile
# Output: Active profile: mycar
```

---

### 🔹 `profiles`
List all existing profiles and indicate which one is active.

```bash
fueleco profiles
```

**Example Output:**
```
Profiles:
[X] mycar
[ ] truck
[ ] bike
```

---

### 🔹 `delete-profile`
Delete a stored profile and its data.

```bash
fueleco delete-profile <profile_name>
```

**Example:**
```bash
fueleco delete-profile mycar
# Output: Profile mycar deleted.
```

---

## 🧩 Options Summary

| Option | Description |
|:-------|:-------------|
| `-l=` | Liters refueled |
| `-km=` | Distance traveled |
| `-p=` | Total price paid |
| `-pl=` | Price per liter |
| `-date=` | Custom date (YYYY/MM/DD) |
| `-profile=` | Specify a profile inline |
| `--debug` | Enable verbose debug logging |

---

## 🗂️ Data Storage

Each profile’s data is stored as a CSV file under:
```
$DATA_LOCATION/<profile>.csv
```

Format:
```
DATE,KM,LITERS,PRICE,PRICE_PER_LITER
```

---

## 🧠 Example Workflow

```bash
fueleco use mycar
fueleco add -l=40 -km=500 -p=72.5
fueleco add -l=38 -km=470 -pl=1.84
fueleco stats
fueleco show
```

---

## 🪵 Debug Mode

To enable detailed debug output:
```bash
fueleco calc -l=50 -km=700 --debug
```

Logs messages from various modules (e.g., `FUELECO`, `FUELECO:STATS`).

---

**Created with ❤️ in Bash**
