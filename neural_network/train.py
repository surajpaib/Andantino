import pandas as pd 
import tensorflow as tf
import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Flatten
from keras.layers import Conv2D, MaxPooling2D
import os
import numpy as np


num_classes = 2

model = Sequential()
model.add(Dense(256, input_shape=(271,)))
model.add(Activation('relu'))
model.add(Dense(512))
model.add(Activation('relu'))
model.add(Dense(1024))
model.add(Activation('relu'))
model.add(Dense(1024))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(1024))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(512))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(1))
model.add(Activation('softmax'))

opt = keras.optimizers.RMSprop(learning_rate=0.0001, decay=1e-6)
model.compile(loss='binary_crossentropy',
              optimizer=opt,
              metrics=['accuracy'])

for input_chunk, output_chunk in zip(pd.read_csv('training_input.csv', header=None, chunksize=100000), pd.read_csv('training_output.csv', header=None,chunksize=100000)):
    
    input_chunk = input_chunk.replace(-1, 0)
    input_chunk = input_chunk.replace(11, 1)
    input_chunk = input_chunk.replace(22, -1)
    output_chunk = output_chunk.replace(-1, 0)
    output_chunk = output_chunk.replace(1, 1)

    train_input = input_chunk.values
    train_output = output_chunk.values
    print(np.shape(train_input))
    print(np.shape(train_output))

    model.fit(train_input, train_output, batch_size=1024)




