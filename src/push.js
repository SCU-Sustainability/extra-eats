const OneSignal = require('onesignal-node');

const pushClient = new OneSignal.Client({
  userAuthKey: process.env.PUSH_AUTH_KEY,
  app: {
    appAuthKey: process.env.PUSH_APP_AUTH_KEY,
    appId: process.env.PUSH_APP_ID
  }
});

const push = (name, description) => {
  let notif = new OneSignal.Notification({
    contents: {
      en: name + '\n' + description
    },
    included_segments: ['Active Users', 'Inactive Users']
  });

  return pushClient.sendNotification(notif);
};

module.exports = push;
