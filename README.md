# 📄 Ahmed Elarosi – CV as a Docker Container

This project provides a fully containerized version of my CV, allowing it to be easily deployed, shared, and run anywhere using Docker.

## 📌 Overview
Instead of a traditional PDF resume, this project demonstrates a modern approach:

- 📦 Packaged as a Docker container
- 🌐 Accessible via browser
- ⚙️ Automatically built and deployed using CI/CD

This reflects real-world DevOps practices and showcases my experience in:
- Docker
- CI/CD pipelines
- Cloud-ready applications

The container serves a simple web interface where my CV can be accessed in:
- 🇬🇧 English
- 🇩🇪 German

---
## 🚀 Quick Start
**Pull the image:**
```
docker pull ahmedelarosi/ahmed-elarosi-cv:1.0.2
```
**Run the container:**
```
docker run -p 8080:8080 ahmedelarosi/ahmed-elarosi-cv:1.0.2
```
**Open in your browser:** http://localhost:8080

---