package domain

type Application struct {
	ID          int    `db:"id" json:"id"`
	Name        string `db:"name" json:"name"`
	Code        string `db:"code" json:"code"`
	Route       string `db:"route" json:"route"`
	Description string `db:"description" json:"description"`
	CreatedBy   *int   `db:"created_by" json:"created_by"`
	AuthBy      *int   `db:"auth_by" json:"auth_by"`
	CreatedAt   string `db:"created_at" json:"created_at"`
}
