
import React from 'react';
import { useNavigate } from 'react-router-dom';

const Navbar = () => {
  const navigate = useNavigate();
  const handleLogout = () => {
    // Clear user session/token if any
    navigate('/login');
  };

  return (
    <nav className="navbar">
      <div className="navbar-brand">Admin Dashboard</div>
      <button onClick={handleLogout} className="navbar-logout">Logout</button>
    </nav>
  );
};

const AdminDashboard = () => {
  return (
    <div>
      <Navbar />
      <div className="home-container">
        <h1>Selamat Datang, Admin!</h1>
        <p>Ini adalah halaman dashboard Anda. Di sini Anda dapat mengelola pengguna dan produk.</p>
        {/* Konten dashboard admin akan ditambahkan di sini */}
      </div>
    </div>
  );
};

export default AdminDashboard;
