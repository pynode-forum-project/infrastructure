// Initialize MongoDB databases and collections

// Switch to post_db
db = db.getSiblingDB('post_db');

// Create posts collection with indexes
db.createCollection('posts');
db.posts.createIndex({ userId: 1 });
db.posts.createIndex({ status: 1 });
db.posts.createIndex({ dateCreated: -1 });
db.posts.createIndex({ title: 'text', content: 'text' });

// Create replies collection with indexes
db.createCollection('replies');
db.replies.createIndex({ postId: 1 });
db.replies.createIndex({ userId: 1 });
db.replies.createIndex({ dateCreated: -1 });

// Switch to history_db
db = db.getSiblingDB('history_db');

// Create histories collection with indexes
db.createCollection('histories');
db.histories.createIndex({ userId: 1 });
db.histories.createIndex({ postId: 1 });
db.histories.createIndex({ viewDate: -1 });
db.histories.createIndex({ userId: 1, viewDate: -1 });

print('MongoDB initialization completed successfully!');
