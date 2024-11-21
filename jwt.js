const jsonServer = require('json-server');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');

const server = jsonServer.create();
const router = jsonServer.router('timetable.json');
const middlewares = jsonServer.defaults();

const SECRET_KEY = '328311';
const expiresIn = '1h';

// Generate JWT Token
function createToken(payload) {
  return jwt.sign(payload, SECRET_KEY, { expiresIn });
}

// Verify JWT Token
function verifyToken(token) {
  return jwt.verify(token, SECRET_KEY, (err, decode) => decode !== undefined ? decode : err);
}

// Middleware for checking authentication
server.use(bodyParser.json());
server.use(middlewares);

// Simulated user database (replace this with real database logic)
const users = [
  { username: 'admin', password: 'password123' },
  { username: 'user1', password: 'password456' },
];

// Improved login logic
server.post('/login', (req, res) => {
  const { username, password } = req.body;
  
  // Find user in the simulated database
  const user = users.find(u => u.username === username);

  if (!user) {
    return res.status(401).json({ message: 'Invalid username or password' });
  }

  // Check if password matches
  if (user.password !== password) {
    return res.status(401).json({ message: 'Invalid username or password' });
  }

  // Create JWT token
  const token = createToken({ username: user.username });
  return res.status(200).json({ token });
});

// Protect routes
server.use(/^(?!\/login).*$/, (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(403).json({ message: 'No token provided' });
  }

  const token = authHeader.split(' ')[1];

  try {
    verifyToken(token);
    next();
  } catch (err) {
    return res.status(403).json({ message: 'Invalid token' });
  }
});

server.use(router);
server.listen(3000, () => {
  console.log('JSON Server is running on port 3000');
});
