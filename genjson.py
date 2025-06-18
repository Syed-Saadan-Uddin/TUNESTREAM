import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import json

# 1. Spotify setup – replace with your credentials
client_id = 'a02d010cd1114391be07298b182769bd'
client_secret = 'ce46d0bb15df45f4b72205e69547cf61'
auth = SpotifyClientCredentials(client_id=client_id, client_secret=client_secret)
sp = spotipy.Spotify(client_credentials_manager=auth)

# 2. Your raw filenames
og_filenames = [
    "2Pac - All Eyez On Me.mp3",
    "ACDC - Back In Black (Official Video).mp3",
    "Billie Eilish - BIRDS OF A FEATHER (Official Music Video).mp3",
    "Bon Jovi  Livin On A Prayer.mp3",
    "Bon Jovi - Bed Of Roses.mp3",
    "Coldplay - Hymn For The Weekend (Lyrics).mp3",
    "Crawling [Official HD Music Video] - Linkin Park.mp3",
    "Creed - One Last Breath (Official Video).mp3",
    "Elvis Presley - Such A Night wlyrics.mp3",
    "Falak Tak Song  Tashan  Akshay Kumar, Kareena Kapoor, Udit Narayan, Mahalaxmi Iyer, Vishal-Shekhar.mp3",
    "Fly me to the moon - Frank Sinatra (Lyrics).mp3",
    "George Michael - Careless Whisper (Official Video).mp3",
    "Goo Goo Dolls - Iris.mp3",
    "Guns N' Roses - Sweet Child O' Mine (Official Music Video).mp3",
    "Gym Class Heroes_ Stereo Hearts ft. Adam Levine _OFFICIAL VIDEO_.mp3",
    "In The End  Linkin Park.mp3",
    "Kajra Re  Full Song  Bunty Aur Babli  Aishwarya, Abhishek, Amitabh Bachchan  Shankar-Ehsaan-Loy.mp3",
    "kk - Aankhon Mein Teri Ajab Si.mp3",
    "Lady Gaga, Bruno Mars - Die With A Smile (Official Music Video).mp3",
    "Leave Out All The Rest (Official Music Video) [4K Upgrade] - Linkin Park.mp3",
    "Mera Bichraa Yaar  Strings  2003  Dhaani  (Official Video).mp3",
    "Mere Mehboob Mere Sanam  4K Video Song  Udit Narayan, Alka Yagnik  Shah Rukh Khan, Juhi Chawla.mp3",
    "Queen - I Want To Break Free (Official Video).mp3",
    "Red Hot Chili Peppers - Otherside [Official Music Video].mp3",
    "Santana - Smooth (Stereo) ft. Rob Thomas.mp3",
    "Sar Kiye Yeh Pahar Strings 2000 Duur (Official Video).mp3",
    "Shakira - Hips Dont Lie (Official Music Video) ft. Wyclef J.mp3",
    "Stephen Sanchez - Until I Found You.mp3",
    "The Notorious B.I.G. - Hypnotize (Official Audio).mp3",
    "The White Stripes - Seven Nation Army (Official Music Video).mp3",
    "U2 - I Still Haven't Found What I'm Looking For (Official Music Video).mp3",
    "U2 - With Or Without You (Official Music Video).mp3"
]

# 3. Titles or search terms (your existing list)
filenames = [
    "All Eyez On Me",
    "Back In Black",
    "BIRDS OF A FEATHER",
    "Livin On A Prayer",
    "Bed Of Roses",
    "Hymn For The Weekend",
    "Crawling",
    "One Last Breath",
    "Such A Night",
    "Falak Tak",
    "Fly Me To The Moon",
    "Careless Whisper",
    "Iris",
    "Sweet Child O' Mine",
    "Stereo Hearts",
    "In The End",
    "Kajra Re",
    "Ajab Si",
    "Die With A Smile",
    "Leave Out All The Rest",
    "Mera Bichraa Yaar",
    "Mere Mehboob Mere Sanam",
    "I Want To Break Free",
    "Otherside",
    "Smooth",
    "Sar Kiye Yeh Pahar",
    "Hips Don't Lie",
    "Until I Found You",
    "Hypnotize",
    "Seven Nation Army",
    "I Still Haven't Found What I'm Looking For",
    "With Or Without You"
]

output = []
for idx, (fname, og_fname) in enumerate(zip(filenames, og_filenames), start=1):
    query = fname
    results = sp.search(q=f"track:{query}", type="track", limit=1)
    items = results.get('tracks', {}).get('items')
    if not items:
        print(f"[{idx}] NOT FOUND: {query}")
        continue
    track = items[0]
    album = track['album']
    artists = [artist['name'] for artist in track['artists']]
    cover_img = album['images'][0]['url'] if album.get('images') else None

    output.append({
        "id": idx,
        "og_filename": og_fname,
        "spotify_id": track['id'],
        "name": track['name'],
        "artists": artists,
        "album": album['name'],
        "release_date": album.get('release_date'),
        "cover_url": cover_img,
        "spotify_url": track['external_urls']['spotify'],
        "duration_ms": track['duration_ms'],
        "explicit": track['explicit']
    })

# 4. Save to JSON
with open('songs_metadata.json', 'w', encoding='utf-8') as f:
    json.dump(output, f, indent=2, ensure_ascii=False)

print(f"✅ Saved metadata for {len(output)} songs to songs_metadata.json")
