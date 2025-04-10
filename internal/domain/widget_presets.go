package domain

type WidgetPreset struct {
	ID        int    `db:"id" json:"id"`
	Name      string `db:"name" json:"name"`
	Type      string `db:"type" json:"type"`
	Props     string `db:"props" json:"props"`
	CreatedBy *int   `db:"created_by" json:"created_by"`
	CreatedAt string `db:"created_at" json:"created_at"`
}
