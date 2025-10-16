import 'package:flutter/material.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:jobs_app/utils/mybutton.dart';
import 'package:jobs_app/utils/offshiftscreen.dart';
import 'package:provider/provider.dart';
import 'package:jobs_app/auth/loginScreen.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/Controller/Controller.dart';
import 'package:intl/intl.dart';

class Accountscreen extends StatefulWidget {
  const Accountscreen({super.key});

  @override
  State<Accountscreen> createState() => _AccountscreenState();
}

class _AccountscreenState extends State<Accountscreen> {
  final Controller controller = Controller();

  Map<String, dynamic> workerinfo = {};
  Map<String, dynamic> userinfo = {};
  List<Map<String, dynamic>> services = [];
  bool isLoading = true;

  Future<void> getprofile() async {
    try {
      final Map<String, dynamic> res = await controller.getmyprofile();
if (!mounted) return;
setState(() {        userinfo = res["user"] ?? res?? {};
        workerinfo = res["workerinfo"] ?? {};
        services = (res['services'] as List<dynamic>?)
                ?.map((item) => item as Map<String, dynamic>)
                .toList() ??
            [];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching profile: $e");
if (!mounted) return;
setState(() {        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getprofile();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F5F9),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final bool isWorker = userinfo["role"] == "WORKER";
return Scaffold(
  backgroundColor: const Color(0xFFF4F5F9),
  body: SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Account",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.grey[900]),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none, size: 26),
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundImage: (userinfo["imgprofile"] is String && (userinfo["imgprofile"] as String).isNotEmpty)
                          ? NetworkImage(userinfo["imgprofile"])
                          : null,
                      child: (userinfo["imgprofile"] == null || (userinfo["imgprofile"] as String).isEmpty)
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (userinfo["name"] is String) ? userinfo["name"] as String : "",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            (userinfo["email"] is String) ? userinfo["email"] as String : "",
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isWorker && (workerinfo["description"] is String) && (workerinfo["description"] as String).isNotEmpty)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.all(14),
                child: Text(
                  workerinfo["description"] as String,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            if (isWorker) const SizedBox(height: 16),
            if (isWorker)
              Text("My Services", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey[900])),
            if (isWorker) const SizedBox(height: 10),
            if (isWorker)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.all(12),
                child: services.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: Text("No services yet", style: TextStyle(color: Colors.grey[600]))),
                      )
                    : Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: services.map((service) {
                          final info = (service["serviceInfo"] is Map) ? Map<String, dynamic>.from(service["serviceInfo"]) : <String, dynamic>{};
                          final title = (info["title"] is String) ? info["title"] as String : "Unknown";
                          final url = (info["url"] is String && (info["url"] as String).isNotEmpty)
                              ? info["url"] as String
                              : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width - 64) / 3,
                            child: Column(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[100]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.build, size: 36),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text("EDIT PROFILE"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(userinfo: userinfo)))
                          .then((_) => getprofile());
                    },
                  ),
                  if (isWorker)
                    const Divider(height: 1),
                  if (isWorker)
                    ListTile(
                      leading: const Icon(Icons.work_outline),
                      title: const Text("EDIT SERVICES"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditServicesScreen(services: services)))
                            .then((_) => getprofile());
                      },
                    ),
                  if (isWorker)
                    const Divider(height: 1),
                  if (isWorker)
                    ListTile(
                      leading: const Icon(Icons.history_toggle_off_rounded),
                      title: const Text("Off Shifts"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const OffShiftScreen()))
                            .then((_) => getprofile());
                      },
                    ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Log Out"),
                    trailing: auth.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      try {
                        await auth.logout();
                        if (!auth.isAuthenticated) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout failed: $e'), backgroundColor: const Color.fromARGB(255, 149, 59, 52)));
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  ),
  
);
  }}

// Placeholder screens you must implement or import:




// ========== Edit Profile ==========

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userinfo;

  const EditProfileScreen({super.key, required this.userinfo});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController locationController;
  late TextEditingController phoneController;
  late TextEditingController imgController;
  Controller controller = Controller();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userinfo["name"]);
    emailController = TextEditingController(text: widget.userinfo["email"]);
    locationController =
        TextEditingController(text: widget.userinfo["location"]);
    phoneController = TextEditingController(text: widget.userinfo["phone"]);
    imgController =
        TextEditingController(text: widget.userinfo["imgprofile"]);
  }

  void _saveProfile() async {
    final updatedData = {
      "name": nameController.text,
      "email": emailController.text,
      "location": locationController.text,
      "phone": phoneController.text,
      "imgprofile": imgController.text,
    };

    print("Saving profile: $updatedData");

    controller.updateWorkerProfile(updatedData);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name")),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email")),
            TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location")),
            TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone")),
            TextField(
                controller: imgController,
                decoration: const InputDecoration(labelText: "Image URL")),
            const SizedBox(height: 20),
            MyButton(
             "Save Changes",             _saveProfile,

            ),
          ],
        ),
      ),
    );
  }
}

class EditServicesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> services;

  const EditServicesScreen({super.key, required this.services});

  @override
  State<EditServicesScreen> createState() => _EditServicesScreenState();
}

class _EditServicesScreenState extends State<EditServicesScreen> {
  final Controller controller = Controller();
  bool isLoading = false;

  // Existing services to display readonly
  late List<Map<String, dynamic>> existingServices;

  // New services user can add before saving
  List<Map<String, dynamic>> newServices = [];

  // Controllers for new services
  List<TextEditingController> priceControllers = [];
  List<TextEditingController> descControllers = [];

  List<Map<String, dynamic>> serviceTypes = [];

  @override
  void initState() {
    super.initState();
    existingServices = List<Map<String, dynamic>>.from(widget.services);
    fetchServiceTypes();
  }

  Future<void> fetchServiceTypes() async {
    try {
      final typesRaw = await controller.getservicestypes();
      final types = typesRaw
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
if (!mounted) return;
setState(() {        serviceTypes = types;
      });
    } catch (e) {
      print("Failed to load service types: $e");
    }
  }

  void addNewServiceRow() {
if (!mounted) return;
setState(() {      newServices.add({
        "serviceTypeId": null,
        "serviceInfo": {},
        "price": 0,
        "description": "",
      });
      priceControllers.add(TextEditingController());
      descControllers.add(TextEditingController());
    });
  }

  void deleteNewService(int index) {
if (!mounted) return;
setState(() {      newServices.removeAt(index);
      priceControllers.removeAt(index);
      descControllers.removeAt(index);
    });
  }

  Future<void> saveNewServices() async {
    setState(() => isLoading = true);

    try {
      for (int i = 0; i < newServices.length; i++) {
        final service = newServices[i];
        final serviceTypeId = service["serviceTypeId"];
        if (serviceTypeId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a service type for all new entries")),
          );
          setState(() => isLoading = false);
          return;
        }
        final body = {
          "price": int.tryParse(priceControllers[i].text) ?? 0,
          "description": descControllers[i].text.trim(),
        };
        await controller.addservices(serviceTypeId,body);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      print("Error saving services: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save services")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

    Widget buildReadOnlyServiceCard(Map<String, dynamic> service) {
    final serviceInfo = service["serviceInfo"] ?? {};
    final title = serviceInfo["title"] ?? "Unknown";
    final price = service["price"] ?? 0;
    final description = service["description"] ?? "";

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Price: \$${price.toString()}"),
                  const SizedBox(height: 8),
                  Text("Description: ${description.isEmpty ? '-' : description}"),
                ],
              ),
            ),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Delete Service"),
                    content: const Text("Are you sure you want to delete this service?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await controller.deleteWorkerService(service["id"]);
if (!mounted) return;
setState(() {                    existingServices.remove(service);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget buildNewServiceCard(int i) {
    final service = newServices[i];
    final serviceTypeId = service["serviceTypeId"];

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<int?>(
                    value: serviceTypeId,
                    hint: const Text("Select Service Type"),
                    isExpanded: true,
                    items: serviceTypes.map((type) {
                      return DropdownMenuItem<int>(
                        value: type["id"],
                        child: Text(type["title"] ?? "Unknown"),
                      );
                    }).toList(),
                    onChanged: (selectedId) {
if (!mounted) return;
setState(() {                        newServices[i]["serviceTypeId"] = selectedId;
                        final chosenType = serviceTypes.firstWhere(
                            (t) => t["id"] == selectedId,
                            orElse: () => {});
                        newServices[i]["serviceInfo"] = chosenType;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteNewService(i),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceControllers[i],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descControllers[i],
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Display read-only existing services
            if (existingServices.isNotEmpty) ...[
              const Text("Existing Services", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: existingServices.length,
                  itemBuilder: (context, index) {
                    return buildReadOnlyServiceCard(existingServices[index]);
                  },
                ),
              ),
            ] else
              const Text("No existing services"),

            const Divider(height: 30, thickness: 2),

            // New services section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Add New Services", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addNewServiceRow,
                ),
              ],
            ),
            if (newServices.isEmpty)
              const Text("Tap + to add a new service"),
            if (newServices.isNotEmpty)
           Flexible(
  child: ListView.builder(
    itemCount: newServices.length,
    itemBuilder: (context, i) => buildNewServiceCard(i),
  ),
),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: newServices.isEmpty ? null : saveNewServices,
                child: const Text("Save New Services"),
              ),
      ),
    );
  }
}


