SELECT DISTINCT
    A.name, A.address, A.gender, A.birthdate,
    B.name, B.address, B.gender, B.birthdate
FROM A
FULL OUTER JOIN B
    ON A.name= B.name
    AND A.address = B.address
    AND A.gender = B.gender
    AND A.birthdate = B.birthdate;