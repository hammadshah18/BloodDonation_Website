
# 🩸 Blood Donation Management System

Welcome to the **Blood Donation Management System** — a web-based application designed to efficiently manage blood donations, donor profiles, hospital requests, health screenings, and inventory control.

This system streamlines operations for blood banks and hospitals, ensuring faster donor matching, better emergency handling, and transparent record-keeping.

---

## ⚙️ Features

### 👤 Donor & User Management
- Register new donors with health screening.
- Validate donor eligibility based on age, gender, donation history, and health data.
- Role-based access (Admin, Donor, Hospital Staff).

### 🧪 Health & Eligibility Check
- Donor screening with weight, blood pressure, pulse rate.
- Auto-verification before allowing donations.

### 🩸 Blood Inventory
- Track blood stock by type and quantity.
- Auto-update on donation or request fulfillment.

### 🚨 Emergency Requests
- Hospitals/admins can raise urgent blood requests.
- System matches and notifies eligible donors.

### 🔁 Referral & Events
- Donors can refer others via referral codes.
- Schedule donation events with time, location, and capacity.

### 📊 Logs, History & Feedback
- Track request history and donation logs.
- Store donor feedback, manage notifications.

### 🔒 Validations & Logic
- Stored procedures handle:
  - Login/authentication
  - Donation approval
  - Inventory updates
  - Request rejection reasons
- Triggers log changes and maintain consistency.

---

## 💻 How It Works

1. **Database Setup**
   - Import the provided SQL file into MySQL (via phpMyAdmin or CLI).
   - Includes 14+ normalized tables and logic-based stored procedures.

2. **Run Web Application**
   - Launch using XAMPP or any LAMP stack.
   - Place the project folder in `htdocs/` directory.
   - Start Apache & MySQL services.

3. **Access System**
   - Open `http://localhost/BloodDonation_Website` in your browser.

---

## 🛠 Tech Stack

| Component      | Technology          |
|----------------|---------------------|
| Frontend       | HTML, CSS, JS       |
| Backend        | PHP                 |
| Database       | MySQL               |
| Tools Used     | XAMPP / phpMyAdmin  |

---

## 🧠 SQL Logic Overview

Developed by **Muhammad Hammad**, the SQL layer includes:

- **Tables:** `users`, `donors`, `roles`, `blood_inventory`, `emergency_requests`, `donation_events`, `health_screening`, etc.
- **Stored Procedures:** Handle login validation, donor eligibility, inventory control, and request processing.
- **Triggers:** Log donation activities and inventory changes.
- **Views & Constraints:** Ensure normalized and relational structure.

Sample Procedure:
```sql
CREATE PROCEDURE CheckDonorEligibility(IN donor_id INT)
BEGIN
  -- Validate age, last donation date, etc.
  -- Return eligibility status with message
END;
````

---

## 📦 Sample SQL Tables

* `users (user_id, name, email, role_id)`
* `donors (donor_id, user_id, blood_type, last_donation_date)`
* `blood_inventory (blood_id, blood_type, quantity)`
* `emergency_requests (request_id, hospital_id, blood_type, status)`
* `request_history (log_id, request_id, action, timestamp)`

---

## 📌 Future Enhancements

* Add email/SMS notifications (integration via app layer).
* Build admin analytics dashboard (donation trends, request heatmap).
* Enable RESTful API for mobile integration.
* Develop secure login with hashed passwords & token system.

---

## 🔒 License

This project is open-source and available under the [MIT License](LICENSE).

---

## 🙌 Contributors

* **Muhammad Hammad** – *SQL Developer, Schema Designer, Logic Architect*
* **\[Aitzaz Hassan]** – *Frontend & PHP Developer*

---

## 📬 Contact

For feedback or queries:

**Muhammad Hammad**
📧 [hammadshah7218@gmail.com](mailto:hammadshah7218@gmail.com)
📱 0304-2812430
🎓 Mehran University of Engineering & Technology, Jamshoro



```
