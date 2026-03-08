const express = require('express');
const app = express();

// Middleware
app.use(express.json());

// Health route
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'UP',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    message: 'Server is running healthily'
  });
});

// Basic route
app.get('/', (req, res) => {
  res.send('API is running...');
});

// 404 Handler
app.use((req, res) => {
  res.status(404).json({ message: 'Not Found' });
});

module.exports = app;
