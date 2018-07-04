from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import MetaData, Column, ForeignKey, String, Integer, LargeBinary
from sqlalchemy.ext.declarative import declarative_base


db = SQLAlchemy()
metadata = MetaData(naming_convention={"ix": "idx_%(column_0_label)s"})
Base = declarative_base(name="adihackDBbase", metadata=metadata)
metadata = Base.metadata


class User(db.Model):
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True, autoincrement=True)
    email = Column(String, unique=True)
    password = Column(String)
    public_key = Column(String)
    private_key = Column(String)


class UserInfo(db.Model):
    __tablename__ = 'user_info'
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('user.id'), index=True)
    sex = Column(String(10))
    age = Column(Integer)
    city = Column(String(50))


class Data(db.Model):
    __tablename__ = 'data'
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('user.id'), index=True)
    data = Column(LargeBinary)


class DataScientist(db.Model):
    __tablename__ = 'data_scientist'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, unique=True)
    token = Column(String, index=True)


class DataAuth(db.Model):
    __tablename__ = 'data_auth'
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('user.id'))
    data_scientist_id = Column(Integer, ForeignKey('data_scientist.id'))
