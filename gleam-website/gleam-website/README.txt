Gleam Cleaning Solutions - Combined project (backend + frontend)

How to run locally:
1. Install Node.js (>=18)
2. In project root:
   npm install
3. Copy .env.example to .env and set EMAIL_PASS (Gmail app password) and other vars
4. Start the server:
   npm start
5. Open http://localhost:3000

Files:
- server.js           (Node/Express backend)
- package.json
- .env.example
- bookings.json       (data stored here)
- public/             (frontend files)
  - index.html, services.html, about.html, contact.html, blog.html, testimonials.html
  - assets/style.css
  - assets/main.js
  - assets/Blue_and_White_Simple_Cleaning_Services_Logo.png (logo)

Notes:
- Use a Gmail App Password (or SMTP credentials) for EMAIL_PASS to allow Nodemailer to send emails.
- For deployment use Render, Railway, or a VPS. Add environment variables on the platform.
