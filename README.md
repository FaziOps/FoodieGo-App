# Restaurant App — Flutter, Clean Architecture

This project implements the PRD/architecture document exactly:
`lib/core` (shared) + `lib/features/{auth,menu,cart,checkout,orders,navigation,rating,rider_management,notifications}`,
each split into `domain/`, `data/`, `presentation/`.

## What's real vs what's a placeholder

Everything compiles against real packages (firebase_auth, cloud_firestore,
flutter_bloc, flutter_stripe, url_launcher, get_it, dartz, hive). Three
things need YOUR project's values before this runs:

1. **`lib/firebase_options.dart`** — placeholder that throws on purpose.
   Run `flutterfire configure` from the project root; it overwrites this
   file with your real Firebase project's keys.

2. **Stripe publishable key** — in `lib/main.dart`:
   `Stripe.publishableKey = 'pk_test_REPLACE_WITH_YOUR_PUBLISHABLE_KEY';`

3. **Stripe PaymentIntent backend URL** — in `lib/core/di/injection_container.dart`:
   `const String kCreatePaymentIntentUrl = 'https://REPLACE_WITH_YOUR_BACKEND/createPaymentIntent';`
   **Why this can't be client-only:** creating a PaymentIntent requires
   Stripe's secret key. A secret key must never ship inside a Flutter app —
   anyone can decompile it. You need a small backend (a Cloud Function is
   the natural choice since you're already on Firebase) that takes an
   amount, calls Stripe server-side, and returns `{"clientSecret": "..."}`.
   That function is NOT included here — it's outside Flutter's scope.

Same constraint applies to `lib/features/notifications/data/datasources/fcm_data_source.dart`:
actually sending a push notification requires the Firebase Admin SDK server-side.
The client-side registration (storing the device token) is real; the send
call is a documented stub with a TODO, not a silent fake.

## Setup steps

```bash
flutter pub get
flutterfire configure          # generates real firebase_options.dart
flutter run
```

You also need, in your Firebase project:
- Authentication → Email/Password provider enabled
- Firestore → collections `users`, `orders`, `menuItems`, `categories`
  (created automatically on first write, but see security rules below —
  create these BEFORE letting real users in)
- Cloud Messaging → enabled for push (once you build the backend send function)

## Firestore security rules — non-negotiable

The PRD's Non-Functional Requirements section says the order status flow
must be enforced server-side, not just in the Flutter UI. This app's
Flutter code assumes these rules (or equivalent Cloud Functions
validation) exist. Without them, any authenticated client can write any
field on any order, including setting themselves as `admin`.

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isSignedIn() { return request.auth != null; }
    function role() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role;
    }

    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && request.auth.uid == userId;
      // Users can only edit their own doc, and can NEVER change their own role.
      allow update: if isSignedIn() && request.auth.uid == userId
                    && request.resource.data.role == resource.data.role;
    }

    match /menuItems/{itemId} {
      allow read: if true;
      allow write: if isSignedIn() && role() == 'admin';
    }

    match /categories/{categoryId} {
      allow read: if true;
      allow write: if isSignedIn() && role() == 'admin';
    }

    match /orders/{orderId} {
      allow create: if isSignedIn() && request.resource.data.customerId == request.auth.uid;

      allow read: if isSignedIn() && (
        resource.data.customerId == request.auth.uid ||
        resource.data.riderId == request.auth.uid ||
        role() == 'admin'
      );

      // Admin: accept / assign rider / (future) reject.
      allow update: if isSignedIn() && role() == 'admin';

      // Rider: can only touch orderStatus on their own assigned order,
      // and only to the field the app sends — full status-flow validation
      // (no skipping steps) belongs in a Cloud Function trigger, not here;
      // rules alone cannot express "next status in sequence" cleanly.
      allow update: if isSignedIn() && resource.data.riderId == request.auth.uid
                    && request.resource.data.diff(resource.data).affectedKeys()
                       .hasOnly(['orderStatus']);

      // Customer: can only add a rating to their own delivered order.
      allow update: if isSignedIn() && resource.data.customerId == request.auth.uid
                    && resource.data.orderStatus == 'Delivered'
                    && request.resource.data.diff(resource.data).affectedKeys()
                       .hasOnly(['rating']);
    }
  }
}
```


Treat this as a starting point, not a finished audit — get someone to
review it against your actual `orderStatus` transition rules before
production, especially the "no skipping steps" requirement, which needs a
Cloud Function since Firestore rules can't easily read "was the previous
status X" without an extra `get()` call per write.

## Known gaps carried over from the PRD's "Open Decisions"

These are wired with reasonable defaults but need your decision:
- Order cancellation (`CancelOrderUseCase`) has no refund logic attached.
- Order rejection by admin isn't implemented — only accept.
- Rider online/offline toggle UI isn't built; `isOnline` exists on the
  user doc and `GetAvailableRidersUseCase` filters on it, but nothing
  in the rider UI flips it yet.
- `AddressForm` takes manual lat/lng entry — replace with a real place
  picker (Google Places Autocomplete) before shipping.
