
import pandas

data = pandas.read_csv('data', low_memory=False, sep=" ")
data.columns

print (len(data)) #number of observations (rows)
print (len(data.columns)) # number of variables (columns)
print (len(data['RT'])) #number of observations (rows)

print 'counts for RT'
c1 = data['RT'].value_counts(sort=False)
print (c1)

print 'percentages for RT'
p1 = data['RT'].value_counts(sort=False, normalize=True)
print (p1)

print 'counts for acc'
c2 = data['acc'].value_counts(sort=False)
print(c2)

print 'percentages for acc'
p2 = data['acc'].value_counts(sort=False, normalize=True)
print (p2)

print 'counts for Quest'
c3 = data['Quest'].value_counts(sort=False)
print(c3)

print 'percentages for Quest'
p3 = data['Quest'].value_counts(sort=False, normalize=True)
print (p3)

# median split data depending on Quest scores
data['highPerf'] = data['Quest'] > data['Quest'].median()
print(data['highPerf'].value_counts()) 
print(data.groupby('highPerf').size() * 100 / len(data))

# mean accuracy and RT for high and low 'Quest' groups
highGr=data[(data['highPerf']==True)]
print(highGr['acc'].mean())
print(highGr['RT'].mean())

lowGr=data[(data['highPerf']==False)]
print(lowGr['acc'].mean())
print(lowGr['RT'].mean())
