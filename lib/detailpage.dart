import 'package:flutter/material.dart';
// Import the package for StaggeredGrid (assuming you're using one)
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:full_screen_image/full_screen_image.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // preferredSize: const Size.fromHeight(kToolbarHeight + 50.0),
          // title: Image.asset(
          //   'assets/images/logo.jpg',
          //   width: 150,
          // ),
          // centerTitle: true,
          ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    child: FullScreenWidget(
                      disposeLevel: DisposeLevel.Medium,
                      child: Hero(
                        tag: "img1",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            'https://www.oeaw.ac.at/fileadmin/_processed_/c/2/csm_DSCN2290_1_Rice_Blast_fungus_infecting_plants_-_Nick_Talbot_24f4e5c0ec.jpg',
                            errorBuilder: (context, error, stackTrace) =>
                                Text('Image failed to load'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: FullScreenWidget(
                      disposeLevel: DisposeLevel.Medium,
                      child: Hero(
                        tag: "img2",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            'https://cdn.mos.cms.futurecdn.net/LKPBdrZheh2syZd737vXzP.jpg',
                            errorBuilder: (context, error, stackTrace) =>
                                Text('Image failed to load'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: FullScreenWidget(
                      disposeLevel: DisposeLevel.Medium,
                      child: Hero(
                        tag: "img3",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRq2m5f49ie5y6kq5u9FKB_kWECJjyhTPw4ZxMajOJ-uxdpViyZXDM7dD81UpduPjDQ7Rc&usqp=CAU',
                            errorBuilder: (context, error, stackTrace) =>
                                Text('Image failed to load'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: FullScreenWidget(
                      disposeLevel: DisposeLevel.Medium,
                      child: Hero(
                        tag: "img4",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHpYjTO4JDSz8rr-1H-EB5Dhkc5COyKJcsCEDnIXCAcVWKR_xRBj7MNQISjspSrPIOn_I&usqp=CAU',
                            errorBuilder: (context, error, stackTrace) =>
                                const Text('Image failed to load'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Add some spacing between the grid and text

                  // Other grid tiles with Tsile widgets
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(10.0), // Margin on all sides
                child: Text(
                  " ជំងឺទង់គ្រោ (Tungro diseases)",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtPs8ubbPPA31JXQNO9P4WAnPpGQTJFINxn34IwJhk2AgIcDmHKMiojrVfcuPMJMxerBc&usqp=CAU'),
                ),
                title: Text('ចុំ បញ្ញា'),
                subtitle: Text('Feb 05 2024'),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "គឺជាជម្ងឺចំបងគេ ក្នុងប្រវត្តិនៃការសិក្សានូវជម្ងឺវីរុស របស់ដំណាំស្រូវ។ នៅដើមសតវត្សទី២០ អ្នកប្រាជ្ញ ជប៉ុន ម្នាក់ឈ្មោះ តាកាមមាំ បានធ្វើការអះអាងថា ជម្ងឺនេះអាចត្រូវបានចម្លងដោយសត្វល្អិតទៅរុក្ខជាតិ។ រហូតមកដល់បច្ចុប្បន្ននេះ ជម្ងឺទង់គ្រោះត្រូវបានគេជួបប្រទះនៅប្រទេសជប៉ុន កម្ពុជា និងបណ្តាប្រទេសផ្សេងៗទៀត នៅអាស៊ី ។ ក- រោគសញ្ញាពេលដែលបង្ករដោយជម្ងឺនេះ ដើមស្រូវជឿនិងបែកគុម្ពបានតិច ។តែបើសិនជម្ងឺនេះកើតឡើងនៅក្រោយពេអាយុកាល ស្រូវបាន ៦០ថ្ងៃ នោះវា នឹងលេចចេញនូវរោគសញ្ញាផ្សេងទៀតដូចជាស្លឹកពណ៌លឿងខ្ចី ប្រែទៅជាពណ៌លឿងទឹកក្រូច។ ហើយនៅលើស្លឹកខ្ចី មានស្នាមអុចៗពណ៌ទឹកក្រូចចំរុះ ដែលលេចចេញ ពីផ្នែកចុងនៃស្លឹក ។ ចំពោះស្លឹកចាស់ វិញលេចចេញនូវចំនុចតូច១ ពណ៌ប្រេះមានទំហំផ្សេងៗគ្នា ដែលជាហេតុធ្វើឱ្យ ដើមស្រូវចេញផ្កាយឺត មានកូរតូច និងគ្មានដាក់គ្រាប់ ។ ខ- ភ្នាក់ងារបង្ក ភ្នាក់ងារចម្លងជម្ងឺនេះ គឺពពួកមមាច បៃតង Green leafhoppers ដែលមាន លទ្ធភាពក្នុងការចម្លងជម្ងឺពីដើមស្រូវមួយ ទៅដើមស្រូវមួយទៀ ស្រូវមួយទៀត ។ មមាចបែតងដែលបានជញ្ចក់រុក្ខរសលើរុក្ខជាតិ ដែលមានផ្ទុកជម្ងឺ វីរុស គឺវាអាចចម្លងទៅរុក្ខជាតិដទៃទៀត ទៀត ក្នុងរយះពេល១-៥ថ្ងៃ។ ជម្ងឺនេះនឹងលេចចេញនូវរោគសញ្ញាលើរុក្ខជាតិ ចម្លងក្រោយពេលដែលដែលវីរុសត្រូវបា ត្រូវបានចម្លងទៅរុក្ខជាតិនោះ ក្នុងរយៈពេលពី ៧ ទៅ១០ថ្ងៃ ។ គ- វិធានការទប់ស្កាត់ និងកំចាត់ ត្រូវធ្វើការប្រមូល ឬដកយកចេញ និងដុតចោលជាបន្ទាន់ ឬត្រូវធ្វើការបាញ់ថ្នាំ សត្វល្អិតប្រភេទ carbohfuran ក្នុងករណីចាំបាច់ ។ ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
