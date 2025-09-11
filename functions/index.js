const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Firestore trigger: runs when a new doc is created in "emergencies" collection
exports.notifyOnEmergency = functions.firestore
  .document('emergencies/{docId}')
  .onCreate(async (snap, context) => {
    const data = snap.data() || {};
    const location = data.location || 'Unknown location';
    const desc = (data.description || '').slice(0, 100);

    const message = {
      notification: {
        title: '🚨 New Emergency Reported',
        body: `${location}: ${desc}`
      },
      data: {
        screen: 'emergencies' // Flutter app uses this to navigate
      },
      topic: 'emergencies'
    };

    try {
      const res = await admin.messaging().send(message);
      console.log('Notification sent:', res);
      return null;
    } catch (err) {
      console.error('Error sending notification', err);
      return null;
    }
  });
