function authCheck(authRoutes, exclusions, req, res, next) {
  let rootPath = req.path.split('/')[1];
  console.log('<Request recv to ' + rootPath + '>');
  if (rootPath && authRoutes.includes(rootPath)) {
    if (rootPath in exclusions && req.method === exclusions[rootPath]) {
      next();
      return;
    }
    let token = req.headers['x-access-token'];
    if (!token) {
      return res.json({ code: -99, message: 'No token provided.' });
    }
  }
  next();
}

module.exports = authCheck;
