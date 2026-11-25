using System;
using System.Diagnostics;
using System.IO;
using System.IO.MemoryMappedFiles;
using System.Threading;
using FreeTrackVJoy.Core;

namespace FreeTrackVJoy
{
    /// <summary>Reads FreeTrack 2.2's shared memory. Re-opens it if FreeTrack is started later or restarted.</summary>
    internal sealed class FreeTrackReader : IDisposable
    {
        private static readonly TimeSpan RetryEvery = TimeSpan.FromMilliseconds(300);

        private MemoryMappedFile? _map;
        private MemoryMappedViewAccessor? _view;
        private Mutex? _mutex;
        private readonly byte[] _buffer = new byte[FreeTrackFrame.Size];
        private readonly Stopwatch _clock = Stopwatch.StartNew();
        private TimeSpan _lastOpenTry = TimeSpan.MinValue;
        private TimeSpan _lastMutexTry = TimeSpan.MinValue;

        public bool IsOpen => _view != null;

        /// <summary>Try to read a frame. Returns false if FreeTrack is not running yet.</summary>
        public bool TryRead(out FreeTrackFrame frame)
        {
            frame = default;
            if (_view == null && !TryOpen()) return false;
            if (_mutex == null) TryOpenMutex(); // FreeTrack creates the mutex just after the memory

            Mutex? mutex = _mutex; // local copy: Close() below must not null it under us
            bool locked = false;
            bool failed = false;
            try
            {
                if (mutex != null)
                {
                    try { locked = mutex.WaitOne(5); }
                    catch (AbandonedMutexException) { locked = true; } // FreeTrack crashed while holding it; we now own it
                    if (!locked) return false; // FreeTrack is writing; try again next tick
                }
                _view!.ReadArray(0, _buffer, 0, _buffer.Length);
            }
            catch (Exception e) when (e is IOException || e is UnauthorizedAccessException || e is ObjectDisposedException)
            {
                failed = true;
            }
            finally
            {
                if (locked) mutex!.ReleaseMutex();
            }

            if (failed) { Close(); return false; }
            frame = FreeTrackFrame.FromBytes(_buffer);
            return true;
        }

        private bool TryOpen()
        {
            // Don't hammer OpenExisting 500 times a second while FreeTrack is closed.
            if (_clock.Elapsed - _lastOpenTry < RetryEvery) return false;
            _lastOpenTry = _clock.Elapsed;
            try
            {
                _map = MemoryMappedFile.OpenExisting(FreeTrackFrame.SharedMemoryName, MemoryMappedFileRights.Read);
                _view = _map.CreateViewAccessor(0, FreeTrackFrame.Size, MemoryMappedFileAccess.Read);
                return true;
            }
            catch (Exception e) when (e is FileNotFoundException || e is IOException || e is UnauthorizedAccessException)
            {
                Close();
                return false;
            }
        }

        private void TryOpenMutex()
        {
            if (_clock.Elapsed - _lastMutexTry < RetryEvery) return;
            _lastMutexTry = _clock.Elapsed;
            try { _mutex = Mutex.OpenExisting(FreeTrackFrame.MutexName); }
            catch (WaitHandleCannotBeOpenedException) { _mutex = null; } // read without lock for now
            catch (UnauthorizedAccessException) { _mutex = null; }
        }

        private void Close()
        {
            _view?.Dispose(); _view = null;
            _map?.Dispose(); _map = null;
            _mutex?.Dispose(); _mutex = null;
        }

        public void Dispose() => Close();
    }
}
