//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // Return the number of rows for the table.
       return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create the cell
        let cell = UITableViewCell()

        // Configure the cell (i.e. update UI elements like labels, image views, etc.)
        // Get the row where the cell will be placed using the `row` property on the passed in `indexPath` (i.e., `indexPath.row`)
            cell.textLabel?.text = "Row \(indexPath.row)"

        // Return the cell for use in the respective table view row
            return cell
    }
    
    
    @IBOutlet weak var postsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign table view data source
        postsTableView.dataSource = self

        fetchPosts()
    }

    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    let posts = blog.response.posts

                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
