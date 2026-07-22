# API Documentation

## Base URL
`http://localhost:8000/api/v1`

## Authentication

### 1. Login
- **Endpoint**: `POST /login`
- **Body**:
  ```json
  {
      "email": "owner@beautypos.com",
      "password": "password"
  }
  ```
- **Response**:
  ```json
  {
      "status": "success",
      "message": "Login berhasil",
      "data": {
          "user": { ... },
          "token": "1|..."
      }
  }
  ```

### 2. Get Current User (Me)
- **Endpoint**: `GET /me`
- **Headers**:
  - `Authorization: Bearer {token}`
- **Response**:
  ```json
  {
      "status": "success",
      "data": { ... }
  }
  ```

### 3. Change Password
- **Endpoint**: `POST /change-password`
- **Headers**:
  - `Authorization: Bearer {token}`
- **Body**:
  ```json
  {
      "current_password": "password",
      "new_password": "newpassword123",
      "new_password_confirmation": "newpassword123"
  }
  ```
- **Response**:
  ```json
  {
      "status": "success",
      "message": "Password berhasil diubah"
  }
  ```

### 4. Logout
- **Endpoint**: `POST /logout`
- **Headers**:
  - `Authorization: Bearer {token}`
- **Response**:
  ```json
  {
      "status": "success",
      "message": "Logout berhasil"
  }
  ```

## Users (Requires `manage_users` permission)

### 1. Get All Users
- **Endpoint**: `GET /users`
- **Headers**:
  - `Authorization: Bearer {token}`
- **Response**:
  ```json
  {
      "status": "success",
      "data": [ ... ]
  }
  ```
