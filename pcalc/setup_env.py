# add this dir to include path
import os
import sys
import inspect

sys.path.append(os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe()))))

# builtins
import builtins

# math.pow is shit, import rest
from math import *
pow = builtins.pow
phi = (1 + 5 ** 0.5) / 2

# fractions and co
from fractions import *
F = Fraction
def lcm(a, b):
    return abs(a*b) // gcd(a, b)

# decimal
import decimal
from decimal import Decimal
D = Decimal

# random
import random
from random import randrange, randint, choice, shuffle, random as rand, uniform

# itertools
import itertools

# collections
from collections import *

# operators
import operator
op = operator

# hashes
import hashlib

def md5(x):
    return hashlib.md5(x.encode("utf-8")).hexdigest()

def sha1(x):
    return hashlib.sha1(x.encode("utf-8")).hexdigest()

def sha256(x):
    return hashlib.sha256(x.encode("utf-8")).hexdigest()

def sha512(x):
    return hashlib.sha256(x.encode("utf-8")).hexdigest()

# better hex and bin
import binascii

def hex(x):
    if isinstance(x, bytes):
        return "0x" + binascii.hexlify(x).decode("utf-8")
    elif isinstance(x, str):
        return "0x" + binascii.hexlify(x.encode("utf-8")).decode("utf-8")
    else:
        return builtins.hex(x)

def bin(x):
    return builtins.bin(int(hex(x), 16))

def unhex(x):
    if isinstance(x, str):
        x = x.encode("utf-8")

    if x.startswith(b"0x"):
        x = x[2:]

    return binascii.unhexlify(x)

# modular multiplicative inverse
def modinv(a, m):
    def egcd(a, b):
        if a == 0:
            return (b, 0, 1)
        else:
            g, y, x = egcd(b % a, a)
            return (g, x - (b // a) * y, y)

    g, x, y = egcd(a, m)
    
    if g != 1:
        raise Exception("modular multiplicative inverse does not exist")
    else:
        return x % m

# average
def avg(*args):
    try:
        return sum(args[0]) / len(args[0])
    except TypeError:
        return sum(args) / len(args)

# pretty printing
from pprint import pprint as pp


# prime functions
def primesbelow(N):
    # http://stackoverflow.com/questions/2068372/fastest-way-to-list-all-primes-below-n-in-python/3035188#3035188
    #""" Input N>=6, Returns a list of primes, 2 <= p < N """
    correction = N % 6 > 1
    N = {0:N, 1:N-1, 2:N+4, 3:N+3, 4:N+2, 5:N+1}[N%6]
    sieve = [True] * (N // 3)
    sieve[0] = False
    for i in range(int(N ** .5) // 3 + 1):
        if sieve[i]:
            k = (3 * i + 1) | 1
            sieve[k*k // 3::2*k] = [False] * ((N//6 - (k*k)//6 - 1)//k + 1)
            sieve[(k*k + 4*k - 2*k*(i%2)) // 3::2*k] = [False] * ((N // 6 - (k*k + 4*k - 2*k*(i%2))//6 - 1) // k + 1)
    return [2, 3] + [(3 * i + 1) | 1 for i in range(1, N//3 - correction) if sieve[i]]

smallprimeset = set(primesbelow(100000))
_smallprimeset = 100000
def isprime(n, precision=7):
    # http://en.wikipedia.org/wiki/Miller-Rabin_primality_test#Algorithm_and_running_time
    if n < 1:
        raise ValueError("Out of bounds, first argument must be > 0")
    elif n <= 3:
        return n >= 2
    elif n % 2 == 0:
        return False
    elif n < _smallprimeset:
        return n in smallprimeset

    d = n - 1
    s = 0
    while d % 2 == 0:
        d //= 2
        s += 1

    for repeat in range(precision):
        a = random.randrange(2, n - 2)
        x = pow(a, d, n)

        if x == 1 or x == n - 1: continue

        for r in range(s - 1):
            x = pow(x, 2, n)
            if x == 1: return False
            if x == n - 1: break
        else: return False

    return True

# https://comeoncodeon.wordpress.com/2010/09/18/pollard-rho-brent-integer-factorization/
def pollard_brent(n):
    if n % 2 == 0: return 2
    if n % 3 == 0: return 3

    y, c, m = random.randint(1, n-1), random.randint(1, n-1), random.randint(1, n-1)
    g, r, q = 1, 1, 1
    while g == 1:
        x = y
        for i in range(r):
            y = (pow(y, 2, n) + c) % n

        k = 0
        while k < r and g==1:
            ys = y
            for i in range(min(m, r-k)):
                y = (pow(y, 2, n) + c) % n
                q = q * abs(x-y) % n
            g = gcd(q, n)
            k += m
        r *= 2
    if g == n:
        while True:
            ys = (pow(ys, 2, n) + c) % n
            g = gcd(abs(x - ys), n)
            if g > 1:
                break

    return g

smallprimes = primesbelow(1000) # might seem low, but 1000*1000 = 1000000, so this will fully factor every composite < 1000000
def primefactors(n, sort=False):
    factors = []

    for checker in smallprimes:
        while n % checker == 0:
            factors.append(checker)
            n //= checker
        if checker > n: break

    if n < 2: return factors

    while n > 1:
        if isprime(n):
            factors.append(n)
            break
        factor = pollard_brent(n) # trial division did not fully factor, switch to pollard-brent
        factors.extend(primefactors(factor)) # recurse to factor the not necessarily prime factor returned by pollard-brent
        n //= factor

    if sort: factors.sort()

    return factors

def factorization(n):
    factors = {}
    for p1 in primefactors(n):
        try:
            factors[p1] += 1
        except KeyError:
            factors[p1] = 1
    return factors

totients = {}
def totient(n):
    if n == 0: return 1

    try: return totients[n]
    except KeyError: pass

    tot = 1
    for p, exp in factorization(n).items():
        tot *= (p - 1)  *  p ** (exp - 1)

    totients[n] = tot
    return tot

# clipboard
import pyperclip

def copy(s):
    if isinstance(s, bytes): s = s.decode("utf-8")
    return pyperclip.copy(str(s))

def paste(): return pyperclip.paste()
