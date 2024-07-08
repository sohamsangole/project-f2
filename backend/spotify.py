import asyncio
import requests

# Your Spotify access token
token = 'BQAyoLr75iohXYAee2yU067Tfsed8xIsOiMjHNzh3kSd03Kclm5_I1LdDCMiklQ1hjOKwVNhluHIDzuW_APX-c1rWBJPOhLNsmNRj-I3P0bnJdM8LnSdd7IwSkD1w_S9T-xk61Wzjrob9bR_ZMsojq5Kmv9EHQ4HK0VG1yWrPucQ1d1g2L23rIgwKQIcoIQgGR3uyTR8jm3tCZJLIER8db8gOH_5EfokKriO35N6iTLyTwqNEd_7PBXa16FVR8KQCMRUC10xKbwNfTwoKSEv-ukYZJN9'

async def fetch_web_api(endpoint, method='GET', body=None):
    url = f'https://api.spotify.com/{endpoint}'
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json',
    }
    if method == 'GET':
        response = requests.get(url, headers=headers)
    elif method == 'POST':
        response = requests.post(url, headers=headers, json=body)
    elif method == 'PUT':
        response = requests.put(url, headers=headers, json=body)
    elif method == 'DELETE':
        response = requests.delete(url, headers=headers)
    else:
        raise ValueError(f'Unsupported HTTP method: {method}')
    
    return response.json()

async def get_top_tracks():
    endpoint = 'v1/me/top/tracks?time_range=long_term&limit=5'
    return await fetch_web_api(endpoint, 'GET')

async def get_profile():
    endpoint = 'v1/me'
    return await fetch_web_api(endpoint, 'GET')

async def main():
    # Call the async function and await its result
    top_tracks = await get_top_tracks()
    profile = await get_profile()

    # Display profile information
    if profile:
        print(f"User Profile:")
        print(f"ID: {profile.get('id')}")
        print(f"Display Name: {profile.get('display_name')}")
        print(f"Email: {profile.get('email')}")
        print(f"Country: {profile.get('country')}\n")

    # Display the results
    if top_tracks and 'items' in top_tracks:
        print("Top Tracks:")
        for idx, track in enumerate(top_tracks['items'], start=1):
            track_name = track['name']
            artists = ', '.join([artist['name'] for artist in track['artists']])
            print(f"{idx}. {track_name} by {artists}")
    else:
        print("No top tracks found.")

# Run the event loop to execute the asynchronous code
if __name__ == "__main__":
    asyncio.run(main())
