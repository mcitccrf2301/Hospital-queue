resource "aws_codestar_project" "mcitccrf2301" {
  id          = "mcitccrf2301"
  name        = "mcitccrf2301"
  description = "mcitccrf2301 Hospital Queue Project"
}

resource "aws_codestar_github_repository" "hospital_queue" {
  project_id  = aws_codestar_project.mcitccrf2301.id
  repository  = "Hospital-queue"
  owner       = "mcitccrf2301" 
  oauth_token = var.github_token  
}

output "project_id" {
  value = aws_codestar_project.mcitccrf2301.id
}
