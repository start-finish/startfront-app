package domain

type WidgetPreset struct {
	ID        int    `db:"id" json:"id"`
	Name      string `db:"name" json:"name"`
	Type      string `db:"type" json:"type"`
	Props     string `db:"props" json:"props"`
	AuthBy *int   `db:"auth_by" json:"auth_by"`
}
