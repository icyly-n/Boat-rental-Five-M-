# Boat-rental-Five-M-

# 🚤 Boat Rental System - QBCore

## 📌 Description

A fully functional boat rental system for FiveM servers using QBCore.
Players can rent boats from an NPC, use them for a limited time, and return them for a partial refund.

---

## ✨ Features

* 🤖 NPC with animation (clipboard scenario)
* 🗺️ Map blip for rental location
* 📋 Interactive menu using qb-menu
* 🚤 Multiple boat options with different prices & durations
* ⏳ Rental timer system (auto delete when time ends)
* 🔁 Return system with partial refund
* 🔒 Prevent multiple rentals
* 🎯 qb-target interaction for NPC and boat

---

## 📦 Requirements

* qb-core
* qb-target
* qb-menu

---

## 📥 Installation

1. Download the script
2. Place it in your `resources` folder
3. Add this to your `server.cfg`:

```id="boat123"
ensure boat_rental
```

---

## ⚙️ Configuration

You can edit everything from the client file:

### 📍 NPC Location

```id="npc456"
local coords = vector4(-1605.27, 5258.55, 2.08, 217.69)
```

### 🚤 Boats List

```id="boats789"
local boats = {
    {label = "قارب صغير", model = "dinghy", price = 1500, time = 10},
    {label = "قارب سريع", model = "jetmax", price = 3000, time = 10},
    {label = "يخت صغير", model = "suntrap", price = 5000, time = 15},
}
```

---

## 🎮 How It Works

1. Go to the rental NPC 📍
2. Open the menu
3. Choose a boat
4. Pay and receive your boat 🚤
5. Use it within the rental time
6. Return it to get a refund 💰

---

## ⏳ Rental System

* Each boat has a time limit (minutes)
* When time expires, the boat is automatically removed
* No refund if time runs out

---

## 🔁 Refund System

* Refund depends on how much time is left
* The earlier you return → the more money you get back

---

## 📷 Preview

(Add screenshots or video here)

---

## 🧠 Notes

* Player can only rent one boat at a time
* Boat plate is set to: `RENT`
* Uses server-side validation for refunds

---

## 🔧 Future Improvements

* Add multiple rental locations
* Add boat damage system
* Add fuel system integration

---

## 🤝 Credits

Developed by [Your Name]

---

## 📜 License

Free to use. Do not resell.

