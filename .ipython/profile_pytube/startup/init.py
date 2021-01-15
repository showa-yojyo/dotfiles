from pytube import YouTube

def download_video(watch_url):
    yt = YouTube(watch_url)
    (yt.streams
        .filter(progressive=True, file_extension='mp4')
        .order_by('resolution')
        .desc()
        .first()
        .download())
