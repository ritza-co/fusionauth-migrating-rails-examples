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

The project is in the folder ruby-users-devise. It uses ruby on rails and devise for authentication and user management, based on email/password. There is a UI for login, signup and password change.

### Setup

```bash
npm run setup:devise
```

### Starting the server

Use the following command to start the server at URL: <http://localhost:3000>

```bash
npm run start:devise
```

### Export users

You can export users in a json file by running this command:

```bash
npm run export:devise
```


## OmniAuth Project

The project is in the folder ruby-users-omniauth. It uses ruby on rails and OmniAuth for authentication and user management, based on Google OAuth2 and developer fallback. There is a UI for social login and profile management.


### Setup

```bash
npm run setup:omniauth
```

### Starting the server

Use the following command to start the server at URL: <http://localhost:3001>

```bash
npm run start:omniauth
```

### Export users

You can export users in a json file by running this command:

```bash
npm run export:omniauth
```


## Rails Auth Project

The project is in the folder ruby-users-rails-auth. It uses ruby on rails and Rails 8.0 built-in authentication with `has_secure_password` for authentication and user management, based on email/password. There is a UI for login, signup, password reset and user tracking.

### Setup

```bash
npm run setup:rails-auth
```

### Starting the server

Use the following command to start the server at URL: <http://localhost:3002>

```bash
npm run start:rails-auth
```

### Export users

You can export users in a json file by running this command:

```bash
npm run export:rails-auth
```


## Test Accounts

All projects include these test accounts (password: `password123`):

- <admin@example.com>
- <user@example.com>
- <test@example.com>
- <unconfirmed@example.com>
