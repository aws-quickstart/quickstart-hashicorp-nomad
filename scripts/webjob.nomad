job "webjob" {
  datacenters = ["__DC__"]
  type = "service"
  update {
    stagger = "30s"
    max_parallel = 1
  }
  group "webs" {
    count = 1
    task "frontend" {
      driver = "docker"
      config {
        image = "nginx:latest"
      }
      service {
        port = "http"
        check {
          type = "http"
          path = "/"
          interval = "10s"
          timeout = "5s"
        }
      }
      resources {
        cpu = 500
        memory = 128
        network {
          mbits = 100
          port "http" {
            static = 80
          }
        }
      }
    }
  }
}
