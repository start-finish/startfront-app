import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.startfront.dev"
            resValue(type = "string", name = "app_name", value = "StartFront Dev")
        }
        create("uat") {
            dimension = "flavor-type"
            applicationId = "com.startfront.uat"
            resValue(type = "string", name = "app_name", value = "StartFront UAT")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.startfront"
            resValue(type = "string", name = "app_name", value = "StartFront")
        }
    }
}