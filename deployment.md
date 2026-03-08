# Backend Deployment and Development Guide

This document lists all the essential commands for developing and deploying the backend application.

## 🚀 Local Development

### Installation
```bash
npm install
```

### Run in Development mode (with nodemon)
```bash
npm run dev
```

### Run in Production mode
```bash
npm start
```

---

## 🐳 Docker Deployment

### Build the Docker Image
```bash
docker build -t mern-backend:latest .
```

### Run the Docker Container
```bash
docker run -p 5000:5000 --env-file .env mern-backend:latest
```

---

## 📜 Git Version Control

### Initialize Git
```bash
git init
```

### Status and Add Changes
```bash
git status
git add .
```

### Commit Changes
```bash
git commit -m "Your commit message"
```

---

## 🧪 Testing
Check if the server is healthy:
```bash
curl http://localhost:5000/health
```
