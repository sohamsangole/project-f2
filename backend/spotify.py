import asyncio
import requests
import subprocess
subprocess.call('chcp 65001 > nul', shell=True)
token = 'BQAOE1oj4EY8Idung4yb0DxcTmSf3F8bmN3HEN1dhNtqQOLBaatIajZmsbqTYXKfsAidOk0Y04Jq5vKwVv7Du5x_VLd_14JKyRo3gLvr833BdsFGV4AvQ-kPp7wH_zqdLtKKKi4JJYmogtTu25_Q4PFdOeHTAjrzOp3ZCo_IYthgbWToYNS9HEe6plcXoj6R83WWKGd5V1YZCqKXwlzsoy8lJS8SnIciTUMl8e6DHYuMdAL7DfeP0ApCmsJyItuMU9Fp6dpe01hk1VvKqJOfeNDxndXI'

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

async def main():
    # Call the async function and await its result
    top_tracks = await get_top_tracks()

    # Display the results
    if top_tracks and 'items' in top_tracks:
        for idx, track in enumerate(top_tracks['items'], start=1):
            track_name = track['name']
            artists = ', '.join([artist['name'] for artist in track['artists']])
            # Print using UTF-8 encoding explicitly
            print(f"{idx}. {track_name} by {artists.encode('utf-8').decode('utf-8')}")
    else:
        print("No top tracks found.")

# Run the event loop to execute the asynchronous code
if __name__ == "__main__":
    asyncio.run(main())
