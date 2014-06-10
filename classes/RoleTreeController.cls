public class RoleTreeController {
    public List<Row> rows {get; set;}
    public String rowsjson {get; set;}
    public UserRole con {get; set;}

    public RoleTreeController() {
        String roleId = ApexPages.currentPage().getParameters().get('id');
        con = [SELECT Id, Name, ParentRoleId FROM UserRole WHERE Id = :roleId];
        rows = new List<Row>();
        this.populateRows(new List<UserRole>{con});
        rowsjson = JSON.serialize(rows);
        System.debug(JSON.serialize(rows));
    }

    public void populateRows(List<UserRole> cons) {
        for (UserRole con : cons) {
            rows.add(new Row(con.Id, con.ParentRoleId, con.Name, con.Id));
        }

        List<UserRole> childRoles = [
            SELECT Id, Name, ParentRoleId
            FROM UserRole
            WHERE ParentRoleId IN :cons
        ];
        
        if (childRoles.size() > 0) {
            this.populateRows(childRoles);
        }
    }
    
    public class Row {
        public String name {get; set;}
        public String manager {get; set;}
        public String tooltip {get; set;}
        public String id {get; set;}

        public Row(String n, String m, String t, String id) {
            this.name = n;
            this.manager = m;
            this.tooltip = t;
            this.id = id;
        }
    }
}