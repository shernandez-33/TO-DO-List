from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime
from models import StatusEnum, PriorityEnum

class UserCreate(BaseModel):
    username: str
    role: Optional[str] = "standard"

class UserOut(BaseModel):
    id: int
    username: str
    role: str
    created_at: datetime
    model_config = {"from_attributes": True}

class TaskCreate(BaseModel):
    task_name: str
    user_id: int
    status: Optional[StatusEnum] = StatusEnum.pending
    priority: Optional[PriorityEnum] = PriorityEnum.medium
    due_date: Optional[date] = None
    reminder_at: Optional[datetime] = None

class TaskUpdate(BaseModel):
    task_name: Optional[str] = None
    status: Optional[StatusEnum] = None
    priority: Optional[PriorityEnum] = None
    due_date: Optional[date] = None
    reminder_at: Optional[datetime] = None

class TaskOut(BaseModel):
    task_id: int
    task_name: str
    user_id: int
    status: StatusEnum
    priority: PriorityEnum
    due_date: Optional[date]
    reminder_at: Optional[datetime]
    created_at: datetime
    model_config = {"from_attributes": True}
