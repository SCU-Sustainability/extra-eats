const expect = require('chai').expect;
const authCheck = require('../../routes/middle/auth-check');

let req = {
  headers: {
    'x-access-token': 'test'
  },
  body: {},
  path: 'api/users',
  method: 'GET'
};

let req2 = {
  headers: {},
  body: {},
  path: 'api/users',
  method: 'GET'
};

let req3 = {
  headers: {},
  body: {},
  path: 'api/users',
  method: 'POST'
};

let res = {
  code: null,
  json: function(arg) {
    this.code = arg.code;
  }
};

const authRoutes = ['users'];
const exclusions = {
  users: 'POST'
};

describe('Auth check middleware', function() {
  describe('Auth check with token', function() {
    it('Should call next()', function() {
      let next = false;
      authCheck(authRoutes, exclusions, req, res, () => {
        next = true;
      });
      expect(next).to.equal(true);
    });
  });
  describe('Auth check without token', function() {
    next = false;
    it('Should return code -99', function() {
      authCheck(authRoutes, exclusions, req2, res, () => {
        next = true;
      });
      expect(res.code).to.equal(-99);
    });
    it('Should not call next()', function() {
      expect(next).to.equal(false);
    });
  });
  describe('Auth check without token to exclusion', function() {
    it('Should call next()', function() {
      let next = false;
      authCheck(authRoutes, exclusions, req, res, () => {
        next = true;
      });
      expect(next).to.equal(true);
    });
  });
});
