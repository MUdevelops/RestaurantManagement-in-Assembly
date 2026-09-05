# 🍽️ Restaurant Management System — 8086 Assembly

A console-based **Restaurant Management System** built entirely in **8086 Assembly Language**, developed and tested in the **emu8086 Microprocessor Emulator**. The system displays a restaurant menu, takes customer orders (item + quantity), tracks a running total, and generates an itemized bill on checkout.

---

## ✨ Features

- 📋 Interactive on-screen menu with item names and prices
- 🔢 Order multiple items with custom quantities in a single session
- ➕ Real-time running total calculation
- 🧾 Itemized final bill showing each ordered item, quantity, and subtotal
- ⚠️ Basic input validation for invalid menu choices
- 🖥️ Runs entirely on emu8086 — no external dependencies

---

## 🛠️ Tech Stack

| Component        | Details                        |
|-------------------|---------------------------------|
| Language          | 8086 Assembly (MASM/TASM style) |
| Emulator/IDE      | [emu8086](http://www.emu8086.com/) |
| Interrupts Used   | `INT 21h`, `INT 10h`            |

---

## 📂 Project Structure

```
Assembly Project/
├── Project.asm          # Main source code
├── LICENSE
├── README.md
└── Screenshots/
    ├── Program.png      # Menu interface
    ├── Code.png         # Source code preview
    └── End Message.png  # Final bill / exit screen
```

---

## 🚀 Getting Started

1. Download and install **[emu8086](http://www.emu8086.com/)**.
2. Clone this repository:
   ```bash
   git clone https://github.com/MUdevelops/RestaurantManagement-in-Assembly.git
   ```
3. Open **`Project.asm`** in emu8086.
4. Click **Compile**, then **Emulate/Run**.
5. Follow the on-screen menu to place an order and generate your bill.

---

## 📸 Screenshots

### 🖥️ Program in Action
The main menu where users select items and enter quantities.

![Program Screenshot](Screenshots/Program.png)

### 💻 Source Code
A preview of the assembly source code inside the emu8086 editor.

![Code Screenshot](Screenshots/Code.png)

### 🧾 Final Bill / Exit Message
The itemized bill and thank-you message shown at checkout.

![End Message Screenshot](Screenshots/End%20Message.png)

---

## 📄 License

This project is licensed under the terms of the [LICENSE](./LICENSE) file included in this repository.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to fork the repo and submit a pull request.

---

## 👤 Author

**MUdevelops**
