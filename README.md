# SHORT INSURANCE — Flutter MVP

Android + iPhone starter app for a UAE motor-insurance business.

Included:
- Home screen
- Car, Bike, Van, Pickup, Truck, Bus
- Comprehensive / Third Party (TPL)
- Get Quote form
- Mulkiya image upload
- AED starting prices
- WhatsApp quote request with pre-filled message
- Call and Email buttons
- Local Admin Panel with PIN
- Admin can edit prices and contact details on the device

Business details:
WhatsApp: 0525851696
Call: 0554130100
Email: mohammedbashith@gmail.com

Admin PIN in this MVP: 2585

Important:
The Admin Panel currently stores changes locally on the device. For live price/contact updates on every customer's phone, connect the admin settings to a cloud database such as Firebase or Supabase before production.

Run:
flutter pub get
flutter run

Android:
flutter build apk --release

iPhone:
flutter build ios --release
