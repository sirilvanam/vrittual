# CI guide — build and distribute Vrittual

This document explains the included GitHub Actions workflow that builds an Xcode archive and how to extend it to produce a signed .ipa and upload to TestFlight.

Files added
- `.github/workflows/ci-build.yml` — builds an `.xcarchive` and uploads it as an artifact.

What the workflow does
- Checks out the repo on a macOS runner.
- Runs `xcodebuild archive` to create `Vrittual.xcarchive`.
- Uploads `Vrittual.xcarchive` as a GitHub Actions artifact.
- Optionally attempts to export an `.ipa` if you add an `exportOptions.plist` (and configure signing on the runner).

Why this is useful
- You can get a reproducible macOS CI build even if you cannot install Xcode locally.
- Download the artifact (the `.xcarchive`) and either extract/sign locally or use Fastlane on CI to upload to TestFlight.

Configuring signing and TestFlight uploads
1. Using App Store Connect API (recommended):
   - Create an API key in App Store Connect (Users & Access → Keys).
   - In GitHub repo settings, add the following secrets:
     - `APP_STORE_CONNECT_ISSUER_ID` — the issuer id from App Store Connect.
     - `APP_STORE_CONNECT_KEY_ID` — the key id.
     - `APP_STORE_CONNECT_PRIVATE_KEY` — the private key contents (base64-encode if you prefer).
   - Use Fastlane (see example Fastfile) to authenticate and upload builds from CI.

2. Provisioning & certificates (if you want CI to export a signed .ipa):
   - Upload provisioning profiles and certificates to GitHub Secrets (or use `match` with Fastlane).
   - Provide an `exportOptions.plist` at `.github/workflows/exportOptions.plist` describing export method (`app-store`, `ad-hoc`, etc.).
   - Update the workflow to install certificates/profiles before the `xcodebuild -exportArchive` step.

Example: quick flow
- Run the workflow (push to a branch). Download the artifact from the workflow run (Vrittual-xcarchive).
- On a Mac with Xcode you trust, open the archive in Xcode → Window → Organizer → locate the archive and choose Distribute App → App Store Connect or Export for Ad Hoc.

Extending the workflow with Fastlane
- If you want automatic TestFlight uploads, install Fastlane in the workflow and use the App Store Connect API key. See `fastlane/Fastfile` for an example lane. You will need to add App identifier and team details and store the private key securely.

Required GitHub Secrets for automatic TestFlight uploads
-- APP_STORE_CONNECT_KEY_ID: App Store Connect API Key ID (e.g. ABCDE12345)
-- APP_STORE_CONNECT_ISSUER_ID: App Store Connect Issuer ID (UUID)
-- APP_STORE_CONNECT_PRIVATE_KEY: Base64-encoded private key file contents (AuthKey_XXXXX.p8) — base64 to avoid line-break issues when adding secrets.
-- APPLE_ID: (optional) Apple ID email used for some Fastlane operations.
-- APP_IDENTIFIER: your app bundle identifier (e.g. com.example.Vrittual)
-- TEAM_ID: Apple Developer Team ID (if needed)

Optional (for explicit code signing on CI)
-- CERTIFICATE_P12: Base64-encoded .p12 certificate containing your signing identity.
-- CERTIFICATE_PASSWORD: password for the .p12 file.
-- PROVISIONING_PROFILE: Base64-encoded .mobileprovision file.

How the workflow uses these secrets
- The workflow will decode `APP_STORE_CONNECT_PRIVATE_KEY` into an AuthKey .p8 file and set environment variables `APP_STORE_CONNECT_KEY_ID` and `APP_STORE_CONNECT_ISSUER_ID` so Fastlane can authenticate with App Store Connect.
- If you provide `CERTIFICATE_P12`, `CERTIFICATE_PASSWORD`, and `PROVISIONING_PROFILE`, the workflow will import them into the macOS keychain and provisioning profile directory so code signing can succeed on the runner.

Creating the App Store Connect API key
1. In App Store Connect go to Users and Access → Keys → Create API Key.
2. Give it a name and assign the Developer role (or App Manager for uploads).
3. Download the AuthKey_XXXXXX.p8 file and note the Key ID and Issuer ID.
4. Base64 encode the .p8 file content before adding as a GitHub secret:

```bash
base64 -i AuthKey_XXXXXX.p8 | pbcopy   # macOS
# paste into GitHub secret APP_STORE_CONNECT_PRIVATE_KEY
```

Storing certificates/profiles
- Export your signing certificate as a .p12 and base64 encode it for `CERTIFICATE_P12`. Store the .mobileprovision the same way.

Security notes
- Use GitHub Actions secrets for all private material and verify repository collaborators.

Next steps I can take for you
- Add the exact `exportOptions.plist` and update Fastlane to read more env variables if you'd like automated ad-hoc or enterprise exports.
- Add a small CI checklist to help you set secrets in GitHub repository settings.


Security notes
- Never store private keys or provisioning profiles in the repository. Use GitHub Secrets.

If you want, I can:
- Add automatic certificate/profile installation steps to the workflow using GitHub Secrets.
- Add a Fastlane lane and a workflow job that uses App Store Connect API to upload to TestFlight (I will show what secrets are required).
