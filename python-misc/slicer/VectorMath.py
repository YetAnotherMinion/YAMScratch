# -*- coding: utf-8 -*-
"""
Created on Fri Jun 27 10:42:40 2014

@author: YetAnotherMinion
"""
import math


'''THIS WORKS: DONT TOUCH**********************************************'''        

def magnitude(vec):
    vec = list(vec)    
    temp = math.sqrt(sum(i**2 for i in vec))
    return temp

class Quaternion(object):
       
    @classmethod
    def inverse(cls,quat):
        # find the conjugate and divide by magnitude
        n = magnitude(quat)
        quat = list(quat) # cats to list so we can modify terms
        quat[0] =  quat[0]/n        
        quat[1] = -quat[1]/n
        quat[2] = -quat[2]/n
        quat[3] = -quat[3]/n
        return quat
        
    @classmethod    
    def multiply(cls,quatA,quatB):
        result =  [quatA[0]*quatB[0]-quatA[1]*quatB[1]-quatA[2]*quatB[2]-quatA[3]*quatB[3],
                   quatA[1]*quatB[0]+quatA[0]*quatB[1]-quatA[3]*quatB[2]+quatA[2]*quatB[3],
                   quatA[2]*quatB[0]+quatA[3]*quatB[1]+quatA[0]*quatB[2]-quatA[1]*quatB[3],
                   quatA[3]*quatB[0]-quatA[2]*quatB[1]+quatA[1]*quatB[2]+quatA[0]*quatB[3]]
        return result
        
    @classmethod
    def rotation(cls,vector,quaternion):
        # first turn vector into a quaternion if it is not already one        
        if len(vector) == 3:
            vector = list(vector) #cast to list so we can insert
            vector.insert(0,0) # insert a 0 for the real part of the quaternion
        else:
            assert len(vector) == 4 # make sure vector is a quaternion
        # compose the sandwitch product
        # calculate the inverse of the quaternion
        inverse = cls.inverse(quaternion)
        # compose the left side of sandwich
        left = cls.multiply(quaternion,vector)
        # multiply the left with the inverse
        result = cls.multiply(left,inverse) #returns a list
        #remove the first value which will be zero for real rotations
        result.pop(0)
        return result
        
    @classmethod
    def compose_quaternion(cls,angle,axis): #angle in radians
        # make sure we are working with a three vector
        assert len(axis) == 3
        # check vector and ensure it is unit vector
        PRACTICALLY_ZERO = 0.000000001
        if 1.0 - PRACTICALLY_ZERO < magnitude(axis) < 1.0 + PRACTICALLY_ZERO:
            normed_axis = [float(x) for x in axis]
        else:
            mag = magnitude(axis)
            normed_axis = [float(x/mag) for x in axis]
        quat = [0,0,0,0]    
        quat[0] = math.cos(angle/2)
        quat[1] = math.sin(angle/2)*normed_axis[0]
        quat[2] = math.sin(angle/2)*normed_axis[1]
        quat[3] = math.sin(angle/2)*normed_axis[2]
        return quat

        
'''END OF THIS WORKS**********************************************'''

PRACTICALLY_ZERO = 0.000000001

def check_orthagonal(vectorA,vectorB):
    assert len(vectorA) == len (vectorB)
    dot = lambda x,y: sum(x[i]*y[i] for i,v in enumerate(x))
    if abs(dot(vectorA,vectorB)) < PRACTICALLY_ZERO:
        return True # the vectors are orthagonal
    else: 
        return False # the vectors are not orthagonal
        
def cross_product(vector_A, vector_B):
    try:
        # allow 2D and 3D vectors to be mixed
        # cross product is only defined for 2,3 and 7 dimensions
        assert 2 <= len(vector_A) <= 3,'Invalid rank: Vector_A must be 2 or 3-vector'
        assert 2 <= len(vector_B) <= 3,'Invalid rank: Vector_B must be 2 or 3-vector'
    except AssertionError as error:
        #if we get here someone passed in a bad vector
        #print error, '\n'
        return None, None
    else:
        if len(vector_A) == 2:
            vector_A = list(vector_A) # cast to list so we can modify
            vector_A.append(0) # convert to 3 vector
        if len(vector_B) == 2:
            vector_B = list(vector_B) # cast to list so we can modify
            vector_B.append(0) # convert to 3 vector
        # normalize the vectors
        # for shorter typing later we use one letter names for the normalized vectors
        A = [x/magnitude(vector_A) for x in vector_A]
        B = [x/magnitude(vector_B) for x in vector_B]
        # this works on all vectors, what we will do with it will only work with unit vectors
        cross_product = [A[1]*B[2]-A[2]*B[1],
                         A[2]*B[0]-A[0]*B[2],
                         A[0]*B[1]-A[1]*B[0]]
        angle = math.asin(magnitude(cross_product))
        return cross_product, angle
    
    
def generate_basis(n): # where n is normal vector of the body frame
    '''Calculate basis of vector space using quaternions.
    
    Parameters:
    ===============
            n = normal vector in coordinates of Inertial Frame, 
            does not have to a unit vector (although unit vectors are prefered)
    Operation:
    ===============
        Compose the quaternion by taking the cross-product **k** x **n**
        If the angle is small < 5 degrees then we rotate our reference 
        frame about the y-axis by 45 degrees using a quaternion to 
        make **k'**. Then we compute **k'** x **n** and compose a second 
        quaternion. \n
        Once the coordinate transformations are defined, the
        unit vectors of the body reference frame are computed and returned
        in inertial refrence frame coordinates.\n

    '''
    
    k = (0,0,1)
    basis = [[1,0,0],[0,1,0],[0,0,1]]
    
    cross, angle = cross_product(k, n)
    #the existance of axis k prime will be the flag to control which computation we do
    k_prime = None
    if abs(angle) < 0.2:
        #create another rotation quaternion
        reference_quaternion = Quaternion.compose_quaternion(math.pi/4,(0,1,0))
        k_prime =  Quaternion.rotation(n, reference_quaternion)
        #redefine cross and the angle for the final step
        cross, angle = cross_product(k_prime, n)
        final_quaternion = Quaternion.compose_quaternion(angle,cross)
        
    else:
        # if we did not get close than angle and cross are the first value calculated
        final_quaternion = Quaternion.compose_quaternion(angle,cross)
    # if we calculated a second axis we rotate our coordinate system by the reference quaternion first
    if k_prime:
        # redefine our basis rotated 45 degrees about y-axis
        basis = [Quaternion.rotation(i,reference_quaternion) for i in basis]
    # make the final rotation
    new_basis = [Quaternion.rotation(i,final_quaternion) for i in basis]
    
    return (new_basis,final_quaternion)
        
        
def decompose_vector(vector,basis):
    '''Convert vector into basis unit vectors

    Parameters:
    ==============
        vector = (x,y,z) vector in global coordinates you wish to convert
                 local coordinates
        basis = [[x1, y1, z1], [x2, y2, z3], [x3, y3, z3]] in which are 
                 the **UNIT VECTORS** of the basis you are converting to.
                 These really should be unit vectors unless you are doing
                 crazy.
    '''
    dot = lambda x,y: sum(x[i]*y[i] for i,v in enumerate(x))
    components = [dot(unit_vec,vector) for unit_vec in basis]
    return components
