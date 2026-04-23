import enum
from sqlalchemy import Column, Integer, String, DateTime, Date, Enum, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database import Base

class StatusEnum(str, enum.Enum):
    pending = "pendiente"
    completed = "completada"

class PriorityEnum(str, enum.Enum):
    low = "baja"
    medium = "media"
    high = "alta"

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, nullable=False)
    role = Column(String, default="standard")
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    tasks = relationship("Task", back_populates="owner", cascade="all, delete")

class Task(Base):
    __tablename__ = "tasks"
    task_id = Column(Integer, primary_key=True, index=True)
    task_name = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    status = Column(Enum(StatusEnum), default=StatusEnum.pending)
    priority = Column(Enum(PriorityEnum), default=PriorityEnum.medium)
    due_date = Column(Date, nullable=True)
    reminder_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    owner = relationship("User", back_populates="tasks")
