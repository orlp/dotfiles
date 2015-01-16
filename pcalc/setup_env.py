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

# clipboard
import pyperclip

def copy(s):
    if isinstance(s, bytes): s = s.decode("utf-8")
    return pyperclip.copy(str(s))

def paste(): return pyperclip.paste()
