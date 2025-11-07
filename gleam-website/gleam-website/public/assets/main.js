async function postData(url, data) {
  try {
    const res = await fetch(url, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify(data)
    });
    return await res.json();
  } catch (err) {
    console.error('Network error', err);
    throw err;
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const bookForm = document.getElementById('bookingForm');
  const quoteForm = document.getElementById('quoteForm');

  if (bookForm) bookForm.addEventListener('submit', async e => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(bookForm).entries());
    try {
      const res = await postData('/api/book', data);
      alert(res.message || 'Booking submitted.');
      bookForm.reset();
    } catch (err) {
      alert('Could not send booking. Please WhatsApp us at +254 704 927 950.');
    }
  });

  if (quoteForm) quoteForm.addEventListener('submit', async e => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(quoteForm).entries());
    try {
      const res = await postData('/api/quote', data);
      alert(res.message || 'Quote request submitted.');
      quoteForm.reset();
    } catch (err) {
      alert('Could not send quote request. Please WhatsApp us at +254 704 927 950.');
    }
  });

  // wire phone & WhatsApp links
  document.querySelectorAll('[data-tel]').forEach(el => el.setAttribute('href','tel:+254704927950'));
  const waHref = "https://wa.me/254704927950?text=" + encodeURIComponent("Hi Gleam Cleaning Solutions, I need a cleaning service");
  document.querySelectorAll('[data-wa]').forEach(el => el.setAttribute('href', waHref));
});
