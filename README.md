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

# ⚙️ Automation (CI/CD)

This project uses **GitHub Actions** to fully automate the build and deployment process of the Docker container.

## 🔄 What Happens Automatically?

Every time code is pushed to the repository:

1. 📥 **Checkout Code** – The latest version of the repository is pulled.
2. 🐳 **Build Docker Image** – The Docker image is automatically built from the `Dockerfile`.
3. 🏷️ **Tag the Image** – The image is tagged with the appropriate version or `latest`.
4. 📤 **Push to Docker Registry** – The image is pushed to Docker Hub or another container registry.

This ensures consistency, repeatability, and reduces manual deployment errors. ([Docker CI/CD Docs](https://docs.docker.com/guides/r/configure-ci-cd))

---

## 🎯 Benefits of Automation

Automation in this project is implemented using **CI/CD pipelines** (GitHub Actions) to handle Docker builds and deployments. The benefits include:

- ✅ **No manual builds required**
  Every change in the repository triggers an automatic build, so you don’t have to run Docker commands manually.

- ✅ **Always up-to-date Docker image**
  The Docker image is rebuilt and pushed automatically whenever code is updated, ensuring the deployed version is current.

- ✅ **Faster deployments**
  Automated pipelines reduce the time from code change to deployment, making updates seamless and immediate.

- ✅ **Reproducible environments**
  Containerization combined with automation guarantees that the environment is consistent across development, testing, and production.

- ✅ **Production-ready workflow**
  CI/CD pipelines enforce best practices, reduce human errors, and provide a reliable, professional deployment process.

Automation ensures that every change is **tested, built, and delivered automatically**, improving efficiency, reliability, and maintainability.