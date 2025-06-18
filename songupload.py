import os
import json
import shutil
import firebase_admin
from firebase_admin import credentials, firestore

# --- CONFIGURATION ---
# ❗️ IMPORTANT: Replace with your Firebase Project ID.
# You can find this in your Firebase project settings. It's the unique ID, not the display name.
FIREBASE_PROJECT_ID = "appdev-proj-5c3b5" 

SERVICE_ACCOUNT_KEY_PATH = "service-account-key.json"
METADATA_JSON_FILE = "songs_metadata.json"
SOURCE_SONGS_FOLDER = "songs"
HOSTING_SONGS_FOLDER = os.path.join("public", "songs") # Will copy songs to 'public/songs/'
FIRESTORE_COLLECTION_NAME = "songs"

def initialize_firebase():
    """Initializes the Firebase Admin SDK for Firestore operations."""
    try:
        cred = credentials.Certificate(SERVICE_ACCOUNT_KEY_PATH)
        # No storage bucket needed for this approach
        firebase_admin.initialize_app(cred) 
        print("✅ Firebase initialized successfully for Firestore.")
    except Exception as e:
        print(f"❌ Error initializing Firebase: {e}")
        exit()

def main():
    """Prepares metadata for Firestore and stages files for Firebase Hosting."""
    
    # --- Part 1: Prepare local files for deployment ---
    
    # Create the target directory inside 'public' if it doesn't exist
    if not os.path.exists(HOSTING_SONGS_FOLDER):
        os.makedirs(HOSTING_SONGS_FOLDER)
        print(f"✅ Created deployment folder: '{HOSTING_SONGS_FOLDER}'")

    try:
        with open(METADATA_JSON_FILE, 'r', encoding='utf-8') as f:
            songs_metadata = json.load(f)
        print(f"✅ Successfully loaded metadata from '{METADATA_JSON_FILE}'.")
    except Exception as e:
        print(f"❌ Error loading metadata JSON: {e}")
        return
        
    print("\n--- Staging files for deployment ---")
    for song_data in songs_metadata:
        original_filename = song_data.get('og_filename')
        if not original_filename:
            continue
            
        source_path = os.path.join(SOURCE_SONGS_FOLDER, original_filename)
        destination_path = os.path.join(HOSTING_SONGS_FOLDER, original_filename)
        
        if os.path.exists(source_path):
            print(f"    - Copying '{original_filename}' to public folder.")
            shutil.copy(source_path, destination_path)
        else:
            print(f"    ⚠️ Warning: Source file not found for '{original_filename}'")
            
    # --- Part 2: Upload metadata to Firestore ---
    
    print("\n--- Uploading metadata to Firestore ---")
    initialize_firebase()
    db = firestore.client()

    base_hosting_url = f"https://{FIREBASE_PROJECT_ID}.web.app/songs"

    for song_data in songs_metadata:
        song_name = song_data.get('name', 'Unknown Song')
        original_filename = song_data.get('og_filename')

        if not original_filename:
            print(f"⚠️ Skipping '{song_name}' due to missing 'og_filename'.")
            continue

        # Construct the final public URL
        # NOTE: Firebase Hosting URLs are case-sensitive!
        song_url = f"{base_hosting_url}/{original_filename.replace(' ', '%20')}"
        
        # Prepare the document for Firestore
        firestore_document = song_data.copy()
        firestore_document['song_url'] = song_url
        
        # Clean up the document
        if 'og_filename' in firestore_document:
            del firestore_document['og_filename']
        
        document_id = str(firestore_document['id'])
        
        try:
            db.collection(FIRESTORE_COLLECTION_NAME).document(document_id).set(firestore_document)
            print(f"    ✅ Uploaded metadata for '{song_name}'")
        except Exception as e:
            print(f"    ❌ Error uploading document for '{song_name}': {e}")
            
    print("\n" + "="*40)
    print("🎉 Stage 1 Complete! 🎉")
    print("Metadata has been uploaded to Firestore.")
    print("Your song files have been copied to the 'public/songs' directory.")
    print("\n➡️ Next Step: Run 'firebase deploy --only hosting' in your terminal.")
    print("="*40)

if __name__ == "__main__":
    main()