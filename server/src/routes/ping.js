function ping(req, res) {
  return res.json({ message: 'Welcome to our API!' });
}

module.exports = ping;
