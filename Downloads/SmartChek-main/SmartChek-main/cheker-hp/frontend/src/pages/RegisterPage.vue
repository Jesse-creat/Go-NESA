<template>
  <div class="container">
    <form @submit.prevent="handleRegister" class="form-box">
      <h2>Create an Account</h2>
      <p v-if="error" class="error-message">{{ error }}</p>
      <div class="input-group">
        <label for="username">Username</label>
        <input type="text" id="username" v-model="username" required />
      </div>
      <div class="input-group">
        <label for="password">Password</label>
        <input type="password" id="password" v-model="password" required />
      </div>
      <div class="input-group">
        <label for="role">Role</label>
        <select id="role" v-model="role">
          <option value="user">User</option>
          <option value="admin">Admin</option>
        </select>
      </div>
      <button type="submit">Register</button>
      <p class="switch-form">
        Already have an account? <router-link to="/login">Login here</router-link>
      </p>
    </form>
  </div>
</template>

<script>
export default {
  name: 'RegisterPage',
  data() {
    return {
      username: '',
      password: '',
      role: 'user',
      error: ''
    };
  },
  methods: {
    handleRegister() {
      console.log('Registering with:', this.username, this.password, this.role);
      // Di sini nanti kita panggil API backend
      // Contoh: this.error = 'Registration failed';
    }
  }
};
</script>

<style scoped>
/* Menggunakan style yang sama dengan LoginPage */
.container {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background-color: #f9fafb;
}
.form-box {
  width: 100%;
  max-width: 400px;
  padding: 2rem;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
h2 {
  text-align: center;
  font-size: 1.5rem;
  font-weight: bold;
  margin-bottom: 1rem;
}
.input-group {
  margin-bottom: 1.5rem;
}
label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}
input, select {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #d1d5db;
  border-radius: 4px;
}
button {
  width: 100%;
  padding: 0.75rem;
  border: none;
  border-radius: 4px;
  background-color: #4f46e5;
  color: white;
  font-size: 1rem;
  cursor: pointer;
}
.error-message {
  color: #ef4444;
  background-color: #fee2e2;
  padding: 0.75rem;
  border-radius: 4px;
  margin-bottom: 1rem;
}
.switch-form {
  text-align: center;
  margin-top: 1.5rem;
}
.switch-form a {
  color: #4f46e5;
  text-decoration: none;
}
</style>
