# Frontend Pages Specification (Phase 1)

This document describes the frontend pages included in Phase 1 of the Forum Project,


---

## General Rules & Assumptions

### 1. Gateway as Single Entry Point
- Frontend **only communicates with the Gateway** (`http://localhost:8080`)
- Frontend does **NOT** call individual services directly

### 2. Authentication
- Authentication is based on **JWT**
- JWT is returned by auth-related APIs
- Frontend sends JWT via HTTP header:

---

## Pages Overview

Phase 1 includes the following pages:

- Login Page
- Register Page
- User Profile Page
- Home Page

All pages communicate with backend services **only through the Gateway**.

---

## Login Page

### Page Purpose
Allow existing users to authenticate and access the system.

### UI Elements (Frontend State)
- email (string)
- password (string)
- errorMessage (string, optional)
- isLoading (boolean)

### User Actions
- User enters email and password
- User submits the login form
- On success, redirect to Home Page
- On failure, display error message

### API Dependencies
- POST `/auth/login`

**Expected Behavior**
- Success:
  - Receive JWT token
  - Receive basic user information
  - Frontend stores token and updates login state
- Failure:
  - Invalid credentials
  - User not found

---

## Register Page

### Page Purpose
Allow new users to create an account.

### UI Elements (Frontend State)
- username (string)
- email (string)
- password (string)
- confirmPassword (string)
- errorMessage (string, optional)
- isLoading (boolean)

### User Actions
- User fills in registration form
- User submits registration request
- On success:
  - Redirect to Login Page, or
  - Auto-login (to be confirmed)
- On failure:
  - Display validation or server error

### API Dependencies
- POST `/auth/register`

**Open Question**
- Should this endpoint return a JWT to support auto-login after registration?

---

## User Profile Page

### Page Purpose
Display the authenticated user’s profile information.

### UI Elements (Frontend State)
- username (string)
- email (string)
- avatarUrl (string)
- createdAt (string)

### User Actions
- User views profile information

### API Dependencies
- GET `/user/me`

**Notes**
- Used to restore login state on page refresh
- Phase 1 is read-only (no profile editing)

---

## Home Page

### Page Purpose
Serve as the main landing page after login, displaying a list of posts.

### UI Elements (Frontend State)
- posts (array)
- pagination information
- isLoading (boolean)

### User Actions
- User views list of posts
- User navigates pagination
- User clicks a post to view details (Phase 2)

### API Dependencies
- GET `/posts`

**Notes**
- Pagination strategy may evolve
- Post response shape can be extended in Phase 2

---

## Future Pages (Out of Phase 1 Scope)

The following pages are planned but not included in Phase 1:

- Post Detail Page
- Create Post Page
- Reply / Comment Page
- Admin / Moderation Pages

These will be documented in later phases following the same structure.
