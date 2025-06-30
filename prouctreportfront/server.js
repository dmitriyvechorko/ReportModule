const express = require('express');
const path = require('path');
const app = express();
const PORT = 3000;

// Раздача статики из папки public
app.use(express.static(path.join(__dirname, 'public')));

console.log(`Server is running on http://localhost:${PORT}`);
app.listen(PORT);