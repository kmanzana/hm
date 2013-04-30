#= require jquery
#= require ../../vendor/assets/javascripts/angular.min
#= require helpers/angular-mocks
#= require controllers/dash

describe('DashCtrl', function() {
  var scope, ctrl, $httpBackend;
  var children = [{"age_group":"6-8","avatar":null,"created_at":"2013-02-15T14:30:55Z","id":1,"parent_id":1,"password_digest":"$2a$10$aoTfwANODSAaL6MdIZtCjung39Q89xXTsKFQWxYDmMnT1DvZ3516.","points":1151,"remember_token":"OPrgR7h0f0o5c5R3MQGaLA","updated_at":"2013-03-23T00:09:56Z","username":"my_child"},{"age_group":"8-10","avatar":null,"created_at":"2013-03-01T17:44:13Z","id":2,"parent_id":1,"password_digest":"$2a$10$WQutrxR0b2/uzzgze4165OM3okUZRUkc6b0o3XDtH.vmsn.RNuwP.","points":0,"remember_token":"8E2rUZzrX70g0GEzkUiPiw","updated_at":"2013-03-01T17:44:45Z","username":"another_child"}];

  beforeEach(inject(function(_$httpBackend_, $rootScope, $controller){
    $httpBackend = _$httpBackend_;
    $httpBackend.expectGET('/children_your.json').respond(children);
    $httpBackend.expectGET('/completed_challenges.json').respond();

    scope = $rootScope.$new();
    ctrl = $controller(DashCtrl, {$scope: scope});
  }));

  it('should create "children" model with 2 children fetched from xhr', function() {
    expect(scope.children).toBeUndefined();
    $httpBackend.flush();

    expect(scope.children).toEqual(children);
  });

});

/*    it('should set the default value of orderProp model', function() {
      expect(scope.orderProp).toBe('age');
    }); */