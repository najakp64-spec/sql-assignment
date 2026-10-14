
# 1.string concatenation
string1= "Hello "
string2= "zara"
s= string1 + string2

print(s)

# 1.2.second concatenation
string3= " , Welcome to Python Programming"
s1=s + string3
print(s1)

# 2.string slicing and indexing
print(s1[0])
print(s1[-1])
print(s1[0:5])
print(s1[-11:])
print(s1[::-1])
print(s1[24:30])

# 3.string methods
strM= " Python beginner tutorial"
strM= strM.upper()
print(strM)
strM= strM.lower()
print(strM)
print("original:" , strM)
cap= strM.capitalize()
print("capitalized:",cap)
print( "back to original:",strM)
count_t=strM.count( 't')
print(count_t)
replaced= strM.replace(" python" , " Machine Learning")
print(replaced)

# 4.tuple
t1= (10,20,30)
t2= (40,50,60)
t_combine= t1 + t2
print(t_combine)
repeated= t_combine * 3
print(repeated)
t_combine= t1 + t2
print(t_combine[2])
t_combine= t1 + t2
print(t_combine[0:3])
t_combine= t1 + t2
print(t_combine[-4:-1])

