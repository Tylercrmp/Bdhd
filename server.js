// Auto-generated server.js for production -> serves build output from /dist or static files
const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 8080;

// Static folder — prefer dist (Vite build), fallback to public or root
const distPath = path.join(__dirname, 'dist');
const publicPath = path.join(__dirname, 'public');
const staticRoot = require('fs').existsSync(distPath) ? distPath : (require('fs').existsSync(publicPath) ? publicPath : __dirname);

app.use(express.static(staticRoot));

// Single page app fallback
app.get('*', (req, res) => {
  const indexFile = path.join(staticRoot, 'index.html');
  if (require('fs').existsSync(indexFile)) {
    res.sendFile(indexFile);
  } else if (req.path === '/' || req.path === '/index.html') {
    res.send('<h2>Index file not found.</h2><p>Build the project (npm run build) to generate the frontend into /dist.</p>');
  } else {
    res.status(404).send('Not found');
  }
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT} (static root: ${staticRoot})`);
});
