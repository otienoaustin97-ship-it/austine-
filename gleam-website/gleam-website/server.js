\
require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');
const fs = require('fs');
const path = require('path');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
app.use(helmet());
app.use(cors());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

const BOOKINGS_FILE = path.join(__dirname, 'bookings.json');
if (!fs.existsSync(BOOKINGS_FILE)) fs.writeFileSync(BOOKINGS_FILE, JSON.stringify([]));

const transporter = nodemailer.createTransport({
  host: process.env.EMAIL_HOST,
  port: parseInt(process.env.EMAIL_PORT || '587', 10),
  secure: (process.env.EMAIL_SECURE === 'true'),
  auth: { user: process.env.EMAIL_USER, pass: process.env.EMAIL_PASS }
});

transporter.verify()
  .then(() => console.log('Mail transporter ready'))
  .catch(err => console.warn('Mail transporter verification warning:', err.message || err));

function saveRecord(record) {
  const arr = JSON.parse(fs.readFileSync(BOOKINGS_FILE, 'utf8') || '[]');
  arr.push(record);
  fs.writeFileSync(BOOKINGS_FILE, JSON.stringify(arr, null, 2));
}

async function sendMail(to, subject, html) {
  const mailOptions = {
    from: `"Gleam Cleaning Solutions" <${process.env.EMAIL_USER}>`,
    to,
    subject,
    html
  };
  return transporter.sendMail(mailOptions);
}

async function notifyAdminAndClient({ record, subjectAdmin, htmlAdmin, subjectClient, htmlClient }) {
  const adminEmail = process.env.ADMIN_EMAIL || process.env.EMAIL_USER;

  try {
    await sendMail(adminEmail, subjectAdmin, htmlAdmin);
  } catch (err) {
    console.warn('Failed sending admin email:', err.message || err);
  }

  if (record.email && record.email.includes('@')) {
    try {
      await sendMail(record.email, subjectClient, htmlClient);
    } catch (err) {
      console.warn('Failed sending client confirmation email:', err.message || err);
    }
  }
}

app.post('/api/book', async (req, res) => {
  try {
    const { name, phone, email, service, date, address, notes } = req.body || {};
    if (!name || !phone || !service || !address) {
      return res.status(400).json({ ok: false, message: 'Missing required fields (name, phone, service, address).' });
    }

    const record = {
      type: 'booking',
      name: String(name).trim(),
      phone: String(phone).trim(),
      email: email ? String(email).trim() : '',
      service: String(service).trim(),
      date: date ? String(date).trim() : '',
      address: String(address).trim(),
      notes: notes ? String(notes).trim() : '',
      createdAt: new Date().toISOString()
    };

    saveRecord(record);

    const htmlAdmin = `
      <h2>New Booking Request — Gleam Cleaning Solutions</h2>
      <p><strong>Service:</strong> ${record.service}</p>
      <p><strong>Name:</strong> ${record.name}</p>
      <p><strong>Phone:</strong> ${record.phone}</p>
      <p><strong>Email:</strong> ${record.email || '(none)'}</p>
      <p><strong>Preferred date:</strong> ${record.date || '(none)'}</p>
      <p><strong>Address:</strong> ${record.address}</p>
      <p><strong>Notes:</strong><br/> ${record.notes || '(none)'}</p>
      <p>Received: ${record.createdAt}</p>
    `;

    const htmlClient = `
      <div style="font-family:Arial,Helvetica,sans-serif;color:#0b2b3a">
        <h3>Thanks for your booking request — Gleam Cleaning Solutions</h3>
        <p>Hi ${record.name},</p>
        <p>Thanks for requesting <strong>${record.service}</strong>. We received your request and will contact you shortly to confirm the booking.</p>
        <ul>
          <li><strong>Phone:</strong> ${record.phone}</li>
          <li><strong>Email:</strong> ${record.email || '(none provided)'}</li>
          <li><strong>Preferred date:</strong> ${record.date || '(none)'}</li>
          <li><strong>Address:</strong> ${record.address}</li>
        </ul>
        <p>Notes: ${record.notes || '(none)'}</p>
        <p>If you need immediate help, call or WhatsApp us at <a href="tel:+254704927950">+254 704 927 950</a>.</p>
        <p>— Gleam Cleaning Solutions</p>
      </div>
    `;

    notifyAdminAndClient({
      record,
      subjectAdmin: `Booking request — ${record.service} — ${record.name}`,
      htmlAdmin,
      subjectClient: `Gleam: Booking confirmation — ${record.service}`,
      htmlClient
    }).catch(err => console.warn('notify error', err));

    return res.json({ ok: true, message: 'Booking received. We will contact you shortly.' });
  } catch (err) {
    console.error('Error /api/book', err);
    return res.status(500).json({ ok: false, message: 'Server error' });
  }
});

app.post('/api/quote', async (req, res) => {
  try {
    const { name, phone, email, service, quantity, address, notes } = req.body || {};
    if (!name || !phone || !email || !address) {
      return res.status(400).json({ ok: false, message: 'Missing required fields (name, phone, email, address).' });
    }

    const record = {
      type: 'quote',
      name: String(name).trim(),
      phone: String(phone).trim(),
      email: String(email).trim(),
      service: service ? String(service).trim() : '',
      quantity: quantity ? String(quantity).trim() : '',
      address: String(address).trim(),
      notes: notes ? String(notes).trim() : '',
      createdAt: new Date().toISOString()
    };

    saveRecord(record);

    const htmlAdmin = `
      <h2>New Quote Request — Gleam Cleaning Solutions</h2>
      <p><strong>Service:</strong> ${record.service || '(unspecified)'}</p>
      <p><strong>Quantity/Area:</strong> ${record.quantity || '(unspecified)'}</p>
      <p><strong>Name:</strong> ${record.name}</p>
      <p><strong>Phone:</strong> ${record.phone}</p>
      <p><strong>Email:</strong> ${record.email}</p>
      <p><strong>Address:</strong> ${record.address}</p>
      <p><strong>Notes:</strong><br/> ${record.notes || '(none)'}</p>
      <p>Received: ${record.createdAt}</p>
    `;

    const htmlClient = `
      <div style="font-family:Arial,Helvetica,sans-serif;color:#0b2b3a">
        <h3>Quote request received — Gleam Cleaning Solutions</h3>
        <p>Hi ${record.name},</p>
        <p>Thank you for requesting a quote for <strong>${record.service || 'cleaning services'}</strong>. We will review your details and email you a quote shortly.</p>
        <ul>
          <li><strong>Phone:</strong> ${record.phone}</li>
          <li><strong>Email:</strong> ${record.email}</li>
          <li><strong>Quantity/Area:</strong> ${record.quantity || '(not specified)'}</li>
          <li><strong>Address:</strong> ${record.address}</li>
        </ul>
        <p>Notes: ${record.notes || '(none)'}</p>
        <p>If this is urgent, contact us on WhatsApp: <a href="https://wa.me/254704927950">+254 704 927 950</a>.</p>
        <p>— Gleam Cleaning Solutions</p>
      </div>
    `;

    notifyAdminAndClient({
      record,
      subjectAdmin: `Quote request — ${record.service || 'General'} — ${record.name}`,
      htmlAdmin,
      subjectClient: `Gleam: Quote request received`,
      htmlClient
    }).catch(err => console.warn('notify error', err));

    return res.json({ ok: true, message: 'Quote request received. We will email you shortly.' });
  } catch (err) {
    console.error('Error /api/quote', err);
    return res.status(500).json({ ok: false, message: 'Server error' });
  }
});

app.get('/health', (req, res) => res.json({ ok: true, time: new Date().toISOString() }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Gleam backend running on port ${PORT}`));
