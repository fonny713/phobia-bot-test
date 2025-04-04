# Firebase Setup Instructions

## Firebase Storage Rules

To fix the "User is not authorized to perform the desired action" error, you need to deploy the Firebase Storage rules. Follow these steps:

1. Install the Firebase CLI if you haven't already:
   ```
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```
   firebase login
   ```

3. Initialize Firebase in your project directory:
   ```
   firebase init
   ```
   - Select "Storage" when prompted for features
   - Select your project when prompted

4. Deploy the Storage rules:
   ```
   firebase deploy --only storage
   ```

## Alternative: Update Rules in Firebase Console

If you prefer to update the rules through the Firebase Console:

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to "Storage" in the left sidebar
4. Click on the "Rules" tab
5. Replace the existing rules with the following:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      // Allow read access to all users
      allow read: if true;
      
      // Only allow write access to authenticated users
      allow write: if request.auth != null;
    }
  }
}
```

6. Click "Publish"

## Troubleshooting

If you're still experiencing issues after deploying the rules:

1. Make sure your app is properly initialized with Firebase
2. Check that your Firebase project has Storage enabled
3. Verify that your app is using the correct Firebase project
4. Try signing in anonymously before accessing Storage
5. Check the Firebase Console logs for any errors

## Additional Resources

- [Firebase Storage Documentation](https://firebase.google.com/docs/storage)
- [Firebase Storage Rules Documentation](https://firebase.google.com/docs/storage/security)
- [Firebase Authentication Documentation](https://firebase.google.com/docs/auth) 