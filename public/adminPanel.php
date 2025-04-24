<?php
// Database connection
$host = "localhost";
$user = "root";
$password = "";
$dbname = "blood_donation";

$conn = new mysqli($host, $user, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin Panel</title>
  <link rel="icon" type="image/svg" href="media/blood-svgrepo-com.svg">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<!-- NAVBAR HEADER -->

<nav class="navbar">
        <div class="container-fluid">
            <a class="navbar-brand" style="color: black !important; padding-left: 40px;" href="#">
                <img src="media/lifeblood-logo.png" class="logoimg" alt=""> Blood Bank Managment System</a>
            <div class="nabarbtns  text-light">
                <ul style="padding-inline: 40px; margin-bottom: 10px; ">
                    <li ><a href="index.html" style="text-decoration: none; color:black; font-weight: 500; font-size: 1.2rem;">Home</a></li>
                    <li ><a href="registration.html" style="text-decoration: none; color:black;font-weight: 500; font-size: 1.2rem;">Donate</a></li>
                    <li ><a href="patientregistration.html" style="text-decoration: none; color:black; font-weight: 500; font-size: 1.2rem;">Patient</a></li>
                    <li ><a href="patientregistration.html" style="text-decoration: none; color:black; font-weight: 500; font-size: 1.2rem;">Blood Requests</a></li>
          
                    <li id="signIn">
                        <button style="background-color: rgb(228, 19, 19); font-weight: 600;" type="button" class="signInButton btn btn-outline-danger" ><a href="signIn.html" style="text-decoration: none; color:white; font-weight: 500; font-size: 1.2rem;">Sign In</a></button>
                    </li>
                    <li id="Profile" style="display: none;">
                      <div  style="width: 40px; height: 40px;  display: flex;
                      align-items: end;
                      justify-content: center; border: 4px solid rgb(228, 19, 19); border-radius: 50%; font-size: 1.7rem; overflow: hidden;">
                        <i class="fa-solid fa-user" style="color: red;"></i>
                      </div>
                    </li>

                </ul>
            </div>
        </div>
      </nav>
      <div class="navbar" style="margin-left: 60px; margin-right: 60px; border-top: 2px solid rgb(228, 19, 19);"></div>


<!-- ADMIN PANEL -->
<div class="container my-5">
  <h2 class="text-center mb-4">Admin Dashboard</h2>

  <!-- Blood Requests -->
  <div class="card mb-4 shadow border-danger">
    <div class="card-header bg-danger text-white">
      <i class="fa-solid fa-droplet me-2"></i>Blood Requests
    </div>
    <div class="card-body table-responsive">
      <table class="table table-bordered">
        <thead class="table-light">
          <tr><th>#</th><th>Patient Name</th><th>Blood Group</th><th>Units</th><th>Status</th><th>Date</th></tr>
        </thead>
        <tbody>
          <?php
          $res = $conn->query("SELECT * FROM blood_request");
          while ($row = $res->fetch_assoc()) {
          ?>
            <tr>
              <td><?= $row['request_id']; ?></td>
              <td><?= $row['recipient_name']; ?></td>
              <td><?= $row['recipient_blood_group']; ?></td>
              <td><?= $row['units_required']; ?></td>
              <td><?= $row['request_status']; ?></td>
              <td><?= $row['request_date']; ?></td>
            </tr>
          <?php } ?>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Donor Details -->
  <div class="card mb-4 shadow border-danger">
    <div class="card-header bg-danger text-white">
      <i class="fa-solid fa-hand-holding-medical me-2"></i>Donors List
    </div>
    <div class="card-body table-responsive">
      <table class="table table-bordered">
        <thead class="table-light">
          
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Number</th>
          <th>Blood Group</th>
        </tr>
        
      </thead>
        <tbody>
          <?php
          $res = $conn->query("SELECT * FROM donor_details");
          while ($row = $res->fetch_assoc()) {
            echo "<tr>
              <td>{$row['donor_id']}</td>
              <td>{$row['donor_name']}</td>
            
              <td>{$row['donor_number']}</td>
              <td>{$row['donor_blood']}</td>
            </tr>";
          }
          ?>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Donor Details -->
  <div class="card mb-4 shadow border-danger">
    <div class="card-header bg-danger text-white">
      <i class="fa-solid fa-hand-holding-medical me-2"></i>Blood Invetory
    </div>
    <div class="card-body table-responsive">
      <table class="table table-bordered">
        <thead class="table-light">
          
        <tr>
          <th>Inventory ID</th>
          <th>Blood Group</th>
          <th>Units Available</th>
          <th>Minimum Threshold</th>
          <th>Last Updated</th>
          <th>Expiry Date</th>
        </tr>
        
      </thead>
        <tbody>
          <?php
          $res = $conn->query("SELECT * FROM blood_inventory");
          while ($row = $res->fetch_assoc()) {
            echo "<tr>
              <td>{$row['inventory_id']}</td>
              <td>{$row['blood_group']}</td>
              <td>{$row['units_available']}</td>
              <td>{$row['minimum_threshold']}</td>
              <td>{$row['last_updated']}</td>
              <td>{$row['expiry_date']}</td>
            </tr>";
          }
          ?>
        </tbody>
      </table>
    </div>
  </div>
</div>
</div>
<!-- Scripts -->
<script>
  const signInButton = document.getElementById('signIn');
  const profileButton = document.getElementById('Profile');
  signInButton.addEventListener('click', function () {
    signInButton.style.display = 'none';
    profileButton.style.display = 'block';
  });
</script>
<script src="app.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
