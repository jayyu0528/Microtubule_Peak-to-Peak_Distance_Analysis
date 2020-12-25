function filePath2 = convert_to_JY_filePath(filePath1)

filePath2 = filePath1;
filePath2(find(filePath2 == '\')) = '/';
filePath2(1:29) = [];
filePath2 = ['/Users/Jay/Dropbox (MIT)/Shared folders/Tetragel with Rui/' filePath2];