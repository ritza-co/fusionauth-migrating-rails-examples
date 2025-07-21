# FusionAuth Migration Guide - Rails Authentication Examples

This repository contains three Rails applications demonstrating different authentication approaches and how to export user data.

## Prerequisites

- Ruby 3.3.0+
- Rails 8.0.2+
- Node.js v22.13.0
- npm 10.9.2
- SQLite3
- Docker

## Setup

Install npm dependencies to run the project commands:

```bash
npm install
```

To import a user, you need to start the FusionAuth application. Use the following command:

```bash
docker compose up -d --build
```

Once the application is running, you can access the FusionAuth instance at: <http://localhost:9011>

## Devise Project

The project is located at ruby-users-devise. It uses ruby on rails. devise for authentication and user management, based on email/password. There is an UI for login, signup and password change.

### Export users

You can export users in a json file running this command:

```bash
npm run export:devise
```

### Starting the server

Use the following command to start the server at URL: <http://localhost:3000>

```bash
npm run start:devise
```

### Commands

```bash
# Setup
npm run setup:devise

# Run tests
npm run test:devise
```

## OmniAuth Project

The project is located at ruby-users-omniauth. It uses ruby on rails. OmniAuth for authentication and user management, based on Google OAuth2 and developer fallback. There is an UI for social login and profile management.

### Export users

You can export users in a json file running this command:

```bash
npm run export:omniauth
```

### Starting the server

Use the following command to start the server at URL: <http://localhost:3001>

```bash
npm run start:omniauth
```

### Commands

```bash
# Setup
npm run setup:omniauth

# Run tests
npm run test:omniauth
```

## Rails Auth Project

The project is located at ruby-users-rails-auth. It uses ruby on rails. Rails 8.0 built-in authentication with has_secure_password for authentication and user management, based on email/password. There is an UI for login, signup, password reset and user tracking.

### Export users

You can export users in a json file running this command:

```bash
npm run export:rails-auth
```

### Starting the server

Use the following command to start the server at URL: <http://localhost:3002>

```bash
npm run start:rails-auth
```

### Commands

```bash
# Setup
npm run setup:rails-auth

# Run tests
npm run test:rails-auth
```

## Test Accounts

All projects include these test accounts (password: `password123`):

- <admin@example.com>
- <user@example.com>
- <test@example.com>
- <unconfirmed@example.com>
