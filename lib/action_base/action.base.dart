
enum ActionType {
  ADD,
  UPDATE,
  DELETE,
  UNKNOWN
}

abstract class ActionBase {

  ActionType get type;

  dynamic get item;




}

class Add extends ActionBase {
  
  @override
  ActionType get type => ActionType.ADD;
  
  @override
  // TODO: implement item
  dynamic get item => throw UnimplementedError();

  

}

class Update extends ActionBase {
  
  @override
  ActionType get type => ActionType.UPDATE;
  
  @override
  // TODO: implement item
  dynamic get item => throw UnimplementedError();

}

class Delete extends ActionBase {
  
  @override
  ActionType get type => ActionType.DELETE;
  
  @override
  // TODO: implement item
  dynamic get item => throw UnimplementedError();

}

