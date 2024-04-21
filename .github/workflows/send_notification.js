const axios = require('axios');

const message = `
ℹ️ New commit pushed to the repository:
🔄 Branch: ${process.env.GITHUB_REF}
🆕 Commit: ${process.env.GITHUB_SHA.slice(0, 7)}
📝 Message: ${process.env.GITHUB_EVENT_PATH.message}
`;

axios.post(`https://api.telegram.org/bot${process.env.TELEGRAM_BOT_TOKEN}/sendMessage`, {
  chat_id: process.env.TELEGRAM_CHANNEL_ID,
  text: message,
}).then(() => console.log('Message sent successfully.')).catch((error) => console.error('Error sending message:', error));
