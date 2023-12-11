import threading
import subprocess

def execute_script(script):
    subprocess.run(['python', script])


if __name__ == "__main__":
    script1 = "dog1_buyLink.py"
    script2 = "dog2_buyLink.py"
    script3 = "dog3_buyLink.py"
    script4 = "dog4_buyLink.py"
    script5 = "cat1_buyLink.py"
    script6 = "cat2_buyLink.py"
    script7 = "cat3_buyLink.py"
    script8 = "cat4_buyLink.py"


    # Create threads for each script
    thread1 = threading.Thread(target=execute_script, args=(script1,))
    thread2 = threading.Thread(target=execute_script, args=(script2,))
    thread3 = threading.Thread(target=execute_script, args=(script3,))
    thread4 = threading.Thread(target=execute_script, args=(script4,))
    thread5 = threading.Thread(target=execute_script, args=(script5,))
    thread6 = threading.Thread(target=execute_script, args=(script6,))
    thread7 = threading.Thread(target=execute_script, args=(script7,))
    thread8 = threading.Thread(target=execute_script, args=(script8,))

    # Start the threads
    thread1.start()
    thread2.start()
    thread3.start()
    thread4.start()
    thread5.start()
    thread6.start()
    thread7.start()
    thread8.start()

    # Wait for all threads to finish
    thread1.join()
    thread2.join()
    thread3.join()
    thread4.join()
    thread5.join()
    thread6.join()
    thread7.join()
    thread8.join()

    print("All threads have finished")
