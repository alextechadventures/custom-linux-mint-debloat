# Custom Linux Mint Debloat

A reproducible, CLI-driven approach to transforming a default Linux Mint Cinnamon installation into a minimal, clean GUI system.

---

## 🚀 Usage

### 1. Clone the Repository

```bash
git clone https://github.com/alextechadventures/custom-linux-mint-debloat.git
cd custom-linux-mint-debloat
````

---

### 2. Run the Debloat Script

```bash
chmod +x mint-debloat.sh
./mint-debloat.sh
```

The script will:

* Load packages from `packages.conf`
* Simulate removal before execution
* Ask for confirmation
* Remove selected packages safely
* Clean unused dependencies
* Block Snap from being reinstalled

---

### 3. View the Log

After execution, review the log:

```bash
cat ~/mint-debloat.log
```

This log contains:

* Simulation output
* Removed packages
* System validation checks

---

## ⚙️ Configuration

Edit `packages.conf` to customize which packages are removed.

---

## ⚠️ Notes

* Always review the simulation step before confirming removal
* Critical system packages are protected in the script
* Designed for Linux Mint Cinnamon Edition

---

## 📘 Documentation

See `mint-debloat.md` for:

* Full debloat process
* Package decisions
* Lessons learned

````

---
