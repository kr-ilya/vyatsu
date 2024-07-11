import cv2
import numpy as np
img = cv2.imread('./task6.jpg')
obr = np.array([0,0,0])
fil = np.array([245,0,148])  
ll = len(img)
cnt = 0
for i in range(ll): #x
    for j in range(ll): #y
        if(all(img[i][j] == obr) & (i+1 != ll) & (j + 1 != ll)):
            x = 20
            y = 20
            if(all(img[i-1][j] == obr) & all(img[i][j-1] == obr) & all(img[i+1][j] != fil) & all(img[i][j+1] != fil)):
                if(i-20 < 0):
                    x = i
                if(j-20 < 0):
                    y = j
                
                for k in range(x):
                    for m in range(y):
                        img[i-k][j-m] = np.array([245,0,148])        


                cnt += 1
                # img[0:2][0:20] = np.full((2, 20, 3), fill_value=np.array([245,0,148]))
            elif(all(img[i+1][j] == obr) & all(img[i][j-1] == obr) & all(img[i-1][j] != fil) & all(img[i][j+1] != fil)):
                if(i+20 > ll):
                    x = (i+20)-ll
                if(j-20 < 0):
                    y = j

                for k in range(x):
                    for m in range(y):
                        img[i+k][j-m] = np.array([245,0,148])

                cnt += 1   
                # img[i:i+x][j-y:j] = np.array([245,0,148])
            elif(all(img[i+1][j] == obr) & all(img[i][j+1] == obr) & all(img[i][j-1] != fil) & all(img[i-1][j] != fil)):
                if(i+20 > ll):
                    x = (i+20)-ll
                if(j+20 > ll):
                    y = (j+20)-ll

                for k in range(x):
                    for m in range(y):
                        img[i+k][j+m] = np.array([245,0,148])   

                cnt += 1
                # img[i:i+x][j:j+y] = np.array([245,0,148])
            elif(all(img[i-1][j] == obr) & all(img[i][j+1] == obr) & all(img[i+1][j] != fil) & all(img[i][j-1] != fil)):
                if(i-20 < 0):
                    x = i
                if(j+20 > ll):
                    y = (j+20)-ll

                for k in range(x):
                    for m in range(y):
                        img[i-k][j+m] = np.array([245,0,148])   

                cnt += 1
                # img[i-x:i][j:j+y] = np.array([245,0,148])
cv2.imwrite('./res66.bmp',img)
print(cnt)