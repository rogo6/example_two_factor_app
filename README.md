# Two-Factor Authentication (Email, Sms, Authenticator App) Example with Devise-Two-Factor

## Overview

This is a sample Rails application that demonstrates the implementation of multiple two-factor authentication (2FA) methods using the `devise-two-factor` gem. Two-factor authentication adds an extra layer of security to your application by requiring users to provide a second verification step in addition to their password when logging in.

## Features

- User registration and authentication with email and password.
- Two-factor authentication using time-based one-time passwords (TOTP).
- QR code generation for TOTP setup.
## Prerequisites

Before running this application, make sure you have the following installed:

- Ruby (version 3.x recommended)
- Rails (version 7.x recommended)
## Getting Started

1. Clone this repository to your local machine:

   ```bash
   git clone <repository_url>

2. In your project directory:

    ```bash
        bundle install
        rails db:create
        rails db:migrate
        rails s