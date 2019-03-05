const expect = require('chai').expect;
const ping = require('../../routes/ping');

let req = {
  body: {}
};

let res = {
  sendCalledWith: '',
  json: function(arg) {
    this.sendCalledWith = arg.message;
  }
};

describe('Ping route', function() {
  describe('Ping function', function() {
    it('Should return a pong message', function() {
      ping(req, res);
      expect(res.sendCalledWith).to.contain('Welcome');
    });
  });
});
