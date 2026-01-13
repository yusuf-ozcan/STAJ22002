# 🚀 User Management API

![Java](https://img.shields.io/badge/Java-21_LTS-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-4.x-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-DB-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![REST API](https://img.shields.io/badge/REST-API-blue?style=for-the-badge)
![MIT License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

A **robust, scalable, and production-ready RESTful User Management API** built with the **Spring Boot ecosystem**.  
This project emphasizes **clean architecture**, **data encapsulation**, and **enterprise-level backend practices**.

---

## 🎯 Architecture & Design Patterns

This project goes beyond simple CRUD by implementing professional architectural standards:

- **Layered Architecture:** Strict separation of concerns between **Controller**, **Service**, and **Repository** layers.
- **DTO Pattern:** Decouples the database schema (Entities) from the API contract (DTOs) for enhanced security and flexibility.
- **Global Exception Handling:** Centralized error management using `@RestControllerAdvice`, ensuring consistent JSON error responses.
- **Data Validation:** Robust input validation using **Jakarta Validation** (`@Valid`, `@NotBlank`, `@Email`).



---

## ✨ Key Features

- **Full CRUD Operations:** Seamlessly Create, Read, Update, and Delete user records.
- **Advanced Pagination & Sorting:** High-performance data retrieval with Spring Data JPA `Pageable`.
- **Global Error Responses:** Custom error handling for `400 Bad Request` and `404 Not Found` scenarios.
- **Automatic Schema Management:** Database tables are managed via Hibernate with PostgreSQL integration.
- **Clean Code with Lombok:** Minimal boilerplate for better maintainability.

---

## 🛠 Tech Stack

| Technology        | Purpose                             |
|-------------------|-------------------------------------|
| **Java 21 (LTS)** | Core Programming Language           |
| **Spring Boot 4.x**| Modern Application Framework        |
| **Spring Data JPA**| Data Access & ORM (Hibernate)       |
| **PostgreSQL** | Production-grade Relational Database |
| **Validation** | Jakarta Bean Validation API         |
| **Lombok** | Boilerplate Code Reduction          |
| **Maven** | Project & Dependency Management     |

---

## 📌 API Overview

| Method | Endpoint          | Description                                  |
|:-------|:------------------|:---------------------------------------------|
| **GET**| `/api/users`      | Fetch all users (Supports Pagination/Sorting)|
| **POST**| `/api/users`     | Create a new user (with Validation)          |
| **PUT**| `/api/users/{id}` | Update an existing user                      |
| **DELETE**| `/api/users/{id}`| Remove a user from the system               |

---

## 🚀 Getting Started

### Prerequisites
- **JDK 21+**
- **PostgreSQL** (Running on port 5432)
- **Maven** 3.9+

---

## 🏗 Project Structure

```
src/main/java/com/example/user_management_api/
├── controller/   # REST Endpoints (Handling HTTP Requests)
├── service/      # Business Logic & DTO Mapping (The Core Brain)
├── repository/   # Data Access Layer (Database Communication)
├── model/        # Database Entities (JPA Models)
├── dto/          # Data Transfer Objects (API Contracts)
└── exception/    # Global Error Handling (Centralized Response Management)
```

