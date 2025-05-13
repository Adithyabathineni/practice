const express = require('express');
const app = express();
const PORT = 3000;

// Set EJS as the templating engine
app.set('view engine', 'ejs');

// Set the directory for views (optional if using default "views" folder)
app.set('views', __dirname + '/views');

// Home route
app.get('/', (req, res) => {
  res.render('home', { title: 'BAC' });
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
