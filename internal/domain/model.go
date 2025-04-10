package domain

// type User struct {
// 	ID        int    `db:"id"`
// 	Email     string `db:"email"`
// 	Name      string `db:"name"`
// 	Role      string `db:"role"`
// 	CreatedAt string `db:"created_at"`
// }

// type Application struct {
// 	ID        int    `db:"id"`
// 	Name      string `db:"name"`
// 	Code      string `db:"code"`
// 	Route     string `db:"route"`
// 	Description *string `db:"description"`
// 	CreatedBy *int   `db:"created_by"`
// 	AuthBy    *int   `db:"auth_by"`
// 	CreatedAt string `db:"created_at"`
// }

// type ApplicationCollaborator struct {
// 	ID            int    `db:"id"`
// 	ApplicationID int    `db:"application_id"`
// 	UserID        int    `db:"user_id"`
// 	Role          string `db:"role"`
// }

// type Screen struct {
// 	ID          int    `db:"id"`
// 	ApplicationID int  `db:"application_id"`
// 	Name        string `db:"name"`
// 	Code        string `db:"code"`
// 	Route       string `db:"route"`
// 	Description *string `db:"description"`
// 	Params      *string `db:"params"`
// 	Validate    *string `db:"validate"`
// 	AuthBy      *int   `db:"auth_by"`
// 	CreatedAt   string `db:"created_at"`
// }

// type Widget struct {
// 	ID         int     `db:"id"`
// 	ScreenID   int     `db:"screen_id"`
// 	ParentID   *int    `db:"parent_id"`
// 	Type       string  `db:"type"`
// 	Props      *string `db:"props"`
// 	ChildIndex *int    `db:"child_index"`
// 	AuthBy     *int    `db:"auth_by"`
// 	CreatedAt  string  `db:"created_at"`
// }

// type WidgetPreset struct {
// 	ID        int    `db:"id"`
// 	Name      string `db:"name"`
// 	Type      string `db:"type"`
// 	Props     *string `db:"props"`
// 	CreatedBy *int   `db:"created_by"`
// 	CreatedAt string `db:"created_at"`
// }

// type AppConnection struct {
// 	ID            int    `db:"id"`
// 	ApplicationID int    `db:"application_id"`
// 	Name          string `db:"name"`
// 	Type          string `db:"type"`
// 	Config        *string `db:"config"`
// 	CreatedAt     string `db:"created_at"`
// }

// type WidgetBinding struct {
// 	ID            int     `db:"id"`
// 	WidgetID      int     `db:"widget_id"`
// 	ConnectionID  int     `db:"connection_id"`
// 	Endpoint      *string `db:"endpoint"`
// 	Method        *string `db:"method"`
// 	QueryParams   *string `db:"query_params"`
// 	Headers       *string `db:"headers"`
// 	Body          *string `db:"body"`
// 	ResponsePath  *string `db:"response_path"`
// 	BindingKey    *string `db:"binding_key"`
// }

// type AuthBinding struct {
// 	ID               int     `db:"id"`
// 	ApplicationID    int     `db:"application_id"`
// 	Method           string  `db:"method"`
// 	LoginEndpoint    string  `db:"login_endpoint"`
// 	CredentialsSchema *string `db:"credentials_schema"`
// 	TokenPath        *string `db:"token_path"`
// 	ResponseUserPath *string `db:"response_user_path"`
// }
